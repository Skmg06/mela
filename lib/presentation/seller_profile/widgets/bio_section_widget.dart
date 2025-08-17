import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BioSectionWidget extends StatefulWidget {
  final Map<String, dynamic> sellerData;

  const BioSectionWidget({
    super.key,
    required this.sellerData,
  });

  @override
  State<BioSectionWidget> createState() => _BioSectionWidgetState();
}

class _BioSectionWidgetState extends State<BioSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bio = widget.sellerData["bio"] as String;
    final shouldShowExpand = bio.length > 150;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio Text
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded || !shouldShowExpand
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              "${bio.substring(0, bio.length > 150 ? 150 : bio.length)}...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            secondChild: Text(
              bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),

          if (shouldShowExpand) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? "Show less" : "Show more",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          SizedBox(height: 2.h),

          // Business Details
          Column(
            children: [
              // Location
              if (widget.sellerData["location"] != null) ...[
                _buildDetailRow(
                  context,
                  'location_on',
                  widget.sellerData["location"] as String,
                ),
                SizedBox(height: 1.h),
              ],

              // Website
              if (widget.sellerData["website"] != null) ...[
                _buildDetailRow(
                  context,
                  'language',
                  widget.sellerData["website"] as String,
                  isLink: true,
                ),
                SizedBox(height: 1.h),
              ],

              // Phone
              if (widget.sellerData["phone"] != null) ...[
                _buildDetailRow(
                  context,
                  'phone',
                  widget.sellerData["phone"] as String,
                ),
                SizedBox(height: 1.h),
              ],

              // Email
              if (widget.sellerData["email"] != null) ...[
                _buildDetailRow(
                  context,
                  'email',
                  widget.sellerData["email"] as String,
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),

          // Trust Badges
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              if (widget.sellerData["isVerified"] as bool)
                _buildTrustBadge(
                  context,
                  "Verified Business",
                  'verified',
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
              if (widget.sellerData["hasSecurePayment"] as bool)
                _buildTrustBadge(
                  context,
                  "Secure Payment",
                  'security',
                  AppTheme.successLight,
                ),
              if (widget.sellerData["fastShipping"] as bool)
                _buildTrustBadge(
                  context,
                  "Fast Shipping",
                  'local_shipping',
                  AppTheme.infoLight,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String iconName,
    String text, {
    bool isLink = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          size: 18,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isLink
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.8),
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(
    BuildContext context,
    String label,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 0.8.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
