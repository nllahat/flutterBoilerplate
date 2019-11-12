import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/activity_model.dart';

class EditActivity extends StatefulWidget {
  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  var _isLoading = false;
  var editedActivity = Activity(
    id: null,
    coordinators: [],
    endDate: null,
    generalDescription: '',
    image: '',
    isActive: false,
    location: null,
    name: '',
    organisation: null,
    startDate: null
  );



  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(editedActivity.id != null ? 'Edit Activity' : 'Add Activity'),
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    _getTitleField(),
                    _getArtistField(),
                    _getRatingField(),
                    _getYearField(),
                    _getImageUrlField()
                  ],
                ),
              ),
            ),
    );
  }
}