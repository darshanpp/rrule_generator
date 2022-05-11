import 'package:flutter/material.dart';
import 'package:rrule_generator/localizations/text_delegate.dart';
import 'package:rrule_generator/src/periods/constants.dart';

class WeekdayPicker extends StatelessWidget {
  final RRuleTextDelegate textDelegate;
  final Function onChange;

  final List<ValueNotifier<bool>> weekdayNotifiers;
  final bool isSundaySow;
  const WeekdayPicker(this.weekdayNotifiers, this.textDelegate, this.onChange, this.isSundaySow,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(
          7,
          (index) => ValueListenableBuilder(
            valueListenable: weekdayNotifiers[index],
            builder: (BuildContext context, bool value, Widget? child) =>
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap:(){
                        weekdayNotifiers[index].value = !weekdayNotifiers[index].value;
                        onChange();
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxWidth, minWidth: constraints.maxWidth),
                            child: Container(
                              decoration: value ? Constants.selectedBoxDecoration : null,
                              child: Center(
                                child: Text(
                                  textDelegate.weekdays(isSundaySow)[index].characters.first.toUpperCase(),
                                  style: value ? Constants.selectedTextStyle : Constants.unSelectedTextStyle,
                                )
                              )
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),
          ),
        ),
      );
}
