import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/text_utils.dart';
import 'package:rrule_generator/src/periods/constants.dart';
import 'package:rrule_generator/src/periods/period.dart';
import '../../localizations/localized_text.dart';

class Monthly extends StatelessWidget implements Period {
  @override
  final Function onChange;
  @override
  final String initialRRule;
  @override
  DateTime startDate;

  final monthTypeNotifier = ValueNotifier(0);
  final monthDayNotifier = ValueNotifier(1);
  final weekdayNotifier = ValueNotifier<WeekModel>(TextUtils.getWeekDays().first);
  final dayNotifier = ValueNotifier(1);

  Monthly(this.onChange, this.initialRRule,this.startDate,{Key? key})
      : super(key: key) {
    
    monthDayNotifier.value = startDate.weekOfMonth-1;
    weekdayNotifier.value = TextUtils.getWeekDays().firstWhere((element) => element.weekDay == startDate.weekday);
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
    } 
    else {
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
      weekdayNotifier.value = TextUtils.getWeekDays().firstWhere((element) => element.shortName == weekday);
      
    }
  }

  @override
  String getRRule() {
    if (monthTypeNotifier.value == 0) {
      int byMonthDay = dayNotifier.value;
      return 'FREQ=MONTHLY;BYMONTHDAY=$byMonthDay';//;INTERVAL=$interval';
    } 
    else {
      String byDay = weekdayNotifier.value.shortName;
      int bySetPos =
          (monthDayNotifier.value < 4) ? monthDayNotifier.value + 1 : -1;
      return 'FREQ=MONTHLY;BYDAY=$byDay;BYSETPOS=$bySetPos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: monthTypeNotifier,
      builder: (BuildContext context, int monthType, _) => Column(
        children: [ 
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
                    dropdownColor: (uiUtils.isDarkTheme ?? false) ? Colors.black : null,
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
                        weekdayNotifier.value = TextUtils.getWeekDays().firstWhere((element) => element.weekDay == startDate.weekday);
                        monthDayNotifier.value = startDate.weekOfMonth - 1;
                      }
                      onChange();
                    },
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        child: Text(localizedText.monthlyOnDay + ' ${dayNotifier.value}', style: monthType == 0 ? uiUtils.textFieldStyle : null,),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text(localizedText.monthlyOnThe + ' ${mapWomToWords(monthDayNotifier.value)} ${weekdayNotifier.value.localizedName}', style: monthType == 1 ? uiUtils.textFieldStyle : null,),
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
      case 0: return localizedText.first;
      case 1: return localizedText.second;
      case 2: return localizedText.third;
      case 3: return localizedText.fourth;
      default: return localizedText.last;
    }
  }

  @override
  void refresh(DateTime date) {
    startDate = date;
    monthDayNotifier.value = date.weekOfMonth-1;
    weekdayNotifier.value = TextUtils.getWeekDays().firstWhere((element) => element.weekDay == date.weekday);
    dayNotifier.value = date.day;
    monthTypeNotifier.notifyListeners();
  }
  @override
  void reset() {
    monthTypeNotifier.value = 0;
  }
}
