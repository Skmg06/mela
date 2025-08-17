import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  transparent,
  video,
  search,
  profile,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomAppBarVariant variant;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final bool showSearchIcon;
  final VoidCallback? onSearchPressed;
  final bool showProfileIcon;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.standard,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.onBackPressed,
    this.showSearchIcon = false,
    this.onSearchPressed,
    this.showProfileIcon = false,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: title != null ? _buildTitle(context) : null,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: _getElevation(),
      scrolledUnderElevation: _getScrolledUnderElevation(),
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      systemOverlayStyle: _getSystemOverlayStyle(context),
      bottom: bottom,
      flexibleSpace: variant == CustomAppBarVariant.video
          ? _buildVideoFlexibleSpace(context)
          : null,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchField(context);
      case CustomAppBarVariant.video:
        return Text(
          title!,
          style: GoogleFonts.inter(
            fontSize: 16,
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
        );
      default:
        return Text(
          title!,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        );
    }
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products, sellers...',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (automaticallyImplyLeading && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actionWidgets = [];

    // Add search icon if enabled
    if (showSearchIcon && variant != CustomAppBarVariant.search) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: onSearchPressed ??
              () {
                // Navigate to search or show search functionality
              },
          tooltip: 'Search',
        ),
      );
    }

    // Add profile icon if enabled
    if (showProfileIcon) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.account_circle, size: 24),
          onPressed: onProfilePressed ??
              () {
                Navigator.pushNamed(context, '/user-profile');
              },
          tooltip: 'Profile',
        ),
      );
    }

    // Add custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    // Add spacing for video variant
    if (variant == CustomAppBarVariant.video && actionWidgets.isNotEmpty) {
      actionWidgets.add(const SizedBox(width: 8));
    }

    return actionWidgets;
  }

  Widget? _buildVideoFlexibleSpace(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }

  double _getElevation() {
    if (elevation != null) return elevation!;

    switch (variant) {
      case CustomAppBarVariant.transparent:
      case CustomAppBarVariant.video:
        return 0;
      case CustomAppBarVariant.search:
        return 2;
      default:
        return 0;
    }
  }

  double _getScrolledUnderElevation() {
    switch (variant) {
      case CustomAppBarVariant.transparent:
      case CustomAppBarVariant.video:
        return 0;
      default:
        return 4;
    }
  }

  Color? _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor;

    switch (variant) {
      case CustomAppBarVariant.transparent:
      case CustomAppBarVariant.video:
        return Colors.transparent;
      case CustomAppBarVariant.profile:
        return colorScheme.surface;
      default:
        return colorScheme.surface;
    }
  }

  Color? _getForegroundColor(ColorScheme colorScheme) {
    if (foregroundColor != null) return foregroundColor;

    switch (variant) {
      case CustomAppBarVariant.video:
        return Colors.white;
      default:
        return colorScheme.onSurface;
    }
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    switch (variant) {
      case CustomAppBarVariant.video:
        return SystemUiOverlayStyle.light;
      case CustomAppBarVariant.transparent:
        return brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light;
      default:
        return brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
