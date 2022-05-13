import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_generator/localizations/text_utils.dart';

class Constants{
  static BoxDecoration selectedBoxDecoration = BoxDecoration(
    color: Color.fromRGBO(235, 242, 250, 1.0),
    borderRadius: BorderRadius.circular(5.0),
    boxShadow: [BoxShadow(color: Color.fromRGBO(219, 233, 253, 1.0), spreadRadius: 1.5, blurRadius: 1.0)]
  );
  static BoxDecoration unSelectedBoxDecoration = BoxDecoration(
    color: Color.fromRGBO(242, 242, 244, 1.0),
    borderRadius: BorderRadius.circular(5.0),
  );
  static TextStyle selectedTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Color.fromRGBO(25, 61, 122, 1.0)
  );
  static TextStyle unSelectedTextStyle = TextStyle(
    fontSize: 18,
  );
  static TextStyle textFieldStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black);

  static TextStyle captionTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Color.fromRGBO(73, 80, 99, 1.0)
  );

  static String getDateString(DateTime date){
    return DateFormat('dd MMM, yyyy', TextUtils.currentLocale).format(date);
  }
}

enum EndsType{
  never,
  endOn,
  after
}

enum RepeatsEvery{
  never,
  daily,
  weekly,
  monthly,
  yearly
}

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  }
}

class WeekModel{
  late int weekDay;
  late String localizedName;
  late String shortName;
  late ValueNotifier<bool> isSelected;

  WeekModel({required this.weekDay, required this.localizedName}){
    this.isSelected = ValueNotifier(false);
    this.shortName = TextUtils.getRRuleWeekDayInShort(this.weekDay);
  }
}