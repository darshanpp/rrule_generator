import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/english.dart';
import 'package:rrule_generator/localizations/text_delegate.dart';
import 'package:rrule_generator/src/periods/constants.dart';
import 'package:rrule_generator/src/periods/period.dart';
import 'package:rrule_generator/src/periods/pickers/date_picker.dart';
import 'package:rrule_generator/src/periods/pickers/interval.dart';
import 'package:rrule_generator/src/periods/yearly.dart';
import 'package:rrule_generator/src/periods/monthly.dart';
import 'package:rrule_generator/src/periods/weekly.dart';
import 'package:rrule_generator/src/periods/daily.dart';
import 'package:intl/intl.dart';

class RRuleGenerator extends StatelessWidget {
  final RRuleTextDelegate textDelegate;
  final Function(String newValue, DateTime startDate)? onChange;
  final String initialRRule;

  final frequencyNotifier = ValueNotifier(0);
  final countTypeNotifier = ValueNotifier(0);
  final pickedDateNotifier = ValueNotifier(DateTime.now());
  final instancesController = TextEditingController(text: '1');
  final List<Period> periodWidgets = [];
  final intervalController = TextEditingController(text: '1');
  DateTime? startDate;

  RRuleGenerator({Key? key,
    this.textDelegate = const EnglishRRuleTextDelegate(),
    this.onChange,
    this.startDate,
    this.initialRRule = ''})
      : super(key: key) {
    startDate ??= DateTime.now();
    periodWidgets.addAll([
      Yearly(textDelegate, valueChanged, initialRRule, startDate!),
      Monthly(textDelegate, valueChanged, initialRRule, startDate!),
      Weekly(textDelegate, valueChanged, initialRRule, startDate!),
      Daily(textDelegate, valueChanged, initialRRule, startDate!)
    ]);

    handleInitialRRule();
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
      frequencyNotifier.value = 1;
    } else if (initialRRule.contains('WEEKLY')) {
      frequencyNotifier.value = 2;
    } else if (initialRRule.contains('DAILY')) {
      frequencyNotifier.value = 3;
    } else if (initialRRule == '') {
      frequencyNotifier.value = 4;
    }

    if (initialRRule.contains('COUNT')) {
      countTypeNotifier.value = 2;
      instancesController.text = initialRRule.substring(
          initialRRule.indexOf('COUNT=') + 6, initialRRule.length);
    } else if (initialRRule.contains('UNTIL')) {
      countTypeNotifier.value = 1;
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

    if (frequencyNotifier.value == 4) {
      return '';
    }

    if (countTypeNotifier.value == 0) {
      return 'RRULE:' + periodWidgets[frequencyNotifier.value].getRRule() + ';INTERVAL=${interval > 0 ? interval : 1}';
    } else if (countTypeNotifier.value == 2) {
      return 'RRULE:' +
          periodWidgets[frequencyNotifier.value].getRRule() +
          ';COUNT=${instancesController.text}'+ ';INTERVAL=${interval > 0 ? interval : 1}';
    }
    DateTime pickedDate = pickedDateNotifier.value;

    String day =
    pickedDate.day > 9 ? '${pickedDate.day}' : '0${pickedDate.day}';
    String month =
    pickedDate.month > 9 ? '${pickedDate.month}' : '0${pickedDate.month}';

    return 'RRULE:' +
        periodWidgets[frequencyNotifier.value].getRRule() +
        ';UNTIL=${pickedDate.year}$month$day'+ ';INTERVAL=${interval > 0 ? interval : 1}';

        
  }

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: frequencyNotifier,
          builder: (BuildContext context, int period, Widget? child) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(textDelegate.repeatsEvery, style: Constants.captionTextStyle,),
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
                          children: List.generate(4, (index) => Expanded(
                            child: GestureDetector(
                              onTap: (){
                                frequencyNotifier.value = mapRepeatEveryToPeriods(index);
                                valueChanged();
                              },
                              child: Container(
                                decoration: period == mapRepeatEveryToPeriods(index) ? Constants.selectedBoxDecoration : null,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(textDelegate.repeatsEveryList[index], style: period == mapRepeatEveryToPeriods(index) ? Constants.selectedTextStyle : Constants.unSelectedTextStyle,),
                                  )),
                                )
                              ),
                            ),
                          ))
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(height: period == 4 ? 0 : 16),
                  period == 4 ? Container() : periodWidgets[period],
                  SizedBox(height: period == 4 ? 0 : 16),
                  Text(textDelegate.start, style: Constants.captionTextStyle,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(textDelegate.endsOnDate, style: Constants.unSelectedTextStyle),
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
                  period == 4
                      ? Container()
                      : ValueListenableBuilder(
                    valueListenable: countTypeNotifier,
                    builder:
                        (BuildContext context, int countType, Widget? child) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: period == 4 ? 0 : 16),
                            Text(textDelegate.ends, style: Constants.captionTextStyle,),
                          ]+ List.generate(3, (index){
                            return GestureDetector(
                              onTap: (){
                                countTypeNotifier.value = index;
                                valueChanged();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: index == countTypeNotifier.value ? Constants.selectedBoxDecoration : null,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            textDelegate.endsOptionList[index],
                                            style: index == countTypeNotifier.value ? Constants.selectedTextStyle : Constants.unSelectedTextStyle,
                                          ),
                                        ),
                                      ),
                                      index == 1 ? Expanded(
                                        flex: 3,
                                        child: ValueListenableBuilder(
                                          valueListenable: pickedDateNotifier,
                                          builder: (context, DateTime pickedDate, _) {
                                            return AbsorbPointer(
                                              absorbing: index != countTypeNotifier.value,
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
                                      index == 2 ? Expanded(
                                        flex: 3,
                                        child: AbsorbPointer(
                                          absorbing: index != countTypeNotifier.value,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: IntervalPicker(instancesController, valueChanged)),
                                              SizedBox(width: 8.0,),
                                              Expanded(
                                                flex: 3,
                                                child: Text(textDelegate.instances, style: Constants.unSelectedTextStyle,))
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


  int mapRepeatEveryToPeriods(int repeatEvery){
    switch(repeatEvery){
      case 0: return 3;
      case 1: return 2;
      case 2: return 1;
      case 3: return 0;
      default: return 0;
    }
  }    
    
}
