import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/localized_text.dart';
import 'package:rrule_generator/src/periods/constants.dart';
import 'package:rrule_generator/src/periods/period.dart';
import 'package:rrule_generator/src/periods/pickers/date_picker.dart';
import 'package:rrule_generator/src/periods/pickers/interval.dart';
import 'package:rrule_generator/src/periods/yearly.dart';
import 'package:rrule_generator/src/periods/monthly.dart';
import 'package:rrule_generator/src/periods/weekly.dart';
import 'package:rrule_generator/src/periods/daily.dart';

class RRuleGenerator extends StatelessWidget {
  final Function(String newValue, DateTime startDate)? onChange;
  final String initialRRule;
  LocalizedText localizedTextFromApp;

  final frequencyNotifier = ValueNotifier<RepeatsEvery?>(RepeatsEvery.daily);
  final countTypeNotifier = ValueNotifier<EndsType>(EndsType.never);
  final pickedDateNotifier = ValueNotifier(DateTime.now());
  final instancesController = TextEditingController(text: '1');
  final List<Period> periodWidgets = [];
  final intervalController = TextEditingController(text: '1');
  DateTime? startDate;
  List<String> repeatsEveryList = [];
  List<String> endsOptionList = [];
  int startWeekWith;

  RRuleGenerator({Key? key,
    this.onChange,
    this.startDate,
    required this.localizedTextFromApp,
    this.startWeekWith = DateTime.monday,
    this.initialRRule = ''})
      : super(key: key) {
    startDate ??= DateTime.now();
    periodWidgets.addAll([
      Daily(valueChanged, initialRRule, startDate!),
      Weekly(valueChanged, initialRRule, startDate!, startWeekWith),
      Monthly(valueChanged, initialRRule, startDate!),
      Yearly(valueChanged, initialRRule, startDate!),
    ]);
    initializeData();
    handleInitialRRule();
  }

  void initializeData(){
    localizedText = localizedTextFromApp;
    repeatsEveryList = [
      localizedText.repeatDaily,
      localizedText.repeatWeekly,
      localizedText.repeatMonthly,
      localizedText.repeatYearly,
    ];
    endsOptionList = [
      localizedText.endsNever,
      localizedText.onDate,
      localizedText.endsAfter,
    ];
  }

  void handleInitialRRule() {
    if(initialRRule.indexOf('INTERVAL=')>=0){
      int intervalIndex = initialRRule.indexOf('INTERVAL=') + 9;
      int intervalEnd = initialRRule.indexOf(';', intervalIndex);
      String interval = initialRRule.substring(
          intervalIndex, intervalEnd == -1 ? initialRRule.length : intervalEnd);
      intervalController.text = interval;
    }
    
    if (initialRRule.contains('MONTHLY')) {
      frequencyNotifier.value = RepeatsEvery.monthly;
    } 
    else if (initialRRule.contains('WEEKLY')) {
      frequencyNotifier.value = RepeatsEvery.weekly;
    } 
    else if (initialRRule.contains('DAILY')) {
      frequencyNotifier.value = RepeatsEvery.daily;
    } 
    else if (initialRRule.contains('YEARLY')) {
      frequencyNotifier.value = RepeatsEvery.yearly;
    }
    else if (initialRRule == '') {
      frequencyNotifier.value = null;
    }

    if (initialRRule.contains('COUNT')) {
      countTypeNotifier.value = EndsType.after;
      instancesController.text = initialRRule.substring(
          initialRRule.indexOf('COUNT=') + 6, initialRRule.length);
    } else if (initialRRule.contains('UNTIL')) {
      countTypeNotifier.value = EndsType.endOn;
      int dateIndex = initialRRule.indexOf('UNTIL=') + 6;
      int year = int.parse(initialRRule.substring(dateIndex, dateIndex + 4));
      int month =
      int.parse(initialRRule.substring(dateIndex + 4, dateIndex + 6));
      int day =
      int.parse(initialRRule.substring(dateIndex + 6, initialRRule.length));

      pickedDateNotifier.value = DateTime(year, month, day);
    }
  }

  void valueChanged() {
    Function(String newValue, DateTime startDate)? fun = onChange;
    if (fun != null) fun(getRRule(), startDate!);
  }

