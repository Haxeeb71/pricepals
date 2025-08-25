import 'package:flutter/material.dart';

class ScreenUtils {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static EdgeInsets padding(BuildContext context) =>
      MediaQuery.of(context).padding;
  static double devicePixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  // Returns a responsive width based on screen size with safety limits
  static double getResponsiveWidth(
    BuildContext context, {
    double percent = 1.0,
  }) {
    final width = screenWidth(context) * percent;
    // Ensure width doesn't exceed screen bounds
    return width.clamp(0.0, screenWidth(context));
  }

  // Returns a responsive height based on screen size with safety limits
  static double getResponsiveHeight(
    BuildContext context, {
    double percent = 1.0,
  }) {
    final height = screenHeight(context) * percent;
    // Ensure height doesn't exceed screen bounds
    return height.clamp(0.0, screenHeight(context));
  }

  // Get responsive size that maintains aspect ratio
  static double getResponsiveSize(
    BuildContext context, {
    double percent = 1.0,
  }) {
    return (screenWidth(context) + screenHeight(context)) / 2 * percent;
  }

  // Responsive spacing units with overflow protection
  static double spacing(BuildContext context, {double multiplier = 1.0}) {
    final baseSpacing = 8.0 * multiplier * (screenWidth(context) / 375.0);
    // Ensure spacing doesn't get too large on big screens
    return baseSpacing.clamp(4.0, 24.0);
  }

  // Card sizes
  static Size getCardSize(
    BuildContext context, {
    double widthPercent = 0.4,
    double heightPercent = 0.25,
    double minWidth = 120,
    double maxWidth = 180,
    double minHeight = 160,
    double maxHeight = 220,
  }) {
    double width = (screenWidth(context) * widthPercent).clamp(
      minWidth,
      maxWidth,
    );
    double height = (screenHeight(context) * heightPercent).clamp(
      minHeight,
      maxHeight,
    );
    return Size(width, height);
  }

  // Image sizes
  static Size getImageSize(
    BuildContext context, {
    double widthPercent = 0.4,
    double aspectRatio = 1.0,
    double minWidth = 80,
    double maxWidth = 160,
  }) {
    double width = (screenWidth(context) * widthPercent).clamp(
      minWidth,
      maxWidth,
    );
    double height = width / aspectRatio;
    return Size(width, height);
  }

  // Font sizes
  static double getFontSize(BuildContext context, {double baseSize = 14.0}) {
    double scaleFactor = screenWidth(context) / 375.0; // Base on iPhone 8 width
    return (baseSize * scaleFactor).clamp(baseSize * 0.8, baseSize * 1.2);
  }

  // Grid layout
  static int getGridCrossAxisCount(
    BuildContext context, {
    double minWidth = 150,
  }) {
    return (screenWidth(context) / minWidth).floor();
  }

  // Safe horizontal padding that prevents overflow
  static EdgeInsets safeHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: (screenWidth(context) * 0.04).clamp(8, 20),
    );
  }

  // Safe vertical padding that prevents overflow
  static EdgeInsets safeVerticalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      vertical: (screenHeight(context) * 0.02).clamp(8, 16),
    );
  }

  // Enhanced responsive utilities for better overflow prevention

  // Responsive text style with overflow handling
  static TextStyle getResponsiveTextStyle(
    BuildContext context, {
    double baseSize = 14.0,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: getFontSize(context, baseSize: baseSize),
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // Responsive container with adaptive sizing
  static Widget responsiveContainer(
    BuildContext context, {
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BoxDecoration? decoration,
    Alignment? alignment,
  }) {
    return Container(
      width: width != null
          ? (width * screenWidth(context) / 375.0).clamp(
              width * 0.8,
              width * 1.2,
            )
          : null,
      height: height != null
          ? (height * screenHeight(context) / 812.0).clamp(
              height * 0.8,
              height * 1.2,
            )
          : null,
      padding: padding ?? safeHorizontalPadding(context),
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }

  // Responsive list tile with adaptive sizing
  static Widget responsiveListTile(
    BuildContext context, {
    required Widget title,
    Widget? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsets? contentPadding,
  }) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: spacing(context, multiplier: 2),
            vertical: spacing(context, multiplier: 1),
          ),
    );
  }

  // Responsive card with adaptive sizing
  static Widget responsiveCard(
    BuildContext context, {
    required Widget child,
    EdgeInsets? margin,
    double? elevation,
    ShapeBorder? shape,
    Color? color,
  }) {
    return Card(
      margin: margin ?? EdgeInsets.all(spacing(context, multiplier: 1)),
      elevation: elevation ?? 2.0,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              spacing(context, multiplier: 1.5),
            ),
          ),
      color: color,
      child: Padding(
        padding: EdgeInsets.all(spacing(context, multiplier: 1.5)),
        child: child,
      ),
    );
  }

  // Responsive button with adaptive sizing
  static Widget responsiveButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
    ButtonStyle? style,
    Widget? icon,
    bool isExpanded = true,
  }) {
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: 48 * (screenHeight(context) / 812.0).clamp(0.8, 1.2),
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            style ??
            ElevatedButton.styleFrom(
              textStyle: getResponsiveTextStyle(
                context,
                baseSize: 16,
                fontWeight: FontWeight.w600,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: spacing(context, multiplier: 3),
                vertical: spacing(context, multiplier: 1.5),
              ),
            ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  SizedBox(width: spacing(context, multiplier: 1)),
                  Text(text),
                ],
              )
            : Text(text),
      ),
    );
  }

  // Responsive grid with adaptive cross axis count
  static SliverGridDelegateWithMaxCrossAxisExtent responsiveGridDelegate(
    BuildContext context, {
    double maxCrossAxisExtent = 200,
    double mainAxisSpacing = 16,
    double crossAxisSpacing = 16,
    double childAspectRatio = 1.0,
  }) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent:
          maxCrossAxisExtent * (screenWidth(context) / 375.0).clamp(0.8, 1.2),
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }

  // Responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    return (56 * (screenHeight(context) / 812.0)).clamp(48, 64);
  }

  // Responsive bottom navigation bar height
  static double getBottomNavBarHeight(BuildContext context) {
    return (56 * (screenHeight(context) / 812.0)).clamp(48, 64);
  }

  // Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return screenWidth(context) > screenHeight(context);
  }

  // Check if device is a tablet
  static bool isTablet(BuildContext context) {
    return screenWidth(context) > 600;
  }

  // Get responsive icon size
  static double getIconSize(BuildContext context, {double baseSize = 24.0}) {
    return (baseSize * (screenWidth(context) / 375.0)).clamp(
      baseSize * 0.8,
      baseSize * 1.2,
    );
  }

  // Responsive safe area with adaptive padding
  static Widget responsiveSafeArea(
    BuildContext context, {
    required Widget child,
    bool maintainBottomViewPadding = true,
  }) {
    return SafeArea(
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: Padding(
        padding: EdgeInsets.only(
          left: safeHorizontalPadding(context).left,
          right: safeHorizontalPadding(context).right,
          top: safeVerticalPadding(context).top,
          bottom: safeVerticalPadding(context).bottom,
        ),
        child: child,
      ),
    );
  }
}
