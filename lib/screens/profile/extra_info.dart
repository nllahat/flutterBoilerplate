import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/user_model.dart';
import 'package:flutter_boilerplate/services/auth_service.dart';
import 'package:flutter_boilerplate/services/user_service.dart';
import '../../common/widgets/custom_date_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

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
                        return FutureProvider.value(
                          value: userSerivce.getUser(firebaseUser.uid),
                          child: Consumer<User>(
                            builder: (context, user, _) =>
                                ExtraInfoForm(user: user),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        )));
  }
}

class ExtraInfoForm extends StatefulWidget {
  final User user;
  final String uid;

  ExtraInfoForm({
    Key key,
    @required this.user,
    @required this.uid,
  }) : super(key: key);

  _ExtraInfoFormState createState() => _ExtraInfoFormState();
}

class _ExtraInfoFormState extends State<ExtraInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  User _editedUser = User(
    id: null,
    birthDate: null,
    gender: Gender.Other,
  );
  var _isLoading = false;

  RadioButtonGroup _getGenderRadioButtons() {
    return RadioButtonGroup(
      orientation: GroupedButtonsOrientation.HORIZONTAL,
      margin: const EdgeInsets.only(left: 4.0),
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
                birthDate: value,
                gender: _editedUser.gender);
          });
        });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    if (_editedUser.id != null) {
      return;
      /* await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct); */
    } else {
      try {
        User newUser = await Provider.of<UserService>(context, listen: false)
            .addUser(_editedUser);
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

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
    if (widget.user != null) {
      _editedUser = widget.user;
    }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Gender:'),
                          _getGenderRadioButtons(),
                        ],
                      ),
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
