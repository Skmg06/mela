import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  pills,
  underline,
  segmented,
}

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final CustomTabBarVariant variant;
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const CustomTabBar({
    super.key,
    this.variant = CustomTabBarVariant.standard,
    required this.tabs,
    this.initialIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
    this.height,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48.0);
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _initializeAnimations();
    _tabController.addListener(_handleTabChange);
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.tabs.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Animate the initially selected tab
    if (widget.initialIndex < _animationControllers.length) {
      _animationControllers[widget.initialIndex].forward();
    }
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final oldIndex = _tabController.previousIndex;
      final newIndex = _tabController.index;

      if (oldIndex < _animationControllers.length) {
        _animationControllers[oldIndex].reverse();
      }
      if (newIndex < _animationControllers.length) {
        _animationControllers[newIndex].forward();
      }

      // Provide haptic feedback
      HapticFeedback.selectionClick();

      widget.onTap?.call(newIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, colorScheme);
      case CustomTabBarVariant.underline:
        return _buildUnderlineTabBar(context, colorScheme);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, colorScheme);
      default:
        return _buildStandardTabBar(context, colorScheme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.onSurface,
        unselectedLabelColor: widget.unselectedColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: widget.indicatorColor ?? colorScheme.onSurface,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildAnimatedTab(tab, index);
        }).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.all(16),
      height: widget.height ?? 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _tabController.index == index;
          return _buildPillTab(
              context, colorScheme, widget.tabs[index], index, isSelected);
        },
      ),
    );
  }

  Widget _buildUnderlineTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.onSurface,
        unselectedLabelColor: widget.unselectedColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: widget.indicatorColor ?? colorScheme.onSurface,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildAnimatedTab(tab, index);
        }).toList(),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Container(
        height: widget.height ?? 48,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _tabController.index == index;
            final isFirst = index == 0;
            final isLast = index == widget.tabs.length - 1;

            return Expanded(
              child: _buildSegmentedTab(
                context,
                colorScheme,
                tab,
                index,
                isSelected,
                isFirst,
                isLast,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAnimatedTab(String text, int index) {
    return AnimatedBuilder(
      animation: _scaleAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimations[index].value,
          child: Tab(text: text),
        );
      },
    );
  }

  Widget _buildPillTab(
    BuildContext context,
    ColorScheme colorScheme,
    String text,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedColor ?? colorScheme.onSurface)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (widget.selectedColor ?? colorScheme.onSurface)
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.surface
                      : (widget.unselectedColor ??
                          colorScheme.onSurface.withValues(alpha: 0.6)),
                  letterSpacing: 0.1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentedTab(
    BuildContext context,
    ColorScheme colorScheme,
    String text,
    int index,
    bool isSelected,
    bool isFirst,
    bool isLast,
  ) {
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedColor ?? colorScheme.onSurface)
                    : Colors.transparent,
                borderRadius: BorderRadius.horizontal(
                  left: isFirst ? const Radius.circular(11) : Radius.zero,
                  right: isLast ? const Radius.circular(11) : Radius.zero,
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? colorScheme.surface
                        : (widget.unselectedColor ??
                            colorScheme.onSurface.withValues(alpha: 0.6)),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
