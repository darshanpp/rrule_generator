import 'package:flutter/material.dart';
import 'package:rrule_generator/src/periods/constants.dart';

class RRuleDatePicker extends StatefulWidget {
  DateTime date;
  Function onChange;
  RRuleDatePicker({required this.date, required this.onChange, Key? key }) : super(key: key);

  @override
  State<RRuleDatePicker> createState() => _RRuleDatePickerState();
}

class _RRuleDatePickerState extends State<RRuleDatePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ()async{
        var selectedDate = await showDatePicker(
          context: context, 
          initialDate: (widget.date != null) ? widget.date : DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2101));
        setState(() {
          widget.date = selectedDate ?? widget.date;
        });
        widget.onChange.call(widget.date);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(238, 239, 243, 1.0)))),
        child: Text(Constants.getDateString(widget.date), style: Constants.textFieldStyle,),
      ),
    );
  }
}