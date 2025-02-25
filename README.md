# Custom Bottom Picker

You can easily implement a Picker for any item you like.  
Not only lists of text, but also lists of widgets can be made into a picker,
so you can create a picker with a design that suits your application.

Multiple items can be displayed on the picker at once.  

## Features

|Phone|Tablet|
|---|---|
|<img src="https://raw.githubusercontent.com/mytooyo/custom_bottom_picker/main/example/screenshots/phone.gif" width="300" />|<img src="https://raw.githubusercontent.com/mytooyo/custom_bottom_picker/main/example/screenshots/tablet_landscape.gif" width="440" />|

- Text Picker
- Widget Picker
- Multiple Text and Widget Picker
- Customize Color

## Getting Started

In order to add custom_bottom_picker package to your project add this line to your pubspec.yaml file

```yaml
dependencies:
    custom_bottom_picker: 1.0.2
```

## Usage

```dart
import 'package:custom_bottom_picker/custom_bottom_picker.dart';

int countryIndex = 8;
final List<String> countryData = [
  'America',
  'Austria',
  'Canada',
  'Egypt',
  'France',
  'Greece',
  'India',
  'Indonesia',
  'Japan',
  'Malaysia',
  'South Africa',
  'Spain',
  'Viet Nam',
];

void showCountry() async {
  final result = await showCustomBottomPicker(
    context: context,
    options: const CustomBottomPickerOptions(
      pickerTitle: 'Country',
    ),
    sections: [
      CustomBottomPickerSection.list(
        id: 'country',
        defaultIndex: countryIndex,
        children: countryData,
      ),
    ],
  );
  if (result != null) {
    setState(() => countryIndex = result.getById('country')!);
  }
}
```

### Parameters

The parameters of `showCustomBottomPicker` are introduced below.  
In addition to the items listed below, you can also specify the background color and other parameters used for the regular `showModalBottomSheet`.

```dart
/// The `sections` is a list specifying per-column information to be displayed in the picker.
/// A column is added to the Picker and displayed for the specified amount.
required List<CustomBottomPickerSection> sections,

/// The `options` is an option to customize the picker display.
/// You can specify the background color, text color, and button color.
/// Specify `pickerTitle` to display the title at the top of the picker
CustomBottomPickerOptions? options,

/// The `radius` is a rounded corner on both sides of the top in modal display.
double radius = 24,
```

### CustomBottomPickerSection

Introduces section items for specifying the listings to be displayed in the picker.  
Only one of `children` and `itemBuilder` should be specified. If both are specified, `itemBuilder` takes precedence.

```dart
/// identify the section
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
```

#### Text List

```dart
CustomBottomPickerSection.list(
  children: [...],
)
```

#### Widget List

```dart
CustomBottomPickerSection.builder(
  itemCount: 10,
  itemBuilder: (context, index) => list[index],
)
```

### CustomBottomPickerOptions

Options are also available to change the picker design. Specify if you want to specify a title or color.

```dart
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
```

### CustomBottomPickerResult

The return value of the picker is of type `CustomBottomPickerResult`. It inherits from List, so it is also possible to retrieve values as if it were a normal list.  

If you give `id` to the parameter `section`, you can also get the result with the string of that `id`.

```dart
CustomBottomPickerResult? result = await showCustomBottomPicker(
  ...
);

// To get the result for the first item
result![0];

// To get the result with a specified ID
result!.getById('country');
```

## LICENSE

```
BSD 3-Clause License

Copyright (c) 2024, mytooyo

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
