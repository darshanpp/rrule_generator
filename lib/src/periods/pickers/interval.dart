import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rrule_generator/src/periods/constants.dart';

class IntervalPicker extends StatefulWidget {
  final Function onChange;
  final bool? forOccurance;
  final TextEditingController controller;

  const IntervalPicker(this.controller, this.onChange, {Key? key,this.forOccurance = false})
      : super(key: key);

  @override
  State<IntervalPicker> createState() => _IntervalPickerState();
}

class _IntervalPickerState extends State<IntervalPicker> {
  @override
  Widget build(BuildContext context) => TextField(
        textAlign: TextAlign.center,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        maxLength: (widget.forOccurance ?? false) ?  null : 2,
        cursorColor: (uiUtils.isDarkTheme ?? false) ? Colors.white : null,
        decoration: InputDecoration(
          counterText: '',
          border: UnderlineInputBorder(borderSide: BorderSide(color: 
          Color.fromRGBO(238, 239, 243, 1.0)))
        ),
        style: uiUtils.textFieldStyle,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (_) => widget.onChange(),
      );
}
