import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/text_delegate.dart';
import 'package:rrule_generator/src/periods/constants.dart';
import 'package:rrule_generator/src/periods/pickers/interval.dart';
import 'package:rrule_generator/src/periods/period.dart';
import 'package:rrule_generator/src/periods/pickers/weekday.dart';

class Weekly extends StatelessWidget implements Period {
  @override
  final RRuleTextDelegate textDelegate;
  @override
  final Function onChange;
  @override
  final String initialRRule;
  @override
  DateTime startDate;

  bool isSundaySow;

  // final intervalController = TextEditingController(text: '1');
  final weekdayNotifiers = List.generate(
    7,
    (index) => ValueNotifier(false),
  );

  Weekly(this.textDelegate, this.onChange, this.initialRRule,this.startDate, this.isSundaySow, {Key? key})
      : super(key: key) {
    if (initialRRule.contains('WEEKLY')) handleInitialRRule();
  }

  @override
  void handleInitialRRule() {
    // int intervalIndex = initialRRule.indexOf('INTERVAL=') + 9;
    // int intervalEnd = initialRRule.indexOf(';', intervalIndex);
    // String interval = initialRRule.substring(
    //     intervalIndex, intervalEnd == -1 ? initialRRule.length : intervalEnd);
    // intervalController.text = interval;

    if (initialRRule.contains('BYDAY=')) {
      int weekdayIndex = initialRRule.indexOf('BYDAY=') + 6;
      int weekdayEnd = initialRRule.indexOf(';', weekdayIndex);
      String weekdays = initialRRule.substring(
          weekdayIndex, weekdayEnd == -1 ? initialRRule.length : weekdayEnd);
      for (int i = 0; i < 7; i++) {
        if (weekdays.contains(weekdaysShortM[i])) {
          weekdayNotifiers[i].value = true;
        }
      }
    }
  }

  @override
  String getRRule() {
    // int interval = int.tryParse(intervalController.text) ?? 0;
    List<String> weekdayList = [];
    for (int i = 0; i < 7; i++) {
      if (weekdayNotifiers[i].value) weekdayList.add(isSundaySow ? weekdaysShortS[i] : weekdaysShortM[i]);
    }

    return weekdayList.isEmpty
        ? 'FREQ=WEEKLY'//INTERVAL=${interval > 0 ? interval : 1}'
        : 'FREQ=WEEKLY;'//INTERVAL=${interval > 0 ? interval : 1};'
            'BYDAY=${weekdayList.join(",")}';
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Text(textDelegate.every),
          // IntervalPicker(intervalController, onChange),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0,),
              Text(textDelegate.repeatsOn, style: Constants.captionTextStyle,),
              WeekdayPicker(weekdayNotifiers, textDelegate, onChange, isSundaySow),
            ],
          )
        ],
      );

  @override
  void refresh(DateTime date) {
    
  }
}
