import 'package:flutter/material.dart';

class Period extends Widget {
  final Function onChange;
  final String initialRRule;
  DateTime startDate;

  Period(this.onChange, this.initialRRule,this.startDate, {Key? key})
      : super(key: key);

  String getRRule() => throw UnimplementedError();
  void refresh(DateTime date) => throw UnimplementedError();

  void handleInitialRRule() => throw UnimplementedError();

  @override
  Element createElement() => throw UnimplementedError();
}
