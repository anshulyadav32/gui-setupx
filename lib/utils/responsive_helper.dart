import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) return 200.0;
    return 250.0;
  }

  static double getRightSidebarWidth(BuildContext context) {
    if (isMobile(context)) return 250.0;
    return 300.0;
  }

  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  static double getGridAspectRatio(BuildContext context) {
    if (isMobile(context)) return 2.0;
    if (isTablet(context)) return 1.8;
    return 1.3;
  }

  static double getGridMargin(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  static double getIconSize(BuildContext context) {
    if (isMobile(context)) return 50.0;
    if (isTablet(context)) return 60.0;
    return 70.0;
  }

  static double getTitleFontSize(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 22.0;
    return 24.0;
  }

  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 12.0;
    return 20.0;
  }

  static double getSpacing(BuildContext context) {
    if (isMobile(context)) return 10.0;
    return 16.0;
  }
}
