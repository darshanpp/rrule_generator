import 'package:flutter/material.dart';
import 'package:rrule_generator/src/periods/period.dart';

class Daily extends StatelessWidget implements Period {

  @override
  final Function onChange;
  @override
  final String initialRRule;
  @override
  DateTime startDate;

  // final intervalController = TextEditingController(text: '1');

  Daily(this.onChange,  this.initialRRule, this.startDate,{Key? key})
      : super(key: key) {
    if (initialRRule.contains('DAILY')) handleInitialRRule();
  }

  @override
  void handleInitialRRule() {
    // int intervalIndex = initialRRule.indexOf('INTERVAL=') + 9;
    // int intervalEnd = initialRRule.indexOf(';', intervalIndex);
    // String interval = initialRRule.substring(
    //     intervalIndex, intervalEnd == -1 ? initialRRule.length : intervalEnd);
    // intervalController.text = interval;
  }

  @override
  String getRRule() {
    // int interval = int.tryParse(intervalController.text) ?? 0;
    return 'FREQ=DAILY';//;INTERVAL=${interval > 0 ? interval : 1}';
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Text(textDelegate.every),
          // IntervalPicker(intervalController, onChange),
          // Text(textDelegate.days),
        ],
      );

  @override
  void refresh(DateTime date) {
  }
  @override
  void reset() {
  }

 
}
