import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/artist.dart';
import 'package:flutter_boilerplate/providers/artists_provider.dart';
import 'package:flutter_boilerplate/utils/validation.dart';
import 'package:provider/provider.dart';

import '../models/record.dart';
import '../providers/records_provider.dart';

class EditRecordScreen extends StatefulWidget {
  static const routeName = '/editRecord';

  @override
  _EditRecordScreenState createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _imageUrlController = TextEditingController();
  final _artistFocusNode = FocusNode();
  final _ratingFocusNode = FocusNode();
  final _yearFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  List<Artist> _artists = [];
  var _editedRecord = Record(
      id: null, title: '', artist: '', rating: 0, imageUrl: '', year: '');
  var _initValues = {
    'title': '',
    'artist': '',
    'rating': '',
    'year': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  TextFormField _getTitleField() {
    return TextFormField(
      initialValue: _initValues['title'],
      decoration: InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_artistFocusNode);
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedRecord = Record(
            title: value,
            artist: _editedRecord.artist,
            rating: _editedRecord.rating,
            year: _editedRecord.year,
            imageUrl: _editedRecord.imageUrl,
            id: _editedRecord.id,
            isFavorite: _editedRecord.isFavorite);
      },
    );
  }

  FormField _getArtistField() {
    return FormField(
      onSaved: (value) {
        _editedRecord = Record(
            title: _editedRecord.title,
            artist: value,
            rating: _editedRecord.rating,
            year: _editedRecord.year,
            imageUrl: _editedRecord.imageUrl,
            id: _editedRecord.id,
            isFavorite: _editedRecord.isFavorite);
      },
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Artist',
          ),
          isEmpty: _initValues['artist'] == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _initValues['artist'],
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _initValues['artist'] = newValue;
                  state.didChange(newValue);
                });
              },
              items: ['', ..._artists].map((value) {
                if (value == '') {
                  return DropdownMenuItem<String>(
                    value: '',
                    child: Container(),
                  );
                }

                return DropdownMenuItem<String>(
                  value: (value as Artist).id,
                  child: Text((value as Artist).name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  TextFormField _getRatingField() {
    return TextFormField(
      initialValue: _initValues['rating'],
      decoration: InputDecoration(labelText: 'Rating'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _ratingFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_yearFocusNode);
      },
      validator: ValidatorUtil.validateNumberInput,
      onSaved: (value) {
        _editedRecord = Record(
            title: _editedRecord.title,
            artist: _editedRecord.artist,
            rating: int.parse(value),
            year: _editedRecord.year,
            imageUrl: _editedRecord.imageUrl,
            id: _editedRecord.id,
            isFavorite: _editedRecord.isFavorite);
      },
    );
  }

  TextFormField _getYearField() {
    return TextFormField(
      initialValue: _initValues['year'],
      decoration: InputDecoration(labelText: 'Year'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedRecord = Record(
            title: value,
            artist: _editedRecord.artist,
            rating: _editedRecord.rating,
            year: _editedRecord.year,
            imageUrl: _editedRecord.imageUrl,
            id: _editedRecord.id,
            isFavorite: _editedRecord.isFavorite);
      },
    );
  }

  Row _getImageUrlField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        /* Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? Text('Enter a URL')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ), */
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Image URL'),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: _imageUrlController,
            focusNode: _imageUrlFocusNode,
            onFieldSubmitted: (_) {
              _saveForm();
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an image URL.';
              }
              if (!value.startsWith('http') && !value.startsWith('https')) {
                return 'Please enter a valid URL.';
              }
              if (!value.endsWith('.png') &&
                  !value.endsWith('.jpg') &&
                  !value.endsWith('.jpeg')) {
                return 'Please enter a valid image URL.';
              }
              return null;
            },
            onSaved: (value) {
              _editedRecord = Record(
                id: _editedRecord.id,
                title: _editedRecord.title,
                artist: _editedRecord.artist,
                rating: _editedRecord.rating,
                year: _editedRecord.year,
                isFavorite: _editedRecord.isFavorite,
                imageUrl: value,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _artists = Provider.of<ArtistsProvider>(context, listen: false).items;
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedRecord = Provider.of<RecordsProvider>(context, listen: false)
            .findById(productId)
            .record;
        _initValues = {
          'title': _editedRecord.title,
          'artist': _editedRecord.artist,
          'rating': _editedRecord.rating.toString(),
          'year': _editedRecord.year,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedRecord.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _artistFocusNode.dispose();
    _ratingFocusNode.dispose();
    _yearFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
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
    if (_editedRecord.id != null) {
      /* await Provider.of<Records>(context, listen: false)
          .updateRecord(_editedRecord.id, _editedRecord); */
    } else {
      try {
        await Provider.of<RecordsProvider>(context, listen: false)
            .addRecord(_editedRecord);
      } catch (error) {
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
        title: Text(_editedRecord.id != null ? 'Edit Record' : 'Add Record'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
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
