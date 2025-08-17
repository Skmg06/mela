import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsSectionWidget extends StatefulWidget {
  final Function(String) onSettingTap;
  final VoidCallback onLogout;

  const SettingsSectionWidget({
    super.key,
    required this.onSettingTap,
    required this.onLogout,
  });

  @override
  State<SettingsSectionWidget> createState() => _SettingsSectionWidgetState();
}

class _SettingsSectionWidgetState extends State<SettingsSectionWidget> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSettingsGroup(
            context,
            "Account",
            [
              _SettingItem(
                icon: 'notifications',
                title: 'Notifications',
                hasSwitch: true,
                switchValue: _notificationsEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              _SettingItem(
                icon: 'payment',
                title: 'Payment Methods',
                onTap: () => widget.onSettingTap('payment'),
              ),
              _SettingItem(
                icon: 'location_on',
                title: 'Shipping Addresses',
                onTap: () => widget.onSettingTap('addresses'),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSettingsGroup(
            context,
            "Preferences",
            [
              _SettingItem(
                icon: 'dark_mode',
                title: 'Dark Mode',
                hasSwitch: true,
                switchValue: _darkModeEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
              _SettingItem(
                icon: 'language',
                title: 'Language',
                subtitle: 'English',
                onTap: () => widget.onSettingTap('language'),
              ),
              _SettingItem(
                icon: 'privacy_tip',
                title: 'Privacy Settings',
                onTap: () => widget.onSettingTap('privacy'),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSettingsGroup(
            context,
            "Support",
            [
              _SettingItem(
                icon: 'help_outline',
                title: 'Help & Support',
                onTap: () => widget.onSettingTap('help'),
              ),
              _SettingItem(
                icon: 'info_outline',
                title: 'About',
                onTap: () => widget.onSettingTap('about'),
              ),
              _SettingItem(
                icon: 'share',
                title: 'Share App',
                onTap: () => widget.onSettingTap('share'),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildDangerZone(context),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    String title,
    List<_SettingItem> items,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return _buildSettingTile(context, item, !isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    _SettingItem item,
    bool showDivider,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        ListTile(
          leading: CustomIconWidget(
            iconName: item.icon,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            size: 24,
          ),
          title: Text(
            item.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: item.subtitle != null
              ? Text(
                  item.subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                )
              : null,
          trailing: item.hasSwitch
              ? Switch(
                  value: item.switchValue ?? false,
                  onChanged: item.onSwitchChanged,
                )
              : CustomIconWidget(
                  iconName: 'chevron_right',
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
          onTap: item.hasSwitch ? null : item.onTap,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
            indent: 16.w,
          ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account Actions",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'download',
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 24,
                ),
                title: Text(
                  "Export Data",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
                onTap: () => widget.onSettingTap('export'),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              ),
              Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.1),
                indent: 16.w,
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'logout',
                  color: Colors.red.shade600,
                  size: 24,
                ),
                title: Text(
                  "Logout",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade600,
                  ),
                ),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: Colors.red.shade600.withValues(alpha: 0.5),
                  size: 20,
                ),
                onTap: widget.onLogout,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              ),
              Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.1),
                indent: 16.w,
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete_forever',
                  color: Colors.red.shade700,
                  size: 24,
                ),
                title: Text(
                  "Delete Account",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                ),
                trailing: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: Colors.red.shade700.withValues(alpha: 0.5),
                  size: 20,
                ),
                onTap: () => widget.onSettingTap('delete'),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingItem {
  final String icon;
  final String title;
  final String? subtitle;
  final bool hasSwitch;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.hasSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap,
  });
}
