import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/organization_model.dart';
import 'package:flutter_boilerplate/services/organizations_service.dart';
import 'package:flutter_boilerplate/utils/validation.dart';
import 'package:provider/provider.dart';

class EditOrganization extends StatefulWidget {
  static const routeName = '/editOrganization';

  @override
  _EditOrganizationState createState() => _EditOrganizationState();
}

class _EditOrganizationState extends State<EditOrganization> {
  final FocusNode _nameFocus = FocusNode();
  var _nameController = TextEditingController();
  var _isLoading = false;
  Organization _editedOrganization = Organization(id: null, name: '');

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>(debugLabel: 'editOrganizationForm');

    TextFormField _getNameField() {
      return TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocus,
        onFieldSubmitted: (value) {
          _nameFocus.unfocus();
        },
        validator: ValidatorUtil.validateTextInput,
        onSaved: (value) {
          _editedOrganization =
              Organization(id: _editedOrganization.id, name: value);
        },
        decoration: InputDecoration(
            hintText: 'the name of the organization',
            labelText: 'name',
            icon: Icon(Icons.text_fields),
            fillColor: Colors.white),
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

      if (_editedOrganization.id != null) {
        return;
        /* await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct); */
      } else {
        try {
          Organization newOrg =
              await Provider.of<OrganizationService>(context, listen: false)
                  .addOrganization(_editedOrganization);
          print('New org was added ${newOrg.id}');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_editedOrganization.id != null
            ? 'Edit Organization'
            : 'Add Organization'),
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
                    Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _getNameField(),
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
