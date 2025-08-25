import 'package:flutter/material.dart';
import 'screen_utils.dart';

class ResponsiveWidgets {
  // Responsive text widget that handles overflow
  static Widget responsiveText(
    BuildContext context,
    String text, {
    double baseSize = 14.0,
    FontWeight? fontWeight,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: ScreenUtils.getResponsiveTextStyle(
        context,
        baseSize: baseSize,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  // Responsive row that wraps content to prevent overflow
  static Widget responsiveRow(
    BuildContext context, {
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) => Flexible(child: child)).toList(),
    );
  }

  // Responsive column with adaptive spacing
  static Widget responsiveColumn(
    BuildContext context, {
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double spacing = 1.0,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        if (index == children.length - 1) {
          return child;
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            SizedBox(height: ScreenUtils.spacing(context, multiplier: spacing)),
          ],
        );
      }).toList(),
    );
  }

  // Responsive list view with adaptive item spacing
  static Widget responsiveListView(
    BuildContext context, {
    required List<Widget> children,
    EdgeInsets? padding,
    double itemSpacing = 1.0,
    ScrollPhysics? physics,
  }) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      physics: physics ?? const BouncingScrollPhysics(),
      itemCount: children.length,
      separatorBuilder: (context, index) => SizedBox(
        height: ScreenUtils.spacing(context, multiplier: itemSpacing),
      ),
      itemBuilder: (context, index) => children[index],
    );
  }

  // Responsive grid view with adaptive sizing
  static Widget responsiveGridView(
    BuildContext context, {
    required List<Widget> children,
    int? crossAxisCount,
    double? maxCrossAxisExtent,
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 1.0,
    double crossAxisSpacing = 1.0,
    EdgeInsets? padding,
  }) {
    return GridView.builder(
      padding: padding ?? EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      gridDelegate: crossAxisCount != null
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: ScreenUtils.spacing(context, multiplier: mainAxisSpacing),
              crossAxisSpacing: ScreenUtils.spacing(context, multiplier: crossAxisSpacing),
            )
          : SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent ?? 200,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: ScreenUtils.spacing(context, multiplier: mainAxisSpacing),
              crossAxisSpacing: ScreenUtils.spacing(context, multiplier: crossAxisSpacing),
            ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  // Responsive button with adaptive sizing
  static Widget responsiveElevatedButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
    Widget? icon,
    bool isExpanded = true,
    ButtonStyle? style,
  }) {
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: ScreenUtils.getResponsiveHeight(context, percent: 0.06),
      child: ElevatedButton(
        onPressed: onPressed,
        style: style ?? ElevatedButton.styleFrom(
          textStyle: ScreenUtils.getResponsiveTextStyle(
            context,
            baseSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.spacing(context, multiplier: 3),
            vertical: ScreenUtils.spacing(context, multiplier: 1.5),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  SizedBox(width: ScreenUtils.spacing(context, multiplier: 1)),
                  Text(text),
                ],
              )
            : Text(text),
      ),
    );
  }

  // Responsive card with adaptive content
  static Widget responsiveCard(
    BuildContext context, {
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? elevation,
    ShapeBorder? shape,
    Color? color,
  }) {
    return Card(
      margin: margin ?? EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 1)),
      elevation: elevation ?? 2.0,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtils.spacing(context, multiplier: 1.5)),
      ),
      color: color,
      child: Padding(
        padding: padding ?? EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 1.5)),
        child: child,
      ),
    );
  }

  // Responsive image with adaptive sizing
  static Widget responsiveImage(
    BuildContext context, {
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(
        ScreenUtils.spacing(context, multiplier: 1),
      ),
      child: Image.network(
        imageUrl,
        width: width ?? ScreenUtils.getResponsiveSize(context, percent: 0.2),
        height: height ?? ScreenUtils.getResponsiveSize(context, percent: 0.2),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? ScreenUtils.getResponsiveSize(context, percent: 0.2),
            height: height ?? ScreenUtils.getResponsiveSize(context, percent: 0.2),
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: ScreenUtils.getIconSize(context, baseSize: 32),
              color: Colors.grey[600],
            ),
          );
        },
      ),
    );
  }

  // Responsive app bar with adaptive title
  static PreferredSizeWidget responsiveAppBar(
    BuildContext context, {
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
      title: responsiveText(
        context,
        title,
        baseSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: ScreenUtils.getAppBarHeight(context),
    );
  }

  // Responsive bottom navigation bar
  static Widget responsiveBottomNavigationBar(
    BuildContext context, {
    required int currentIndex,
    required Function(int) onTap,
    required List<BottomNavigationBarItem> items,
  }) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: ScreenUtils.getResponsiveTextStyle(
        context,
        baseSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: ScreenUtils.getResponsiveTextStyle(
        context,
        baseSize: 12,
      ),
    );
  }

  // Responsive dialog with adaptive content
  static Future<T?> showResponsiveDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
    String? title,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: title != null
            ? responsiveText(
                context,
                title,
                baseSize: 18,
                fontWeight: FontWeight.bold,
              )
            : null,
        content: child,
        actionsPadding: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      ),
    );
  }

  // Responsive snackbar with adaptive text
  static void showResponsiveSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: responsiveText(
          context,
          message,
          baseSize: 14,
          color: Colors.white,
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(ScreenUtils.spacing(context, multiplier: 2)),
      ),
    );
  }
}
