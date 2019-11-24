import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/firebase_exception.dart';
import 'package:flutter_boilerplate/screens/authenticate/register.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../utils/validation.dart';

enum LogisterType { EmailAndPassword, Google }

class Logister extends StatelessWidget {
  static const routeName = '/logister';

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
              LogisterForm(),
            ],
          ),
        )));
  }
}

class LogisterForm extends StatefulWidget {
  LogisterForm({
    Key key,
  }) : super(key: key);

  _LogisterFormState createState() => _LogisterFormState();
}

class _LogisterFormState extends State<LogisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  Widget _getOrDevider(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: Divider(
            thickness: 2.0,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'or',
            style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
          ),
        ),
        Expanded(
          child: Divider(thickness: 2.0, color: Colors.black),
        ),
        SizedBox(
          width: 30.0,
        ),
      ],
    );
  }

  Widget _signInWithEmailButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () => _submit(LogisterType.EmailAndPassword),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(image: AssetImage("assets/logo/f_logo.jpeg"), height: 30.0),
          Spacer(),
          Text('Sign in with Email',
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          Spacer(),
        ],
      ),
    );
  }

  Widget _registerWithEmailButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pushNamed(Register.routeName);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.person,
            color: Colors.grey,
          ),
          Spacer(),
          Text('Create your account',
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          Spacer(),
        ],
      ),
    );
  }

  Widget _continueWithGoogleButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () => _submit(LogisterType.Google),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
              image: AssetImage("assets/images/google_logo.png"), height: 30.0),
          Spacer(),
          Text(
            'Continue with Google',
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Future<void> _submit(LogisterType type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (type) {
        case LogisterType.EmailAndPassword:
          if (!_formKey.currentState.validate()) {
            // Invalid!
            return;
          }
          _formKey.currentState.save();

          await Provider.of<AuthService>(context, listen: false)
              .signInWithEmailAndPassword(
            _authData['email'],
            _authData['password'],
          );
          break;
        case LogisterType.Google:
          await Provider.of<AuthService>(context, listen: false)
              .signInWithGoogle();
          break;
        default:
          throw new Exception('Unsupported login type');
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
                  _continueWithGoogleButton(),
                  SizedBox(
                    height: 10,
                  ),
                  _signInWithEmailButton(),
                  SizedBox(
                    height: 30,
                  ),
                  _getOrDevider(context),
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
