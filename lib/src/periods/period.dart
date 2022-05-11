import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/text_delegate.dart';

final weekdaysShortM = [
  'MO',
  'TU',
  'WE',
  'TH',
  'FR',
  'SA',
  'SU',
];
final weekdaysShortS = [
  'SU',
  'MO',
  'TU',
  'WE',
  'TH',
  'FR',
  'SA'
];

class Period extends Widget {
  final RRuleTextDelegate textDelegate;
  final Function onChange;
  final String initialRRule;
  DateTime startDate;

  Period(this.textDelegate, this.onChange, this.initialRRule,this.startDate, {Key? key})
      : super(key: key);

  String getRRule() => throw UnimplementedError();
  void refresh(DateTime date) => throw UnimplementedError();

  void handleInitialRRule() => throw UnimplementedError();

  @override
  Element createElement() => throw UnimplementedError();
}
