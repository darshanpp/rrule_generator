import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/text_delegate.dart';
import 'package:rrule_generator/src/periods/constants.dart';
import 'package:rrule_generator/src/periods/period.dart';

class Monthly extends StatelessWidget implements Period {
  @override
  final RRuleTextDelegate textDelegate;
  @override
  final Function onChange;
  @override
  final String initialRRule;
  @override
  DateTime startDate;

  final monthTypeNotifier = ValueNotifier(0);
  final monthDayNotifier = ValueNotifier(1);
  final weekdayNotifier = ValueNotifier(0);
  final dayNotifier = ValueNotifier(1);
  // final intervalController = TextEditingController(text: '1');

  Monthly(this.textDelegate, this.onChange, this.initialRRule,this.startDate, {Key? key})
      : super(key: key) {
    
    monthDayNotifier.value = startDate.weekOfMonth-1;
    weekdayNotifier.value = startDate.weekday-1;
    dayNotifier.value = startDate.day;

    if (initialRRule.contains('MONTHLY')){
      handleInitialRRule();
    }
  }

  @override
  void handleInitialRRule() {
    if (initialRRule.contains('BYMONTHDAY')) {
      monthTypeNotifier.value = 0;
      int dayIndex = initialRRule.indexOf('BYMONTHDAY=') + 11;
      String day = initialRRule.substring(
          dayIndex, dayIndex + (initialRRule.length > dayIndex + 1 ? 2 : 1));
      if (day.length == 1 || day[1] != ';') {
        dayNotifier.value = int.parse(day);
      } else {
        dayNotifier.value = int.parse(day[0]);
      }

      // int intervalIndex = initialRRule.indexOf('INTERVAL=') + 9;
      // int intervalEnd = initialRRule.indexOf(';', intervalIndex);
      // String interval = initialRRule.substring(
      //     intervalIndex, intervalEnd == -1 ? initialRRule.length : intervalEnd);
      // intervalController.text = interval;
    } else {
      monthTypeNotifier.value = 1;

      int monthDayIndex = initialRRule.indexOf('BYSETPOS=') + 9;
      String monthDay =
          initialRRule.substring(monthDayIndex, monthDayIndex + 1);

      if (monthDay == '-') {
        monthDayNotifier.value = 4;
      } else {
        monthDayNotifier.value = int.parse(monthDay) - 1;
      }

      int weekdayIndex = initialRRule.indexOf('BYDAY=') + 6;
      String weekday = initialRRule.substring(weekdayIndex, weekdayIndex + 2);

      weekdayNotifier.value = weekdaysShort.indexOf(weekday);
    }
  }

  @override
  String getRRule() {
    if (monthTypeNotifier.value == 0) {
      int byMonthDay = dayNotifier.value;
      // String interval = intervalController.text;
      return 'FREQ=MONTHLY;BYMONTHDAY=$byMonthDay';//;INTERVAL=$interval';
    } else {
      String byDay = weekdaysShort[weekdayNotifier.value];
      int bySetPos =
          (monthDayNotifier.value < 4) ? monthDayNotifier.value + 1 : -1;
      // int interval = int.tryParse(intervalController.text) ?? 0;
      return 'FREQ=MONTHLY;'//;INTERVAL=${interval > 0 ? interval : 1};'
          'BYDAY=$byDay;BYSETPOS=$bySetPos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: monthTypeNotifier,
      builder: (BuildContext context, int monthType, _) => Column(
        children: [ 
          // Text(textDelegate.every),
          // IntervalPicker(intervalController, onChange),
          // Text(textDelegate.months),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color.fromRGBO(220, 221, 224, 1.0)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton(
                    value: monthType,
                    icon: Icon(Icons.keyboard_arrow_down),
                    isDense: false,
                    isExpanded: true,
                    underline: SizedBox(height: 0, width:0),
                    onChanged: (int? newMonthType) {
                      monthTypeNotifier.value = newMonthType!;
                      if(newMonthType == 0){
                        dayNotifier.value = startDate.day;
                      }
                      else if(newMonthType == 1){
                        weekdayNotifier.value = startDate.weekday - 1;
                        monthDayNotifier.value = startDate.weekOfMonth - 1;
                      }
                      onChange();
                    },
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        // child: Text(textDelegate.monthlyOn + ' day ${DateTime.now().day}'),
                        child: Text(textDelegate.monthlyOn + ' day ${dayNotifier.value}', style: monthType == 0 ? Constants.textFieldStyle : null,),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        // child: Text(textDelegate.monthlyOn + ' the ${mapWomToWords(DateTime.now().weekOfMonth)} ${textDelegate.weekdays[DateTime.now().weekday-1]}'),
                        child: Text(textDelegate.monthlyOn + ' the ${mapWomToWords(monthDayNotifier.value)} ${textDelegate.weekdays[weekdayNotifier.value]}', style: monthType == 1 ? Constants.textFieldStyle : null,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String mapWomToWords(int wom){
    switch(wom){
      case 0: return textDelegate.first;
      case 1: return textDelegate.second;
      case 2: return textDelegate.third;
      case 3: return textDelegate.fourth;
      default: return textDelegate.last;
    }
  }

  @override
  void refresh(DateTime date) {
    startDate = date;
    monthDayNotifier.value = date.weekOfMonth-1;
    weekdayNotifier.value = date.weekday-1;
    dayNotifier.value = date.day;
    monthTypeNotifier.notifyListeners();
  }
}
