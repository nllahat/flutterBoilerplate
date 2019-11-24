import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/firebase_exception.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../utils/validation.dart';

enum RegisterType { EmailAndPassword }

class Register extends StatelessWidget {
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: deviceSize.width * 0.65,
                  height: deviceSize.height * 0.4,
                  child: FittedBox(
                    child: Image.asset(
                      'assets/logo/forward_logo.jpeg',
                      fit: BoxFit.cover,
                    ),
                  )),
              Text(
                'Create an account',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 10,
              ),
              RegisterForm(),
            ],
          ),
        )));
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({
    Key key,
  }) : super(key: key);

  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Column _getTextFields() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextFormField(
            // style: Theme.of(context).primaryTextTheme.display1,
            decoration: InputDecoration(
                // labelStyle: Theme.of(context).primaryTextTheme.headline,
                labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: ValidatorUtil.validateEmail,
            onSaved: (value) {
              _authData['email'] = value;
            },
          ),
          TextFormField(
            //style: Theme.of(context).primaryTextTheme.display1,
            decoration: InputDecoration(
                //labelStyle: Theme.of(context).primaryTextTheme.headline,
                labelText: 'Password'),
            obscureText: true,
            controller: _passwordController,
            validator: ValidatorUtil.validatePassword,
            onSaved: (value) {
              _authData['password'] = value;
            },
          ),
        ]);
  }

  Future<void> _submit(RegisterType type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (type) {
        case RegisterType.EmailAndPassword:
          if (!_formKey.currentState.validate()) {
            // Invalid!
            return;
          }
          _formKey.currentState.save();

          await Provider.of<AuthService>(context, listen: false)
              .registerWithEmailAndPassword(
            _authData['email'],
            _authData['password'],
          );
          break;
        default:
          throw new Exception('Unsupported register type');
      }
    } on FirebaseException catch (error) {
      print(error.getHumanReadableMessage());
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _registerWithEmailButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () => _submit(RegisterType.EmailAndPassword),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Create',
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      width: deviceSize.width * 0.65,
      child: Form(
        key: _formKey,
        child: _isLoading
            ? LinearProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _getTextFields(),
                  SizedBox(
                    height: 30,
                  ),
                  _registerWithEmailButton(),
                ],
              ),
      ),
    );
  }
}
