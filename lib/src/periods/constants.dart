import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/text_utils.dart';

class UIUtils{
  BoxDecoration selectedBoxDecoration;
  BoxDecoration unSelectedBoxDecoration;
  TextStyle selectedTextStyle;
  TextStyle unSelectedTextStyle;
  TextStyle textFieldStyle;
  TextStyle captionTextStyle;
  bool? isDarkTheme;

  UIUtils({
    this.captionTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
    this.textFieldStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(73, 80, 99, 1.0)),
    this.unSelectedTextStyle = const TextStyle(fontSize: 18),
    this.unSelectedBoxDecoration = const BoxDecoration(color: Color.fromRGBO(242, 242, 244, 1.0),borderRadius: BorderRadius.all(Radius.circular(5.0)),),
    this.selectedBoxDecoration = const BoxDecoration(color: Color.fromRGBO(235, 242, 250, 1.0),borderRadius: BorderRadius.all(Radius.circular(5.0)), boxShadow: [BoxShadow(color: Color.fromRGBO(219, 233, 253, 1.0), spreadRadius: 1.5, blurRadius: 1.0)]),
    this.selectedTextStyle = const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color.fromRGBO(25, 61, 122, 1.0)),
    this.isDarkTheme = false
  });

}

UIUtils uiUtils = UIUtils();

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