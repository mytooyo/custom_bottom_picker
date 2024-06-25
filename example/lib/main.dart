import 'package:custom_bottom_picker/custom_bottom_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Bottom Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 235, 235, 241),
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Widget button(String text, void Function() onTap) {
      return Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            width: 240,
            alignment: Alignment.center,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 240,
              alignment: Alignment.center,
              child: Text(
                'Custom Bottom Picker',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            button(
              'Country: ${countryData[countryIndex]}',
              showCountry,
            ),
            const SizedBox(height: 24),
            button(
              'LogLevel: ${envs[envIndex]} - ${logLevels[logLevelIndex]}',
              showEnvLog,
            ),
            const SizedBox(height: 24),
            button(
              'Widgets builder',
              showWidgets,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  int countryIndex = 8;
  List<String> countryData = [
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

  int logLevelIndex = 2;
  List<String> logLevels = [
    'Debug',
    'Info',
    'Warning',
    'Error',
    'Fatal',
  ];

  int envIndex = 1;
  List<String> envs = [
    'Test',
    'Develop',
    'Staging',
    'Production',
  ];

  void showEnvLog() async {
    final result = await showCustomBottomPicker(
      context: context,
      options: const CustomBottomPickerOptions(
        pickerTitle: 'Log Level',
      ),
      sections: [
        CustomBottomPickerSection.list(
          id: 'env',
          title: 'Environment',
          flex: 3,
          defaultIndex: envIndex,
          children: envs,
        ),
        CustomBottomPickerSection.list(
          id: 'level',
          title: 'Level',
          flex: 2,
          defaultIndex: logLevelIndex,
          children: logLevels,
        ),
      ],
    );
    if (result != null) {
      setState(() {
        envIndex = result.getById('env')!;
        logLevelIndex = result.getById('level')!;
      });
    }
  }

  static Widget widgetRow(BuildContext context, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.stop_rounded,
          color: color,
          size: 28,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 2,
          width: 64,
          decoration: BoxDecoration(
            color: color,
          ),
        ),
        Icon(Icons.account_circle_rounded, color: color),
      ],
    );
  }

  int widgetIndex = 2;
  late List<Widget> widgets = [
    widgetRow(context, 'Debug', Colors.grey),
    widgetRow(context, 'Info', Colors.blue),
    widgetRow(context, 'Warning', Colors.orange),
    widgetRow(context, 'Error', Colors.red),
    widgetRow(context, 'Critical', Colors.purple),
  ];

  void showWidgets() async {
    final result = await showCustomBottomPicker(
      context: context,
      options: const CustomBottomPickerOptions(
        pickerTitle: 'Log Level',
      ),
      sections: [
        CustomBottomPickerSection.builder(
          id: 'widget',
          flex: 3,
          defaultIndex: envIndex,
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            return widgets[index];
          },
        ),
      ],
    );
    if (result != null) {
      setState(() {
        widgetIndex = result.getById('widget')!;
      });
    }
  }
}
