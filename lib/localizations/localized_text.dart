class LocalizedText {
  String repeatsOn;
  String repeatsEvery;
  String ends;
  String first;
  String second;
  String third;
  String fourth;
  String last;
  String monthlyOnDay;
  String monthlyOnThe;
  String start;
  String occurrence;
  String onDate;
  String endsNever;
  String endsAfter;
  String repeatDaily;
  String repeatWeekly;
  String repeatMonthly;
  String repeatYearly;
  String repeatNever;
  
  LocalizedText({
    this.repeatsOn = 'Repeats on',
    this.repeatsEvery = 'Repeats every',
    this.ends = 'Ends',
    this.first = 'first',
    this.second = 'second',
    this.third = 'third',
    this.fourth = 'fourth',
    this.last = 'last',
    this.monthlyOnDay = 'Monthly on day',
    this.monthlyOnThe = 'Monthly on the',
    this.start = 'Start',
    this.occurrence = 'Occurence',
    this.onDate = 'On',
    this.endsNever = 'Never',
    this.endsAfter = 'After',
    this.repeatDaily = 'Daily',
    this.repeatWeekly = 'Weekly',
    this.repeatMonthly = 'Monthly',
    this.repeatYearly = 'Annually',
    this.repeatNever = 'Does not repeat'
  });
}

LocalizedText localizedText = LocalizedText();
