import 'package:intl/intl.dart';
import 'package:rrule_generator/src/periods/constants.dart';

class TextUtils{
  static String currentLocale = 'en_US';
  static getLocalizedWeekDay(int day){
    DateTime now = DateTime.now();
    DateTime currentWeekMonday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday-1));
    return  DateFormat(DateFormat.WEEKDAY, currentLocale).format(currentWeekMonday.add(Duration(days: day - 1)));
  }

  static String getRRuleWeekDayInShort(int weekDay){
    switch(weekDay){
      case DateTime.sunday: return 'SU';
      case DateTime.monday: return 'MO';
      case DateTime.tuesday: return 'TU';
      case DateTime.wednesday: return 'WE';
      case DateTime.thursday: return 'TH';
      case DateTime.friday: return 'FR';
      case DateTime.saturday: return 'SA';
      default: return '';
    }
  }

  static List<WeekModel> weekDays = [
    _generateWeekModelFor(DateTime.sunday),
    _generateWeekModelFor(DateTime.monday),
    _generateWeekModelFor(DateTime.tuesday),
    _generateWeekModelFor(DateTime.wednesday),
    _generateWeekModelFor(DateTime.thursday),
    _generateWeekModelFor(DateTime.friday),
    _generateWeekModelFor(DateTime.saturday),    
  ];

  static WeekModel _generateWeekModelFor(int day){
    return WeekModel(weekDay: day, localizedName: getLocalizedWeekDay(day));
  }

}