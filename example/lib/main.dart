import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/localized_text.dart';
import 'package:rrule_generator/rrule_generator.dart';
// import 'package:rrule/rrule.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: RRuleGenerator(
            startDate: DateTime.now(),
            startWeekWith: DateTime.monday,
            initialRRule:'',
            localizedTextFromApp: LocalizedText(),
            uiOptions: UIUtils(),
            onChange: (String newValue, startDate){
              print('RRule: $newValue');
              // final rrule = RecurrenceRule.fromString(newValue);

              // final Iterable<DateTime> instances = rrule.getInstances(
              //   start: DateTime.now().toUtc(),
              // );
              // print(instances.toList().last.toString());
            },
          ),
        ),
      ),
    );
  }
}
