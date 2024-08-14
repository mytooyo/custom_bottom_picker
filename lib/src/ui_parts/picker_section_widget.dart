import 'package:custom_bottom_picker/custom_bottom_picker.dart';
import 'package:custom_bottom_picker/src/custom_bottom_picker_options.dart';
import 'package:flutter/material.dart';

class PickerSectionWidget extends StatefulWidget {
  const PickerSectionWidget({
    super.key,
    required this.options,
    required this.section,
    required this.wide,
    required this.onChange,
    required this.defaultIndex,
  });

  final CustomBottomPickerOptions options;
  final CustomBottomPickerSection section;
  final bool wide;
  final void Function(int index) onChange;
  final int defaultIndex;

  @override
  State<PickerSectionWidget> createState() => _PickerSectionWidgetState();
}

class _PickerSectionWidgetState extends State<PickerSectionWidget> {
  final double itemSize = 44;
  final borderRadius = BorderRadius.circular(12);

  /// Number of items to display in the list
  int get wheelCount => widget.wide ? 7 : 5;

  /// ScrollController
  late FixedExtentScrollController scrollController;
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.defaultIndex;
    scrollController = FixedExtentScrollController(
      initialItem: selectedIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? subTitle;
    if (widget.section.title != null) {
      subTitle = Container(
        height: widget.wide ? 40 : 32,
        width: double.infinity,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          widget.section.title!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: widget.options.getTextColor(context)?.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }

    Widget bgChild = Align(
      alignment: Alignment.center,
      child: Material(
        color: widget.options.getForegroundColor(context),
        borderRadius: borderRadius,
        child: SizedBox(
          height: itemSize,
          width: double.infinity,
        ),
      ),
    );

    Widget wheelChild = Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: NotificationListener(
          child: SizedBox(
            height: itemSize * wheelCount,
            child: GestureDetector(
              child: ListWheelScrollView.useDelegate(
                controller: scrollController,
                physics: const FixedExtentScrollPhysics(),
                itemExtent: itemSize,
                diameterRatio: 8,
                perspective: 0.01,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                childDelegate: ListWheelChildListDelegate(
                  children: [
                    if (widget.section.itemBuilder != null)
                      for (var i = 0; i < widget.section.itemCount; i++)
                        _item(
                          i,
                          widget.section.itemBuilder!.call(context, i),
                        )
                    else
                      for (var i = 0; i < widget.section.itemCount; i++)
                        _textItem(i),
                  ],
                ),
              ),
              // onTapUp: (details) {
              //   double clickOffset =
              //       details.localPosition.dy - (itemSize * wheelCount / 2);
              //   final currentIndex = scrollController.selectedItem;
              //   final indexOffset = (clickOffset / itemSize).round();
              //   final newIndex = currentIndex + indexOffset;
              //   if (selectedIndex == newIndex) return;
              //   selectedIndex = newIndex;
              //   scrollController.animateToItem(
              //     newIndex,
              //     duration: const Duration(milliseconds: 200),
              //     curve: Curves.easeIn,
              //   );
              // },
            ),
          ),
          onNotification: (info) {
            if (info is ScrollEndNotification) {
              // Change callback
              widget.onChange(selectedIndex);
            }
            return true;
          },
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          if (subTitle != null) subTitle,
          Expanded(
            child: Stack(
              children: [
                bgChild,
                wheelChild,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int i, Widget child) {
    double scale = 1.0;
    if (selectedIndex != i) {
      scale = 0.84;
    }

    return Center(
      child: Transform.scale(
        scale: scale,
        child: child,
      ),
    );
  }

  Widget _textItem(int i) {
    final textColor = widget.options.textColor ??
        Theme.of(context).textTheme.bodyLarge?.color;

    TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: textColor?.withOpacity(selectedIndex == i ? 1.0 : 0.4),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        );
    if (selectedIndex == i) {
      textStyle = textStyle?.apply(color: widget.options.activeTextColor);
    }

    return _item(
      i,
      Text(
        widget.section.children[i],
        style: textStyle,
      ),
    );
  }
}
