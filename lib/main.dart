import 'package:flutter/cupertino.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TimePickerFieldController controller =
      TimePickerFieldController(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: ListView(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Поле 1"),
            ),
            TextField(
              decoration: InputDecoration(hintText: "Поле 2"),
            ),
            TimePickedField(
              controller: controller,
            )
          ],
        ));
  }
}

class TimePickerFieldController extends ValueNotifier<DateTime> {
  TimePickerFieldController(super.value);
}

class TimePickedField extends StatefulWidget {
  final TimePickerFieldController controller;
  final String? hint;
  final String? title;

  const TimePickedField({
    super.key,
    this.hint,
    this.title,
    required this.controller,
  });

  @override
  State<TimePickedField> createState() => _TimePickedFieldState();
}

class _TimePickedFieldState extends State<TimePickedField> {
  final TextEditingController fieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onValueChange);
  }

  _onValueChange() {
    fieldController.text = widget.controller.value.toIso8601String();
  }

  _onUserPick(DateTime? dateTime) {
    if (dateTime != null) {
      widget.controller.value = dateTime;
      _onValueChange();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onValueChange);
    super.dispose();
  }

  void showTimePicker() {
    CustomDatePicker.show(
      context,
      initialValue: DateTime.now(),
      onChange: _onUserPick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) => TextField(
        controller: fieldController,
        onTap: () {
          showTimePicker();
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.title,
        ),
      ),
    );
  }
}

class CustomDatePicker extends StatelessWidget {
  final DateTime? initialValue;
  final DateTime? minValue;
  final DateTime? maxValue;
  final Function(DateTime choosedDate)? onChange;
  const CustomDatePicker(
      {super.key,
      this.onChange,
      this.initialValue,
      this.minValue,
      this.maxValue});

  static show(BuildContext context,
      {required DateTime initialValue,
      Function(DateTime choosedDate)? onChange,
      DateTime? minValue,
      DateTime? maxValue}) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return CustomDatePicker(
          minValue: minValue ??
              DateTime.now().subtract(const Duration(days: 365 * 80)),
          maxValue: maxValue ??
              DateTime.now().subtract(const Duration(days: 365 * 16)),
          onChange: onChange,
          initialValue: initialValue,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          height: 306,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9.5)
                        .copyWith(top: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Готово',
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 206,
                child: CupertinoDatePicker(
                  // initialDateTime: initialValue,
                  mode: CupertinoDatePickerMode.time,
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (value) {
                    onChange?.call(value);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
