import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoEditingWidget extends StatefulWidget {
  final String videoPath;
  final VoidCallback onBack;
  final Function(String) onSave;
  final VoidCallback onPost;

  const VideoEditingWidget({
    super.key,
    required this.videoPath,
    required this.onBack,
    required this.onSave,
    required this.onPost,
  });

  @override
  State<VideoEditingWidget> createState() => _VideoEditingWidgetState();
}

class _VideoEditingWidgetState extends State<VideoEditingWidget> {
  double _trimStart = 0.0;
  double _trimEnd = 1.0;
  int _selectedFilter = 0;
  final TextEditingController _captionController = TextEditingController();
  bool _isPublic = true;

  final List<Map<String, dynamic>> _filters = [
    {"name": "Original", "color": Colors.transparent},
    {"name": "Vintage", "color": Colors.brown.withValues(alpha: 0.3)},
    {"name": "Cool", "color": Colors.blue.withValues(alpha: 0.2)},
    {"name": "Warm", "color": Colors.orange.withValues(alpha: 0.2)},
    {"name": "B&W", "color": Colors.grey.withValues(alpha: 0.4)},
  ];

  final List<String> _hashtags = [
    "#fashion",
    "#style",
    "#trending",
    "#sale",
    "#newcollection",
    "#ootd",
    "#shopping",
    "#deals",
    "#quality",
    "#handmade"
  ];

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video preview area
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Video preview placeholder
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[900],
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'play_circle_outline',
                                color: Colors.white,
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Video Preview',
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
                      // Filter overlay
                      if (_selectedFilter > 0)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: _filters[_selectedFilter]["color"] as Color,
                        ),
                    ],
                  ),
                ),
                // Top controls
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: widget.onBack,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'arrow_back',
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          Text(
                            'Edit Video',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => widget.onSave(
                                'draft_${DateTime.now().millisecondsSinceEpoch}'),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Save Draft',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Editing controls
          Expanded(
            flex: 2,
            child: Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Column(
                children: [
                  // Timeline scrubber
                  Container(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trim Video',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Timeline track
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[200]!,
                                      Colors.blue[400]!
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // Trim handles
                              Positioned(
                                left: _trimStart * 80.w,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      _trimStart =
                                          (_trimStart + details.delta.dx / 80.w)
                                              .clamp(0.0, _trimEnd - 0.1);
                                    });
                                  },
                                  child: Container(
                                    width: 4.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.blue, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: _trimEnd * 80.w,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      _trimEnd =
                                          (_trimEnd + details.delta.dx / 80.w)
                                              .clamp(_trimStart + 0.1, 1.0);
                                    });
                                  },
                                  child: Container(
                                    width: 4.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.blue, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Filters
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        SizedBox(
                          height: 10.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            itemBuilder: (context, index) {
                              final filter = _filters[index];
                              final isSelected = _selectedFilter == index;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedFilter = index),
                                child: Container(
                                  margin: EdgeInsets.only(right: 3.w),
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    color: filter["color"] as Color,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey[300]!,
                                      width: isSelected ? 3 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      filter["name"] as String,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Caption and settings
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Caption',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          TextField(
                            controller: _captionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Write a caption...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Hashtag suggestions
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: _hashtags.map((hashtag) {
                              return GestureDetector(
                                onTap: () {
                                  _captionController.text += ' $hashtag';
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: Colors.blue[200]!),
                                  ),
                                  child: Text(
                                    hashtag,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 2.h),
                          // Privacy setting
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Public Video',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              Switch(
                                value: _isPublic,
                                onChanged: (value) =>
                                    setState(() => _isPublic = value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Post button
                  Container(
                    padding: EdgeInsets.all(4.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Post Video',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
