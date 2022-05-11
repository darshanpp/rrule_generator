import 'package:rrule_generator/localizations/text_delegate.dart';

class EnglishRRuleTextDelegate implements RRuleTextDelegate {
  const EnglishRRuleTextDelegate();

  @override
  String get instances => 'occurrence';

  @override
  String get endsOnDate => 'On';

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
