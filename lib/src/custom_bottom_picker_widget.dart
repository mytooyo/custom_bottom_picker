import 'package:custom_bottom_picker/custom_bottom_picker.dart';
import 'package:custom_bottom_picker/src/ui_parts/picker_section_widget.dart';
import 'package:flutter/material.dart';

import 'custom_bottom_picker_options.dart';

class CustomBottomPickerWidget extends StatefulWidget {
  const CustomBottomPickerWidget({
    super.key,
    this.options = const CustomBottomPickerOptions(),
    required this.sections,
    this.closeButtonBuilder,
  });

  final CustomBottomPickerOptions options;

  final List<CustomBottomPickerSection> sections;

  final CloseButtonBuilder? closeButtonBuilder;

  @override
  State<CustomBottomPickerWidget> createState() =>
      _CustomBottomPickerWidgetState();
}

class _CustomBottomPickerWidgetState extends State<CustomBottomPickerWidget> {
  CustomBottomPickerOptions get options => widget.options;

  /// A list to store the results. With a value for each section.
  final CustomBottomPickerResult results = CustomBottomPickerResult();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.sections.length; i++) {
      final item = widget.sections[i];
      results.addValue(item.defaultIndex, item.id);
    }
  }

  Widget _picker() {
    List<Widget> list = [];
    for (var i = 0; i < widget.sections.length; i++) {
      final x = widget.sections[i];
      list.add(
        Expanded(
          flex: x.flex,
          child: PickerSectionWidget(
            options: options,
            section: x,
            wide: false,
            defaultIndex: x.defaultIndex,
            onChange: (index) {
              x.onChange?.call(index);
              results[i] = index;
            },
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Row(children: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 324,
      decoration: options.backgroundDecoration ??
          BoxDecoration(
            color: options.getBackgroundColor(context),
          ),
      child: SafeArea(
        top: false,
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TopHeader(
                options: options,
                onClose: () {
                  Navigator.of(context).pop(results);
                },
                closeButtonBuilder: widget.closeButtonBuilder,
              ),
              const SizedBox(height: 8),
              Expanded(child: _picker()),
            ],
          ),
        ),
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  final CustomBottomPickerOptions options;
  final void Function() onClose;
  final CloseButtonBuilder? closeButtonBuilder;

  const TopHeader({
    super.key,
    required this.options,
    required this.onClose,
    this.closeButtonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final closeButton = closeButtonBuilder?.call(context, false, onClose) ??
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.check_circle_rounded),
          color: options.getActiveColor(context),
        );

    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                options.pickerTitle ?? '',
                style: options.pickerTitleTextStyle ??
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: closeButton,
            ),
          ),
        ],
      ),
    );
  }
}
