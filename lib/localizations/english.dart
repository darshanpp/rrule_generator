import 'package:rrule_generator/localizations/text_delegate.dart';

class EnglishRRuleTextDelegate implements RRuleTextDelegate {
  const EnglishRRuleTextDelegate();

  @override
  String get byDayInMonth => 'By day in Month';

  @override
  String get byNthDayInMonth => 'By nth day in Month';

  @override
  String get every => 'Every';

  @override
  String get of => 'of';

  @override
  String get months => 'Month(s)';

  @override
  String get weeks => 'Week(s)';

  @override
  String get days => 'Day(s)';

  @override
  String get instances => 'occurrence';

  @override
  String get neverEnds => 'Never';

  @override
  String get endsAfter => 'After';

  @override
  String get endsOnDate => 'On';

  @override
  List<String> get daysInMonth => [
        '1st',
        '2nd',
        '3rd',
        '4rd',
        'Last',
      ];

  @override
  List<String> get allMonths => [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

  @override
  List<String> get weekdays => [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

  @override
  List<String> get periods => [
        'Yearly',
        'Monthly',
        'Weekly',
        'Daily',
        'Never',
      ];

  @override
  String get repeatsOn => 'Repeat On';

  @override
  List<String> get repeatsEveryList => [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  String get repeatsEvery => 'Repeats every';

  @override
  String get ends => 'Ends';

  @override
  List<String> get endsOptionList => [
    'Never',
    'On',
    'After',
  ];

  @override
  List<String> get recurringList => [
    'Does not repeat',
    'Custom'
  ];
  @override
  String get first => 'first';
  @override
  String get second => 'second';
  @override
  String get third => 'third';
  @override
  String get fourth => 'fourth';
  @override
  String get last => 'last';
  @override
  String get monthlyOn => 'Monthly on';
  @override
  String get monthlyOnThe => 'Monthly on the';
  @override
  String get start => 'Start';
}
