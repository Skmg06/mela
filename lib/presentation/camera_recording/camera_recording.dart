import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/product_tagging_widget.dart';
import './widgets/video_editing_widget.dart';

class CameraRecording extends StatefulWidget {
  const CameraRecording({super.key});

  @override
  State<CameraRecording> createState() => _CameraRecordingState();
}

class _CameraRecordingState extends State<CameraRecording>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isFlashOn = false;
  bool _showProductTagging = false;
  bool _showVideoEditing = false;
  String _recordingTime = '00:00';
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  String? _recordedVideoPath;
  final ImagePicker _imagePicker = ImagePicker();
  late AnimationController _recordButtonAnimationController;
  late Animation<double> _recordButtonAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _recordButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _recordButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _recordButtonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      if (!await _requestCameraPermission()) {
        _showPermissionDialog();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showErrorDialog('No cameras available');
        return;
      }

      // Select appropriate camera
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      // Initialize camera controller
      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();

      // Apply platform-specific settings
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true; // Browser handles permissions

    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    return cameraStatus.isGranted && microphoneStatus.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported on this device
        }
      }
    } catch (e) {
      // Settings not supported
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      // Flash not supported
    }
  }

  Future<void> _flipCamera() async {
    if (_cameraController == null || _cameras.length < 2) return;

    try {
      final currentCamera = _cameraController!.description;
      final newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection != currentCamera.lensDirection,
        orElse: () => currentCamera,
      );

      if (newCamera == currentCamera) return;

      await _cameraController!.dispose();
      _cameraController = CameraController(
        newCamera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {});
      }
      HapticFeedback.lightImpact();
    } catch (e) {
      _showErrorDialog('Failed to flip camera');
    }
  }

  Future<void> _toggleRecording() async {
    if (_cameraController == null) return;

    try {
      if (_isRecording) {
        await _stopRecording();
      } else {
        await _startRecording();
      }
    } catch (e) {
      _showErrorDialog('Recording failed: ${e.toString()}');
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.startVideoRecording();

      setState(() {
        _isRecording = true;
        _recordingSeconds = 0;
        _recordingTime = '00:00';
      });

      _recordButtonAnimationController.forward();
      HapticFeedback.mediumImpact();

      // Start recording timer
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingSeconds++;
          final minutes = _recordingSeconds ~/ 60;
          final seconds = _recordingSeconds % 60;
          _recordingTime =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        });
      });
    } catch (e) {
      _showErrorDialog('Failed to start recording');
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null) return;

    try {
      final videoFile = await _cameraController!.stopVideoRecording();
      _recordingTimer?.cancel();

      setState(() {
        _isRecording = false;
        _recordedVideoPath = videoFile.path;
        _showVideoEditing = true;
      });

      _recordButtonAnimationController.reverse();
      HapticFeedback.mediumImpact();
    } catch (e) {
      _showErrorDialog('Failed to stop recording');
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        setState(() {
          _recordedVideoPath = video.path;
          _showVideoEditing = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to select video from gallery');
    }
  }

  void _showEffects() {
    // Show effects bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Effects',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final effects = [
                    'Beauty',
                    'Blur',
                    'Vintage',
                    'B&W',
                    'Bright',
                    'Contrast'
                  ];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'auto_fix_high',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            effects[index],
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
            'Please grant camera and microphone permissions to record videos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onProductTagged(Offset position, Map<String, dynamic> product) {
    // Handle product tagging
    HapticFeedback.lightImpact();
  }

  void _onVideoSaved(String draftId) {
    // Handle video draft saving
    Navigator.pushReplacementNamed(context, '/video-feed-home');
  }

  void _onVideoPosted() {
    // Handle video posting
    Navigator.pushReplacementNamed(context, '/video-feed-home');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _recordingTimer?.cancel();
    _recordButtonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showVideoEditing && _recordedVideoPath != null) {
      return VideoEditingWidget(
        videoPath: _recordedVideoPath!,
        onBack: () => setState(() => _showVideoEditing = false),
        onSave: _onVideoSaved,
        onPost: _onVideoPosted,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Initializing Camera...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Camera controls
          if (_isCameraInitialized)
            CameraControlsWidget(
              isRecording: _isRecording,
              isFlashOn: _isFlashOn,
              onFlashToggle: _toggleFlash,
              onCameraFlip: _flipCamera,
              onClose: () => Navigator.pop(context),
              onRecord: _toggleRecording,
              onGallery: _openGallery,
              onEffects: _showEffects,
              recordingTime: _recordingTime,
            ),
          // Product tagging overlay
          ProductTaggingWidget(
            isVisible: _showProductTagging,
            onClose: () => setState(() => _showProductTagging = false),
            onProductTagged: _onProductTagged,
          ),
          // Product tagging button (when not recording)
          if (_isCameraInitialized && !_isRecording)
            Positioned(
              right: 4.w,
              top: 50.h,
              child: GestureDetector(
                onTap: () =>
                    setState(() => _showProductTagging = !_showProductTagging),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: _showProductTagging
                        ? Colors.red.withValues(alpha: 0.8)
                        : Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'local_offer',
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Tag\nProducts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
