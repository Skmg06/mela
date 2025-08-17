import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isPlaying;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.isPlaying = true,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _initializeVideo();
    }
    if (oldWidget.isPlaying != widget.isPlaying) {
      _handlePlayPause();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });

        _controller!.setLooping(true);
        if (widget.isPlaying) {
          _controller!.play();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
        });
      }
    }
  }

  void _handlePlayPause() {
    if (_controller != null && _isInitialized) {
      if (widget.isPlaying) {
        _controller!.play();
      } else {
        _controller!.pause();
      }
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    _hasError = false;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: _buildVideoContent(),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
        if (!widget.isPlaying)
          Center(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'play_arrow',
                color: Colors.white,
                size: 12.w,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading video...',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Unable to load video',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isInitialized = false;
              });
              _initializeVideo();
            },
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}