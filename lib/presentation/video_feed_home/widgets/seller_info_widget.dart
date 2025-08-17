import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';

class SellerInfoWidget extends StatefulWidget {
  final String sellerName;
  final String sellerAvatar;
  final int followerCount;
  final bool isFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onProfileTap;

  const SellerInfoWidget({
    super.key,
    required this.sellerName,
    required this.sellerAvatar,
    this.followerCount = 0,
    this.isFollowing = false,
    this.onFollow,
    this.onProfileTap,
  });

  @override
  State<SellerInfoWidget> createState() => _SellerInfoWidgetState();
}

class _SellerInfoWidgetState extends State<SellerInfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _followAnimationController;
  late Animation<double> _followScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _followAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _followScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _followAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _followAnimationController.dispose();
    super.dispose();
  }

  void _handleFollow() {
    HapticFeedback.lightImpact();
    _followAnimationController.forward().then((_) {
      _followAnimationController.reverse();
    });
    widget.onFollow?.call();
  }

  void _handleProfileTap() {
    HapticFeedback.selectionClick();
    widget.onProfileTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSellerProfile(),
          SizedBox(height: 1.h),
          _buildFollowerCount(),
          SizedBox(height: 1.5.h),
          _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildSellerProfile() {
    return GestureDetector(
      onTap: _handleProfileTap,
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: widget.sellerAvatar,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              widget.sellerName,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerCount() {
    return Text(
      '${_formatFollowerCount(widget.followerCount)} followers',
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.8),
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

  Widget _buildFollowButton() {
    return AnimatedBuilder(
      animation: _followScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _followScaleAnimation.value,
          child: GestureDetector(
            onTap: _handleFollow,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: widget.isFollowing
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(6.w),
                border: widget.isFollowing
                    ? Border.all(color: Colors.white, width: 1)
                    : null,
              ),
              child: Text(
                widget.isFollowing ? 'Following' : 'Follow',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.isFollowing
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatFollowerCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}