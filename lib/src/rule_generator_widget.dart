import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/localized_text.dart';
import 'package:rrule_generator/localizations/text_utils.dart';
import 'package:rrule_generator/src/never.dart';
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
  String currentLocale;

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
  UIUtils? uiOptions;

  RRuleGenerator({Key? key,
    this.onChange,
    this.startDate,
    required this.localizedTextFromApp,
    this.currentLocale = 'en_US',
    this.startWeekWith = DateTime.monday,
    this.uiOptions,
    this.initialRRule = ''})
      : super(key: key) {
    startDate ??= DateTime.now();
    initializeData();
    periodWidgets.addAll([
      Never(valueChanged, initialRRule, startDate!),
      Daily(valueChanged, initialRRule, startDate!),
      Weekly(valueChanged, initialRRule, startDate!, startWeekWith),
      Monthly(valueChanged, initialRRule, startDate!),
      Yearly(valueChanged, initialRRule, startDate!),
    ]);
    handleInitialRRule();
  }

  void initializeData(){
    uiUtils = uiOptions ?? UIUtils();
    localizedText = localizedTextFromApp;
    TextUtils.currentLocale = currentLocale;
    repeatsEveryList = [
      localizedText.repeatNever,
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
      frequencyNotifier.value = RepeatsEvery.never;
    }
    resetEndValues();

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
    String rule = '';
    if (frequencyNotifier.value == RepeatsEvery.never) {
      return '';
    }

    if (countTypeNotifier.value == EndsType.never) {
      rule = 'RRULE:' + periodWidgets[frequencyNotifier.value!.index].getRRule();
    } 
    else if (countTypeNotifier.value == EndsType.after) {
      rule = 'RRULE:' +
          periodWidgets[frequencyNotifier.value!.index].getRRule() +
          ';COUNT=${instancesController.text}';
    }
    else{
      DateTime pickedDate = pickedDateNotifier.value;

      String day =
      pickedDate.day > 9 ? '${pickedDate.day}' : '0${pickedDate.day}';
      String month =
      pickedDate.month > 9 ? '${pickedDate.month}' : '0${pickedDate.month}';
      String timeString = 'T235959';
      rule = 'RRULE:' +
          periodWidgets[frequencyNotifier.value!.index].getRRule() +
          ';UNTIL=${pickedDate.year}$month$day$timeString'; 
    }
    
    var index = rule.indexOf(';');
    var finalRule = (index < 0 ? rule.substring(0) : rule.substring(0, index)) + ';';
    finalRule += 'INTERVAL=${interval > 0 ? interval : 1}';
    finalRule += index < 0 ? '' : rule.substring(index);
    return finalRule;         
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<RepeatsEvery?>(
        valueListenable: frequencyNotifier,
        builder: (BuildContext context, period, Widget? child) =>
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(RepeatsEvery.values.length, (index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: GestureDetector(
                            onTap: (){
                              frequencyNotifier.value = RepeatsEvery.values[index];
                              resetValues();
                              valueChanged();
                            },
                            child: Container(
                              decoration: period == RepeatsEvery.values[index] ? uiUtils.selectedBoxDecoration : uiUtils.unSelectedBoxDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(repeatsEveryList[index], style: period == RepeatsEvery.values[index] ? uiUtils.selectedTextStyle : uiUtils.unSelectedTextStyle,),
                              )
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: Duration(milliseconds: 300,),
                          alignment: Alignment.topCenter,
                          child: period == RepeatsEvery.values[index] && period != RepeatsEvery.never ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                periodWidgets[index],
                                SizedBox(height: 16),
                                Text(localizedText.repeatsEvery, style: uiUtils.captionTextStyle,),
                                SizedBox(height: 4.0,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 72,
                                    child: IntervalPicker(intervalController, valueChanged)),
                                )
                              ],
                            ),
                          )
                          : SizedBox(),
                        )
                      ],
                    ))
                  ),
                ),
                Visibility(
                  visible: period != RepeatsEvery.never,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(height: 12, color: Color.fromRGBO(243, 242, 244, 1.0),),
                  ),
                ),

                Visibility(
                  visible: period != RepeatsEvery.never,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
                        //  Hide Recurrance Start so that user don't change it.
                        //  https://dynamicelements.atlassian.net/browse/DF-8281
                        //  --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
                        // SizedBox(height: 16),                        
                        // Text(localizedText.start, style: uiUtils.captionTextStyle,),
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(16.0),
                        //       child: Text(localizedText.onDate, style: uiUtils.unSelectedTextStyle),
                        //     ),
                        //     RRuleDatePicker(
                        //       date: startDate!,
                        //       onChange: (date){
                        //         startDate = date;
                        //         periodWidgets.forEach((i){i.refresh(date);});
                        //         valueChanged();
                        //       },
                        //     ),
                        //   ],
                        // ),
                        //  --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
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
                                  Text(localizedText.ends, style: uiUtils.captionTextStyle,),
                                ]+ List.generate(EndsType.values.length, (index){
                                  return GestureDetector(
                                    onTap: (){
                                      countTypeNotifier.value = EndsType.values[index];
                                      valueChanged();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: EndsType.values[index] == countTypeNotifier.value ? uiUtils.selectedBoxDecoration : null,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  endsOptionList[index],
                                                  style: EndsType.values[index] == countTypeNotifier.value ? uiUtils.selectedTextStyle : uiUtils.unSelectedTextStyle,
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
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        RRuleDatePicker(
                                                          date: pickedDate, 
                                                          onChange: (picked){
                                                            if (picked != null && picked != pickedDate) {
                                                              pickedDateNotifier.value = picked;
                                                              valueChanged();
                                                            }
                                                          }),
                                                      ],
                                                    ),
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
                                                      child: Text(localizedText.occurrence, style: uiUtils.unSelectedTextStyle,))
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
                )              ],
            ),
      );  

  void resetValues(){
    intervalController.text = '1';
    switch(frequencyNotifier.value){
      case RepeatsEvery.never:
        break;
      case RepeatsEvery.daily:
        break;
      case RepeatsEvery.weekly:
        periodWidgets[frequencyNotifier.value!.index].reset();
        break;
      case RepeatsEvery.monthly:
        periodWidgets[frequencyNotifier.value!.index].reset();
        break;
      case RepeatsEvery.yearly:
        break;
      default: break;
    }
    resetEndValues();
  }

  void resetEndValues(){
    switch(frequencyNotifier.value){
      case RepeatsEvery.never:
        break;
      case RepeatsEvery.daily:
        if(countTypeNotifier.value != EndsType.endOn){
          var start = startDate ?? DateTime.now();
          pickedDateNotifier.value = DateTime(start.year, start.month+1, start.day);
        }
        if(countTypeNotifier.value != EndsType.after){
          instancesController.text = '30';
        }
        break;
      case RepeatsEvery.weekly:
        if(countTypeNotifier.value != EndsType.endOn){
          var start = startDate ?? DateTime.now();
          pickedDateNotifier.value = DateTime(start.year, start.month + 3, start.day);        }
        if(countTypeNotifier.value != EndsType.after){
          instancesController.text = '13';
        }
        break;
      case RepeatsEvery.monthly:
        if(countTypeNotifier.value != EndsType.endOn){
          var start = startDate ?? DateTime.now();
          pickedDateNotifier.value = DateTime(start.year + 1, start.month, start.day);
        }
        if(countTypeNotifier.value != EndsType.after){
          instancesController.text = '12';
        }
        break;
      case RepeatsEvery.yearly:
        if(countTypeNotifier.value != EndsType.endOn){
          var start = startDate ?? DateTime.now();
          pickedDateNotifier.value = DateTime(start.year + 5, start.month, start.day);        }
        if(countTypeNotifier.value != EndsType.after){
          instancesController.text = '5';
        }
        break;
      default: break;
    }
  }  
}
