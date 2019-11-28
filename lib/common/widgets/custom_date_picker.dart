import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;
  final String label;
  final DateTime currentDate;

  CustomDatePicker(
      {@required this.onDateChange, @required this.label, this.currentDate});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _selectedDate;
  DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (widget.currentDate != null) {
      _selectedDate = widget.currentDate;
    }

    if (_today == null) {
      return Container();
    }

    return ListTile(
      onTap: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            onConfirm: (date) {
          if (date != null) {
            widget.onDateChange(date);
            setState(() => _selectedDate = date);
          }
          // selectedDate = date;
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
      leading: const Icon(Icons.today),
      title: Text(widget.label),
      subtitle: _selectedDate != null
          ? Text(DateFormat('dd-MM-yyyy').format(_selectedDate))
          : Text('Press to select a date'),
    );
  }
}
