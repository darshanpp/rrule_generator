import 'package:flutter/material.dart';
import 'package:rrule_generator/src/periods/constants.dart';

class WeekdayPicker extends StatelessWidget {
  final Function onChange;

  List<WeekModel> weekDays = [];
  WeekdayPicker(this.onChange, this.weekDays,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(
          weekDays.length,
          (index) => ValueListenableBuilder(
            valueListenable: weekDays[index].isSelected,
            builder: (BuildContext context, bool value, Widget? child) =>
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap:(){
                        weekDays[index].isSelected.value = !weekDays[index].isSelected.value;
                        onChange();
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxWidth, minWidth: constraints.maxWidth),
                            child: Container(
                              decoration: value ? uiUtils.selectedBoxDecoration : null,
                              child: Center(
                                child: Text(
                                  weekDays[index].localizedName.characters.first.toUpperCase(),
                                  style: value ? uiUtils.selectedTextStyle : uiUtils.unSelectedTextStyle,
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
