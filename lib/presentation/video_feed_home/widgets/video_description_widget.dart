import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class VideoDescriptionWidget extends StatefulWidget {
  final String description;
  final List<Map<String, dynamic>> taggedProducts;
  final VoidCallback? onProductTap;

  const VideoDescriptionWidget({
    super.key,
    required this.description,
    this.taggedProducts = const [],
    this.onProductTap,
  });

  @override
  State<VideoDescriptionWidget> createState() => _VideoDescriptionWidgetState();
}

class _VideoDescriptionWidgetState extends State<VideoDescriptionWidget> {
  bool _isExpanded = false;
  final int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescription(),
          if (widget.taggedProducts.isNotEmpty) ...[
            SizedBox(height: 1.5.h),
            _buildProductTags(),
          ],
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _buildCollapsedDescription(),
            secondChild: _buildExpandedDescription(),
          ),
          if (_shouldShowMoreButton()) ...[
            SizedBox(height: 0.5.h),
            Text(
              _isExpanded ? 'Show less' : 'Show more',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCollapsedDescription() {
    return Text(
      widget.description,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.4,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ],
      ),
      maxLines: _maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildExpandedDescription() {
    return Text(
      widget.description,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.4,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  bool _shouldShowMoreButton() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: GoogleFonts.inter(fontSize: 13.sp),
      ),
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: 80.w);
    return textPainter.didExceedMaxLines;
  }

  Widget _buildProductTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'shopping_bag',
              color: Colors.white.withValues(alpha: 0.8),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              '${widget.taggedProducts.length} product${widget.taggedProducts.length > 1 ? 's' : ''}',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 8.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.taggedProducts.length,
            separatorBuilder: (context, index) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              final product = widget.taggedProducts[index];
              return _buildProductChip(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductChip(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: widget.onProductTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.w),
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.w),
                child: CustomImageWidget(
                  imageUrl: product['image'] as String? ?? '',
                  width: 6.w,
                  height: 6.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product['name'] as String? ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product['price'] as String? ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warningLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}