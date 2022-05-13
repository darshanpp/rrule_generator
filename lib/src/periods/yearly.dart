import 'package:flutter/material.dart';
import 'package:rrule_generator/src/periods/period.dart';

class Yearly extends StatelessWidget implements Period {
  @override
  final Function onChange;
  @override
  final String initialRRule;
  @override
  DateTime startDate;

  // final monthTypeNotifier = ValueNotifier(0);
  // final monthDayNotifier = ValueNotifier(1);
  // final weekdayNotifier = ValueNotifier(0);
  // final monthNotifier = ValueNotifier(DateTime.now().month);
  // final dayNotifier = ValueNotifier(DateTime.now().day);

  Yearly(this.onChange, this.initialRRule,this.startDate, {Key? key})
      : super(key: key) {
    if (initialRRule.contains('YEARLY')) handleInitialRRule();
  }

  @override
  void handleInitialRRule() {
    // if (initialRRule.contains('BYMONTHDAY')) {
    //   monthTypeNotifier.value = 0;
    //   int dayIndex = initialRRule.indexOf('BYMONTHDAY=') + 11;
    //   String day = initialRRule.substring(
    //       dayIndex, dayIndex + (initialRRule.length > dayIndex + 1 ? 2 : 1));
    //   if (day.length == 1 || day[1] != ';') {
    //     dayNotifier.value = int.parse(day);
    //   } else {
    //     dayNotifier.value = int.parse(day[0]);
    //   }
    // } else {
    //   monthTypeNotifier.value = 1;

    //   int monthDayIndex = initialRRule.indexOf('BYSETPOS=') + 9;
    //   String monthDay =
    //       initialRRule.substring(monthDayIndex, monthDayIndex + 1);

    //   if (monthDay == '-') {
    //     monthDayNotifier.value = 4;
    //   } else {
    //     monthDayNotifier.value = int.parse(monthDay) - 1;
    //   }

    //   int weekdayIndex = initialRRule.indexOf('BYDAY=') + 6;
    //   String weekday = initialRRule.substring(weekdayIndex, weekdayIndex + 2);

    //   weekdayNotifier.value = weekdaysShort.indexOf(weekday);
    // }

    // int monthIndex = initialRRule.indexOf('BYMONTH=') + 8;
    // String month = initialRRule.substring(monthIndex,
    //     monthIndex + (initialRRule.length > monthIndex + 1 ? 2 : 1));
    // if (month.length == 1 || month[1] != ';') {
    //   monthNotifier.value = int.parse(month);
    // } else {
    //   monthNotifier.value = int.parse(month[0]);
    // }
  }

  @override
  String getRRule() {
    return 'FREQ=YEARLY';
    
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void refresh(DateTime date) {

  }
}
