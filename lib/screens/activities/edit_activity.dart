import 'dart:math';

import 'package:flutter_boilerplate/models/activity_model.dart';
import 'package:flutter_boilerplate/models/organization_model.dart';
import 'package:flutter_boilerplate/services/activities_service.dart';
import 'package:flutter_boilerplate/services/organizations_service.dart';
import 'package:flutter_boilerplate/utils/validation.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:provider/provider.dart';

class EditActivity extends StatefulWidget {
  static const routeName = '/editActivity';

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _imageFocus = FocusNode();
  var _nameController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _addressController = TextEditingController();
  var _imageController = TextEditingController();
  var isSwitched = false;
  DateTime startDate;
  DateTime endDate;
  String org;
  var _isLoading = false;
  Activity _editedActivity = Activity(
    id: null,
    name: '',
    generalDescription: '',
    isActive: false,
    startDate: null,
    endDate: null,
    address: null,
    coordinators: [],
    organization: null,
    image: '',
  );
  final _form = GlobalKey<FormState>(debugLabel: 'editActivityForm');

  TextFormField _getNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_descriptionFocus);
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedActivity = new Activity(
            id: _editedActivity.id,
            name: value,
            address: _editedActivity.address,
            startDate: _editedActivity.startDate,
            endDate: _editedActivity.endDate,
            generalDescription: _editedActivity.generalDescription,
            image: _editedActivity.image,
            isActive: _editedActivity.isActive,
            organization: _editedActivity.organization,
            coordinators: []);
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
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_addressFocus);
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedActivity = new Activity(
            id: _editedActivity.id,
            name: _editedActivity.name,
            address: _editedActivity.address,
            startDate: _editedActivity.startDate,
            endDate: _editedActivity.endDate,
            generalDescription: value,
            image: _editedActivity.image,
            isActive: _editedActivity.isActive,
            organization: _editedActivity.organization,
            coordinators: []);
      },
      decoration: InputDecoration(
          hintText: 'a description of the activity',
          labelText: 'description',
          icon: Icon(Icons.text_fields),
          fillColor: Colors.white),
    );
  }

  Switch _getIsActiveField() {
    return Switch(
      value: _editedActivity.isActive,
      onChanged: (bool value) {
        setState(() {
          _editedActivity = new Activity(
              id: _editedActivity.id,
              name: _editedActivity.name,
              address: _editedActivity.address,
              startDate: _editedActivity.startDate,
              endDate: _editedActivity.endDate,
              generalDescription: _editedActivity.generalDescription,
              image: _editedActivity.image,
              isActive: value,
              organization: _editedActivity.organization,
              coordinators: []);
        });
      },
    );
  }

  AppFromDatePicker _getStartDateField() {
    return AppFromDatePicker(
        currentDate: _editedActivity.startDate,
        label: 'Start Date',
        onDateChange: (DateTime value) {
          _editedActivity = new Activity(
              id: _editedActivity.id,
              name: _editedActivity.name,
              address: _editedActivity.address,
              startDate: value,
              endDate: _editedActivity.endDate,
              generalDescription: _editedActivity.generalDescription,
              image: _editedActivity.image,
              isActive: _editedActivity.isActive,
              organization: _editedActivity.organization,
              coordinators: []);
        });
  }

  AppFromDatePicker _getEndDateField() {
    return AppFromDatePicker(
        currentDate: _editedActivity.endDate,
        label: 'End Date',
        onDateChange: (DateTime value) {
          _editedActivity = new Activity(
              id: _editedActivity.id,
              name: _editedActivity.name,
              address: _editedActivity.address,
              startDate: _editedActivity.startDate,
              endDate: value,
              generalDescription: _editedActivity.generalDescription,
              image: _editedActivity.image,
              isActive: _editedActivity.isActive,
              organization: _editedActivity.organization,
              coordinators: []);
        });
  }

  TextFormField _getAddressField() {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: _addressFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_imageFocus);
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedActivity = new Activity(
            id: _editedActivity.id,
            name: _editedActivity.name,
            address: value,
            startDate: _editedActivity.startDate,
            endDate: _editedActivity.endDate,
            generalDescription: _editedActivity.generalDescription,
            image: _editedActivity.image,
            isActive: _editedActivity.isActive,
            organization: _editedActivity.organization,
            coordinators: []);
      },
      decoration: InputDecoration(
          hintText: 'the address',
          labelText: 'address',
          icon: Icon(Icons.location_on),
          fillColor: Colors.white),
    );
  }

  TextFormField _getImageField() {
    return TextFormField(
      controller: _imageController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: _imageFocus,
      onFieldSubmitted: (value) {
        _imageFocus.unfocus();
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedActivity = new Activity(
            id: _editedActivity.id,
            name: _editedActivity.name,
            address: _editedActivity.address,
            startDate: _editedActivity.startDate,
            endDate: _editedActivity.endDate,
            generalDescription: _editedActivity.generalDescription,
            image: value,
            isActive: _editedActivity.isActive,
            organization: _editedActivity.organization,
            coordinators: []);
      },
      decoration: InputDecoration(
          hintText: 'image url',
          labelText: 'image',
          icon: Icon(Icons.image),
          fillColor: Colors.white),
    );
  }

  InputDecorator _getOrganizationsDropDownList(List<Organization> orgs) {
    return InputDecorator(
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline),
        labelText: 'Organization',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _editedActivity.organization,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              _editedActivity = new Activity(
                  id: _editedActivity.id,
                  name: _editedActivity.name,
                  address: _editedActivity.address,
                  startDate: _editedActivity.startDate,
                  endDate: _editedActivity.endDate,
                  generalDescription: _editedActivity.generalDescription,
                  image: _editedActivity.image,
                  isActive: _editedActivity.isActive,
                  organization: newValue,
                  coordinators: []);
            });
          },
          items: orgs == null
              ? []
              : orgs.map((Organization value) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Text(value.name),
                  );
                }).toList(),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedActivity.id != null) {
      return;
      /* await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct); */
    } else {
      try {
        Activity newActivity =
            await Provider.of<ActivitiesService>(context, listen: false)
                .addActivity(_editedActivity);
        print('New activity was added ${newActivity.id}');
      } catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_editedActivity.id != null ? 'Edit Activity' : 'Add Activity'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(width: 330),
                        Expanded(child: _getIsActiveField()),
                      ],
                    ),
                    Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _getNameField(),
                          _getDescriptionField(),
                          _getAddressField(),
                          _getImageField(),
                          FutureBuilder(
                              future: Provider.of<OrganizationService>(context)
                                  .organizationList,
                              builder: (ctx, dataSnapshot) {
                                return _getOrganizationsDropDownList(
                                    dataSnapshot.data);
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(child: _getStartDateField()),
                              Expanded(child: _getEndDateField()),
                            ],
                          ),
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
  final DateTime currentDate;

  AppFromDatePicker(
      {@required this.onDateChange, @required this.label, this.currentDate});

  @override
  _AppFromDatePickerState createState() => _AppFromDatePickerState();
}

class _AppFromDatePickerState extends State<AppFromDatePicker> {
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
            minTime: DateTime(_today.year),
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
      subtitle: _selectedDate != null
          ? Text(DateFormat('dd-MM-yyyy').format(_selectedDate))
          : Text('Press to select a date'),
    );
  }
}
