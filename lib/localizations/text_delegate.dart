class RRuleTextDelegate {
  String get byDayInMonth => 'By day in Month';

  String get byNthDayInMonth => 'By nth day in Month';

  String get every => 'Every';

  String get of => 'of';

  String get months => 'Month(s)';

  String get weeks => 'Week(s)';
  String get repeatsOn => 'Repeats on';
  String get repeatsEvery => 'Repeats every';
  String get ends => 'Ends';
  String get first => 'first';
  String get second => 'second';
  String get third => 'third';
  String get fourth => 'fourth';
  String get last => 'last';
  String get monthlyOn => 'Monthly on';
  String get monthlyOnThe => 'Monthly on the';
  String get start => 'Start';

  String get days => 'Day(s)';

  String get instances => 'occurrence';

  String get neverEnds => 'Never';

  String get endsAfter => 'After';

  String get endsOnDate => 'On';

  List<String> get daysInMonth => [
        '1st',
        '2nd',
        '3rd',
        '4rd',
        'Last',
      ];

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

  List<String> get weekdays => [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

  List<String> get periods => [
        'Yearly',
        'Monthly',
        'Weekly',
        'Daily',
        'Never',
      ];
  List<String> get repeatsEveryList => [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  List<String> get endsOptionList => [
    'Never',
    'On',
    'After',
  ];

  List<String> get recurringList => [
    'Does not repeat',
    'Custom'
  ];
}
