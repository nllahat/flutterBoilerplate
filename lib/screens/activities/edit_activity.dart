import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/activity_model.dart';
import 'package:flutter_boilerplate/utils/validation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditActivity extends StatefulWidget {
  static const routeName = '/editActivity';

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  var _nameController = TextEditingController();
  var _descriptionController = TextEditingController();
  var isSwitched = false;
  DateTime startDate;
  var _isLoading = false;
  Activity editedActivity = Activity(
    id: null,
    name: '',
    generalDescription: '',
    isActive: false,
    startDate: null,
    endDate: null,
    address: null,
    coordinators: [],
    organisation: null,
    image: '',
  );

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>(debugLabel: 'editActivityForm');

    TextFormField _getNameField() {
      return TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocus,
        onFieldSubmitted: (value) {
          _descriptionFocus.unfocus();
        },
        validator: ValidatorUtil.validateTextInput,
        onSaved: (value) {
          editedActivity.name = value;
        },
        decoration: InputDecoration(
            hintText: 'the name of the activity',
            labelText: 'name',
            icon: Icon(Icons.text_fields),
            fillColor: Colors.white),
      );
    }

    TextFormField _getDescriptionField() {
      return TextFormField(
        controller: _descriptionController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        focusNode: _descriptionFocus,
        onFieldSubmitted: (value) {
          _nameFocus.unfocus();
        },
        validator: ValidatorUtil.validateTextInput,
        onSaved: (value) {
          editedActivity.generalDescription = value;
        },
        decoration: InputDecoration(
            hintText: 'a description of the activity',
            labelText: 'description',
            icon: Icon(Icons.text_fields),
            fillColor: Colors.white),
      );
    }

    SwitchListTile _getIsActiveField() {
      return SwitchListTile(
        title: Text('active'),
        value: isSwitched,
        onChanged: (bool value) {
          setState(() {
            isSwitched = value;
          });
        },
      );
    }

    AppFromDatePicker _getStartDateField() {
      return AppFromDatePicker(label: 'Start Date',onDateChange: (DateTime value) {
        setState(() {
            startDate = value;
        });
      });
    }

    AppFromDatePicker _getEndDateField() {
      return AppFromDatePicker(label: 'End Date',onDateChange: (DateTime value) {
        editedActivity.endDate = value;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(editedActivity.id != null ? 'Edit Activity' : 'Add Activity'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => {},
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: LinearProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _getIsActiveField(),
                    Form(
                      key: _form,
                      child: Column(
                        children: <Widget>[
                          _getNameField(),
                          _getDescriptionField(),
                          _getStartDateField(),
                          _getEndDateField(),
                          //_getImageUrlField()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class AppFromDatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;
  final String label;

  AppFromDatePicker({@required this.onDateChange, @required this.label});

  @override
  _AppFromDatePickerState createState() => _AppFromDatePickerState();
}

class _AppFromDatePickerState extends State<AppFromDatePicker> {
  DateTime _selectedDate;
  DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (_today == null) {
      return Container();
    }

    return ListTile(
      onTap: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(_today.year),
            // maxTime: DateTime(_today.year, _today.month, _today.day),
            theme: DatePickerTheme(
                backgroundColor: Colors.white,
                itemStyle:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                doneStyle: TextStyle(color: Colors.pink, fontSize: 16)),
            onConfirm: (date) {
          if (date != null) {
            widget.onDateChange(date);
            setState(() => _selectedDate = date);
          }
          // selectedDate = date;
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      leading: const Icon(Icons.today),
      title: Text(widget.label),
      subtitle: _selectedDate != null ? Text(DateFormat('dd-MM-yyyy').format(_selectedDate)) : Text('Press to select a date'),
    );
  }
}
