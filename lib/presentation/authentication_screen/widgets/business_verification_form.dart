import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './auth_input_field.dart';

class BusinessVerificationForm extends StatefulWidget {
  final bool isVisible;
  final Function(Map<String, String>) onBusinessDataChanged;

  const BusinessVerificationForm({
    super.key,
    required this.isVisible,
    required this.onBusinessDataChanged,
  });

  @override
  State<BusinessVerificationForm> createState() =>
      _BusinessVerificationFormState();
}

class _BusinessVerificationFormState extends State<BusinessVerificationForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _businessNameController.addListener(_updateBusinessData);
    _businessTypeController.addListener(_updateBusinessData);
    _taxIdController.addListener(_updateBusinessData);
    _businessAddressController.addListener(_updateBusinessData);
  }

  void _updateBusinessData() {
    widget.onBusinessDataChanged({
      'businessName': _businessNameController.text,
      'businessType': _businessTypeController.text,
      'taxId': _taxIdController.text,
      'businessAddress': _businessAddressController.text,
    });
  }

  @override
  void didUpdateWidget(BusinessVerificationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _taxIdController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return widget.isVisible
            ? Transform.translate(
                offset: Offset(0, (1 - _slideAnimation.value) * 50),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'business',
                              size: 24,
                              color: colorScheme.onSurface,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Business Verification',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Please provide your business details for seller verification',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        AuthInputField(
                          label: 'Business Name',
                          hintText: 'Enter your business name',
                          iconName: 'store',
                          controller: _businessNameController,
                        ),
                        SizedBox(height: 2.h),
                        AuthInputField(
                          label: 'Business Type',
                          hintText: 'e.g., Retail, Fashion, Electronics',
                          iconName: 'category',
                          controller: _businessTypeController,
                        ),
                        SizedBox(height: 2.h),
                        AuthInputField(
                          label: 'Tax ID / Business Registration',
                          hintText: 'Enter your tax identification number',
                          iconName: 'receipt',
                          controller: _taxIdController,
                        ),
                        SizedBox(height: 2.h),
                        AuthInputField(
                          label: 'Business Address',
                          hintText: 'Enter your business address',
                          iconName: 'location_on',
                          controller: _businessAddressController,
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                size: 16,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'Your business will be verified within 24-48 hours',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
