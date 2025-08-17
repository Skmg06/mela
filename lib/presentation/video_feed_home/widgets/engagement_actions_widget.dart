import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class EngagementActionsWidget extends StatefulWidget {
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onShop;

  const EngagementActionsWidget({
    super.key,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onShop,
  });

  @override
  State<EngagementActionsWidget> createState() =>
      _EngagementActionsWidgetState();
}

class _EngagementActionsWidgetState extends State<EngagementActionsWidget>
    with TickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _likeRotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));

    _likeRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });
    widget.onLike?.call();
  }

  void _handleAction(VoidCallback? callback) {
    HapticFeedback.selectionClick();
    callback?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            onTap: _handleLike,
            child: AnimatedBuilder(
              animation: _likeAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _likeScaleAnimation.value,
                  child: Transform.rotate(
                    angle: _likeRotationAnimation.value,
                    child: CustomIconWidget(
                      iconName: widget.isLiked ? 'favorite' : 'favorite_border',
                      color:
                          widget.isLiked ? AppTheme.errorLight : Colors.white,
                      size: 7.w,
                    ),
                  ),
                );
              },
            ),
            count: widget.likeCount,
          ),
          SizedBox(height: 3.h),
          _buildActionButton(
            onTap: () => _handleAction(widget.onComment),
            child: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: Colors.white,
              size: 7.w,
            ),
            count: widget.commentCount,
          ),
          SizedBox(height: 3.h),
          _buildActionButton(
            onTap: () => _handleAction(widget.onShare),
            child: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 7.w,
            ),
            count: widget.shareCount,
          ),
          SizedBox(height: 3.h),
          _buildActionButton(
            onTap: () => _handleAction(widget.onShop),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: 'shopping_bag',
                color: Colors.white,
                size: 5.w,
              ),
            ),
            showCount: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required Widget child,
    required VoidCallback onTap,
    int count = 0,
    bool showCount = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(child: child),
            ),
            if (showCount && count > 0) ...[
              SizedBox(height: 0.5.h),
              Text(
                _formatCount(count),
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}