  String getRRule() {
    int interval = int.tryParse(intervalController.text) ?? 0;

    if (frequencyNotifier.value == null) {
      return '';
    }

    if (countTypeNotifier.value == EndsType.never) {
      return 'RRULE:' + periodWidgets[frequencyNotifier.value!.index].getRRule() + ';INTERVAL=${interval > 0 ? interval : 1}';
    } 
    else if (countTypeNotifier.value == EndsType.after) {
      return 'RRULE:' +
          periodWidgets[frequencyNotifier.value!.index].getRRule() +
          ';COUNT=${instancesController.text}'+ ';INTERVAL=${interval > 0 ? interval : 1}';
    }
    DateTime pickedDate = pickedDateNotifier.value;

    String day =
    pickedDate.day > 9 ? '${pickedDate.day}' : '0${pickedDate.day}';
    String month =
    pickedDate.month > 9 ? '${pickedDate.month}' : '0${pickedDate.month}';

    return 'RRULE:' +
        periodWidgets[frequencyNotifier.value!.index].getRRule() +
        ';UNTIL=${pickedDate.year}$month$day'+ ';INTERVAL=${interval > 0 ? interval : 1}';      
  }

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<RepeatsEvery?>(
          valueListenable: frequencyNotifier,
          builder: (BuildContext context, period, Widget? child) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(localizedText.repeatsEvery, style: Constants.captionTextStyle,),
                  SizedBox(height: 4.0,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntervalPicker(intervalController, valueChanged),
                        )),
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: List.generate(RepeatsEvery.values.length, (index) => Expanded(
                            child: GestureDetector(
                              onTap: (){
                                frequencyNotifier.value = RepeatsEvery.values[index];
                                valueChanged();
                              },
                              child: Container(
                                decoration: period == RepeatsEvery.values[index] ? Constants.selectedBoxDecoration : null,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(repeatsEveryList[index], style: period == RepeatsEvery.values[index] ? Constants.selectedTextStyle : Constants.unSelectedTextStyle,),
                                  )),
                                )
                              ),
                            ),
                          ))
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(height: period == null ? 0 : 16),
                  period == null ? Container() : periodWidgets[period.index],
                  SizedBox(height: period == null ? 0 : 16),
                  Text(localizedText.start, style: Constants.captionTextStyle,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(localizedText.onDate, style: Constants.unSelectedTextStyle),
                      ),
                      RRuleDatePicker(
                        date: startDate!,
                        onChange: (date){
                          startDate = date;
                          periodWidgets.forEach((i){i.refresh(date);});
                          valueChanged();
                        },
                      ),
                    ],
                  ),
                  period == null
                      ? Container()
                      : ValueListenableBuilder<EndsType>(
                    valueListenable: countTypeNotifier,
                    builder:
                        (BuildContext context, countType, Widget? child) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 16),
                            Text(localizedText.ends, style: Constants.captionTextStyle,),
                          ]+ List.generate(EndsType.values.length, (index){
                            return GestureDetector(
                              onTap: (){
                                countTypeNotifier.value = EndsType.values[index];
                                valueChanged();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: EndsType.values[index] == countTypeNotifier.value ? Constants.selectedBoxDecoration : null,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            endsOptionList[index],
                                            style: EndsType.values[index] == countTypeNotifier.value ? Constants.selectedTextStyle : Constants.unSelectedTextStyle,
                                          ),
                                        ),
                                      ),
                                      index == EndsType.endOn.index ? Expanded(
                                        flex: 3,
                                        child: ValueListenableBuilder(
                                          valueListenable: pickedDateNotifier,
                                          builder: (context, DateTime pickedDate, _) {
                                            return AbsorbPointer(
                                              absorbing: EndsType.values[index] != countTypeNotifier.value,
                                              child: RRuleDatePicker(
                                                date: pickedDate, 
                                                onChange: (picked){
                                                  if (picked != null && picked != pickedDate) {
                                                    pickedDateNotifier.value = picked;
                                                    valueChanged();
                                                  }
                                                }),
                                            );
                                          }
                                        ),
                                      ):SizedBox(),
                                      index == EndsType.after.index ? Expanded(
                                        flex: 3,
                                        child: AbsorbPointer(
                                          absorbing: EndsType.values[index] != countTypeNotifier.value,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: IntervalPicker(instancesController, valueChanged)),
                                              SizedBox(width: 8.0,),
                                              Expanded(
                                                flex: 3,
                                                child: Text(localizedText.occurrence, style: Constants.unSelectedTextStyle,))
                                            ],
                                          ),
                                        ),
                                      ): SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),  
                        ),
                  ),
                ],
              ),
        ),
      );    
}
