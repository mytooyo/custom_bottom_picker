library custom_bottom_picker;

import 'dart:collection';

import 'package:flutter/material.dart';

import 'src/custom_bottom_picker_options.dart';
import 'src/custom_bottom_picker_widget.dart';

export 'src/custom_bottom_picker_options.dart' show CustomBottomPickerOptions;

/// Show CustomBottomPicker modal bottom sheet.
///
/// The `sections` is a list specifying per-column information to be displayed in the picker.
/// A column is added to the Picker and displayed for the specified amount.
///
/// The `options` is an option to customize the picker display.
/// You can specify the background color, text color, and button color.
/// Specify `pickerTitle` to display the title at the top of the picker
///
/// The `radius` is a rounded corner on both sides of the top in modal display.
///
/// `barrierColor`, `routeSettings`, `transitionAnimationController`, etc. are
/// the parameters that are specified in the normal modal bottom sheet,
/// so please check there for a description of the parameters.
Future<CustomBottomPickerResult?> showCustomBottomPicker({
  required BuildContext context,
  CustomBottomPickerOptions? options,
  required List<CustomBottomPickerSection> sections,
  double radius = 24,
  Color? barrierColor,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  CloseButtonBuilder? closeButtonBuilder,
}) async {
  final opt = options ?? const CustomBottomPickerOptions();
  return await showModalBottomSheet<CustomBottomPickerResult?>(
    context: context,
    backgroundColor:
        opt.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: CustomBottomPickerWidget(
        options: opt,
        sections: sections,
        closeButtonBuilder: closeButtonBuilder,
      ),
    ),
  );
}

/// [CustomBottomPickerSection] is a class for specifying column picker items
///
/// If a title is specified, it can be displayed as a section title at the top of the picker.
/// `flex` is the percentage of the width of each section.
/// If all is 1, the sections are displayed monospaced
///
/// Either `children` or `itemBuilder` must be specified.
/// `children` is simple and useful for normal text (String) only.
///
/// Use `itemBuilder` if you want to display your own widget on the item in the Picker.
/// Please note that the height is fixed.
class CustomBottomPickerSection {
  /// ID to identify the section
  final String? id;

  /// section item title
  /// Specify a title for each item separate from the picker's title
  final String? title;

  /// Set the percentage of width. Default is 1.
  /// Valid items when specifying multiple sections
  final int flex;

  /// Number of list items to display in the section
  final int itemCount;

  /// Default value of list
  final int defaultIndex;

  /// List used for normal text display
  final List<String> children;

  /// Specify if you want to use your own widget for the item.
  /// This is an optional field, so specify it if you want to use your own widget.
  /// Use `CustomBottomPickerSection.builder` to specify it.
  final Widget Function(BuildContext context, int index)? itemBuilder;

  /// Callbacks when changes are made in the data in the section
  final void Function(int index)? onChange;

  CustomBottomPickerSection({
    this.id,
    this.title,
    this.children = const [],
    this.flex = 1,
    this.itemCount = 0,
    this.defaultIndex = 0,
    this.itemBuilder,
    this.onChange,
  });

  factory CustomBottomPickerSection.builder({
    String? id,
    String? title,
    int flex = 1,
    int defaultIndex = 0,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    void Function(int index)? onChange,
  }) {
    return CustomBottomPickerSection(
      id: id,
      title: title,
      flex: flex,
      defaultIndex: defaultIndex,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onChange: onChange,
    );
  }

  factory CustomBottomPickerSection.list({
    String? id,
    String? title,
    int flex = 1,
    int defaultIndex = 0,
    required List<String> children,
    void Function(int index)? onChange,
  }) {
    return CustomBottomPickerSection(
      id: id,
      title: title,
      flex: flex,
      defaultIndex: defaultIndex,
      itemCount: children.length,
      children: children,
      onChange: onChange,
    );
  }
}

/// [CustomBottomPickerResult] is a class that extends List
///
/// It is possible to retrieve in the same format as a normal List
/// and to retrieve results by a specified ID.
///
/// Example:
///
/// ```dart
/// final result = await showCustomBottomPicker(
///   context: context,
///   sections: [
///     CustomBottomPickerSection.list(
///       id: 'section-1',
///       ...
///     ),
///     CustomBottomPickerSection.list(
///       id: 'section-2',
///       ...
///     ),
///   ],
/// );
/// ```
///
/// - If you want to get the results of the first section
///   ```dart
///   print(result?[0]);
///   ```
///
/// - To obtain results by specifying an ID
///   ```dart
///   print(result?.getById('section-2'));
///   ```
///
class CustomBottomPickerResult extends ListBase<int> {
  final List<int> _list = [];
  final List<String?> _ids = [];

  @override
  int get length => _list.length;

  @override
  set length(int newLength) {
    _list.length = newLength;
  }

  @override
  int operator [](int index) {
    if (_list.length <= index) {
      return -1;
    }
    return _list[index];
  }

  @override
  void operator []=(int index, int? value) {
    if (value == null) return;

    if (_list.length <= index) {
      _list.add(value);
    } else {
      _list[index] = value;
    }
  }

  void addValue(int value, String? id) {
    _list.add(value);
    _ids.add(id);
  }

  int? get(int index) {
    return this[index];
  }

  int? getById(String? id) {
    if (id == null) return null;
    final index = _ids.indexOf(id);
    return index >= 0 ? _list[index] : null;
  }

  @override
  void add(int? element) {
    throw UnsupportedError('Unsupported add method');
  }
}
