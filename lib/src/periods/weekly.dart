import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/localized_text.dart';
import 'package:rrule_generator/src/periods/constants.dart';
import 'package:rrule_generator/src/periods/period.dart';
import 'package:rrule_generator/src/periods/pickers/weekday.dart';

import '../../localizations/text_utils.dart';

class Weekly extends StatelessWidget implements Period {
  @override
  final Function onChange;
  @override
  final String initialRRule;
  @override
  DateTime startDate;

  int startWeekWith;

  List<WeekModel> weekDays = [];

  Weekly(this.onChange, this.initialRRule,this.startDate, this.startWeekWith,  {Key? key})
      : super(key: key) {
    _initializeWeekDaysInDigits(startWeekWith);
    if (initialRRule.contains('WEEKLY')) handleInitialRRule();
  }

  void _initializeWeekDaysInDigits(int startDay){
    weekDays = rotate(TextUtils.getWeekDays(), startWeekWith%7);
  }
  
  List<WeekModel> rotate(List<WeekModel> list, int v) {
    if(list.isEmpty) return list;
    var i = v % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }

  @override
  void handleInitialRRule() {
    if (initialRRule.contains('BYDAY=')) {
      int weekdayIndex = initialRRule.indexOf('BYDAY=') + 6;
      int weekdayEnd = initialRRule.indexOf(';', weekdayIndex);
      String initialWeekdays = initialRRule.substring(
          weekdayIndex, weekdayEnd == -1 ? initialRRule.length : weekdayEnd);
      weekDays.forEach((element) { 
        element.isSelected.value = initialWeekdays.contains(element.shortName);
      });
    }
  }

  @override
  String getRRule() {
    // int interval = int.tryParse(intervalController.text) ?? 0;
    List<String> weekdayList = [];
    
    weekDays.forEach((element) { 
      if(element.isSelected.value){
        weekdayList.add(element.shortName);
      }
    });

    return weekdayList.isEmpty
        ? 'FREQ=WEEKLY'
        : 'FREQ=WEEKLY;BYDAY=${weekdayList.join(",")}';
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0,),
              Text(localizedText.repeatsOn, style: uiUtils.captionTextStyle,),
              WeekdayPicker(onChange, weekDays),
            ],
          )
        ],
      );

  @override
  void refresh(DateTime date) {
    startDate = date;

  }
  @override
  void reset() {
    weekDays.forEach((element) { element.isSelected.value = element.weekDay == startDate.weekday;});
  }
}
