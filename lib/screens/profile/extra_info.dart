import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../utils/validation.dart';
import '../../common/widgets/custom_date_picker.dart';

class ExtraInfo extends StatelessWidget {
  static const routeName = '/exterInfo';

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
          child: Consumer<FirebaseUser>(
            builder: (context, firebaseUser, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: deviceSize.width * 0.3,
                    height: deviceSize.height * 0.3,
                    child: FittedBox(
                        child: Icon(
                      Icons.person_pin,
                      color: Colors.grey,
                    ))),
                Text(
                  firebaseUser != null
                      ? 'Hi, ${firebaseUser.displayName}'
                      : 'Hey you,',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'We need some extra information',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Provider.value(
                    value: UserService(),
                    child: Consumer<UserService>(
                      builder: (context, userSerivce, _) {
                        return FutureProvider<User>.value(
                            value: userSerivce.getUser(firebaseUser.uid),
                            child: ExtraInfoForm());
                      },
                    )),
              ],
            ),
          ),
        )));
  }
}

class ExtraInfoForm extends StatefulWidget {
  ExtraInfoForm({
    Key key,
  }) : super(key: key);

  _ExtraInfoFormState createState() => _ExtraInfoFormState();
}

class _ExtraInfoFormState extends State<ExtraInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  var _phoneNumberController = TextEditingController();
  var _emailController = TextEditingController();
  final _nameController = TextEditingController();
  User _editedUser = User(
      id: null,
      fullName: '',
      email: '',
      phoneNumber: '',
      birthDate: null,
      gender: Gender.Other,
      role: Role.Regular);
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      User user = Provider.of<User>(context);
      FirebaseUser fbUser = Provider.of<FirebaseUser>(context);

      if (user != null) {
        _editedUser = user;
      } else {
        _editedUser = User(
            id: fbUser.uid,
            fullName: fbUser.displayName,
            email: fbUser.email,
            phoneNumber: fbUser.phoneNumber,
            birthDate: null,
            gender: Gender.Other,
            role: Role.Regular);
        _nameController.text = fbUser.displayName;
        _emailController.text = fbUser.email;
        _phoneNumberController.text = fbUser.phoneNumber;
        /* _initValues = {
          'id': _editedUser.id,
          'fullName': _editedUser.fullName,
          'email': _editedUser.email,
          'phoneNumber': _editedUser.phoneNumber,
          'birthDate': _editedUser.birthDate,
          'gender': _editedUser.gender,
          'role': _editedUser.role
        }; */
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  TextFormField _getNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      validator: ValidatorUtil.validateTextInput,
      onSaved: (value) {
        _editedUser = new User(
            id: _editedUser.id,
            fullName: value,
            email: _editedUser.email,
            phoneNumber: _editedUser.phoneNumber,
            birthDate: _editedUser.birthDate,
            gender: _editedUser.gender,
            role: _editedUser.role);
      },
      decoration: InputDecoration(
          hintText: 'your full name',
          labelText: 'full name',
          icon: Icon(Icons.text_fields),
          fillColor: Colors.white),
    );
  }

  TextFormField _getEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocus,
      onFieldSubmitted: (_) {
        // FocusScope.of(context).requestFocus(_addressFocus);
      },
      // initialValue: _initValues['email'],
      validator: ValidatorUtil.validateEmail,
      onSaved: (value) {
        _editedUser = new User(
            id: _editedUser.id,
            fullName: _editedUser.fullName,
            email: value,
            phoneNumber: _editedUser.phoneNumber,
            birthDate: _editedUser.birthDate,
            gender: _editedUser.gender,
            role: _editedUser.role);
      },
      decoration: InputDecoration(
          hintText: 'Your email',
          labelText: 'email',
          icon: Icon(Icons.email),
          fillColor: Colors.white),
    );
  }

  TextFormField _getPhoneNumberField() {
    return TextFormField(
      controller: _phoneNumberController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      focusNode: _phoneNumberFocus,
      onFieldSubmitted: (_) {
        // FocusScope.of(context).requestFocus(_addressFocus);
      },
      validator: ValidatorUtil.validatePhoneNumber,
      onSaved: (value) {
        _editedUser = new User(
            id: _editedUser.id,
            fullName: _editedUser.fullName,
            email: _editedUser.email,
            phoneNumber: value,
            birthDate: _editedUser.birthDate,
            gender: _editedUser.gender,
            role: _editedUser.role);
      },
      decoration: InputDecoration(
          hintText: 'Your phone number',
          labelText: 'phone number',
          icon: Icon(Icons.phone_iphone),
          fillColor: Colors.white),
    );
  }

  RadioButtonGroup _getGenderRadioButtons() {
    return RadioButtonGroup(
      orientation: GroupedButtonsOrientation.HORIZONTAL,
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      // margin: const EdgeInsets.only(left: 4.0),
      onSelected: (String selected) {
        Gender selectedGender;

        switch (selected) {
          case "female":
            selectedGender = Gender.Female;
            break;
          case "male":
            selectedGender = Gender.Male;
            break;
          case "other":
            selectedGender = Gender.Other;
            break;
          default:
            selectedGender = Gender.Other;
        }

        setState(() {
          _editedUser = User(
              id: _editedUser.id,
              fullName: _editedUser.fullName,
              email: _editedUser.email,
              phoneNumber: _editedUser.phoneNumber,
              role: _editedUser.role,
              birthDate: _editedUser.birthDate,
              gender: selectedGender);
        });
      },
      labels: <String>[
        "female",
        "male",
        "other",
      ],
      picked: _editedUser.getGenderString(),
      itemBuilder: (Radio rb, Text txt, int i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            rb,
            txt,
          ],
        );
      },
    );
  }

  CustomDatePicker _getBirthdatePicker() {
    return CustomDatePicker(
        label: 'Birth date',
        onDateChange: (DateTime value) {
          setState(() {
            _editedUser = User(
                id: _editedUser.id,
                fullName: _editedUser.fullName,
                email: _editedUser.email,
                phoneNumber: _editedUser.phoneNumber,
                role: _editedUser.role,
                birthDate: value,
                gender: _editedUser.gender);
          });
        });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User newUser = await Provider.of<UserService>(context, listen: false)
          .setOrAddUser(_editedUser);
      print('New user was added ${newUser.id}');
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

  Widget _doneButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () => _submit(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Done', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      width: deviceSize.width * 0.80,
      child: Form(
        key: _formKey,
        child: _isLoading
            ? LinearProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _getNameField(),
                      _getEmailField(),
                      _getPhoneNumberField(),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                        leading: Icon(Icons.wc),
                        title: _getGenderRadioButtons(),
                        //subtitle: Text('gender'),
                      ),
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Gender:'),
                          _getGenderRadioButtons(),
                        ],
                      ), */
                      _getBirthdatePicker()
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _doneButton(),
                ],
              ),
      ),
    );
  }
}
