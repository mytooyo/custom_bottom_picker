import 'package:flutter/material.dart';

class CustomBottomPickerOptions {
  const CustomBottomPickerOptions({
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.activeColor,
    this.activeTextColor,
    this.backgroundDecoration,
    this.pickerTitle,
    this.pickerTitleTextStyle,
  });

  /// #### Picker Background Color
  /// default is `Theme.of(context).scaffoldBackgroundColor`
  final Color? backgroundColor;

  /// #### Picket Foreground Color
  /// default is `Theme.of(context).cardColor`
  final Color? foregroundColor;

  /// #### Picker Text Color
  /// default is `Theme.of(context).textTheme.bodyLarge?.color`
  final Color? textColor;

  /// #### Active Color
  /// Use the color of the currently selected date or button
  /// in the calendar as a color to indicate the selection status.
  /// If not specified, `Theme.of(context).primaryColor` color by default.
  final Color? activeColor;

  /// #### Active Text Color
  /// activeColor is used as the background color and activeTextColor as the text color.
  /// Default color is white.
  final Color? activeTextColor;

  /// BoxDecoration of the widget displayed on the backmost side of the picker.
  /// If not specified, it will be a standard BoxDecoration with
  /// the color specified in the normal backgroundColor (default).
  ///
  /// If both [backgroundColor] and backgroundColor are specified, this one takes precedence.
  final BoxDecoration? backgroundDecoration;

  /// Title to be displayed at the top of the picker
  final String? pickerTitle;

  /// PickerTitle text style
  final TextStyle? pickerTitleTextStyle;
}

extension CustomBottomPickerOptionsExtension on CustomBottomPickerOptions {
  Color getBackgroundColor(BuildContext context) =>
      backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

  Color getForegroundColor(BuildContext context) =>
      foregroundColor ?? Theme.of(context).cardColor;

  Color? getTextColor(BuildContext context) =>
      textColor ?? Theme.of(context).textTheme.bodyLarge?.color;

  Color getActiveColor(BuildContext context) =>
      activeColor ?? Theme.of(context).primaryColor;

  Color getActiveTextColor(BuildContext context) =>
      activeTextColor ?? Colors.white;

  bool get isTopTitleHeader => pickerTitle != null && pickerTitle!.isNotEmpty;
}
