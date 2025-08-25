import 'package:flutter/material.dart';

class ResponsiveSizes {
  static double cardWidth(
    BuildContext context, {
    double percent = 0.45,
    double min = 140,
    double max = 200,
  }) {
    final width = MediaQuery.of(context).size.width;
    return (width * percent).clamp(min, max);
  }

  static double cardHeight(
    BuildContext context, {
    double widthPercent = 0.45,
    double ratio = 1.25,
    double min = 160,
    double max = 250,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = (width * widthPercent * ratio).clamp(min, max);
    return height;
  }

  static double imageHeight(
    BuildContext context, {
    double widthPercent = 0.45,
    double ratio = 0.6,
    double min = 80,
    double max = 180,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = (width * widthPercent * ratio).clamp(min, max);
    return height;
  }

  // Add more responsive size helpers as needed
}
