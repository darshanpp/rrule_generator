class RRuleTextDelegate {

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
  String get instances => 'occurrence';
  String get endsOnDate => 'On';

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
  List<String> weekdays(bool isSundaySow){
    if(isSundaySow){
      return [        
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday'
      ];
    }
    return [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  } 
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
}
