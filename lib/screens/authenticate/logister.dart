import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/firebase_exception.dart';
import '../../screens/authenticate/register.dart';
import '../../utils/validation.dart';
import '../../services/auth_service.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'emailLoginForm');
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _showEmailLogin = false;

  Column _getTextFields() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: SizedBox(
                    height: 80,
                    child: Icon(
                      Icons.keyboard_backspace,
                      size: 40.0,
                    )),
                onTap: () {
                  setState(() {
                    _showEmailLogin = !_showEmailLogin;
                  });
                },
              ),
            ],
          ),
          TextFormField(
            // style: Theme.of(context).primaryTextTheme.display1,
            decoration: InputDecoration(
                // labelStyle: Theme.of(context).primaryTextTheme.headline,
                labelText: 'Email'),
            controller: _emailController,
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
          SizedBox(
            height: 30,
          ),
          _signInWithEmailButton()
        ]);
  }

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

  Widget _showSignInWithEmailButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () {
        setState(() {
          _showEmailLogin = !_showEmailLogin;
        });
      },
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

  Widget _signInWithEmailButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () => _submit(LogisterType.EmailAndPassword),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Sign in', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
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
            : !_showEmailLogin
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _continueWithGoogleButton(),
                      SizedBox(
                        height: 10,
                      ),
                      _showSignInWithEmailButton(),
                      SizedBox(
                        height: 30,
                      ),
                      _getOrDevider(context),
                      SizedBox(
                        height: 30,
                      ),
                      _registerWithEmailButton(),
                    ],
                  )
                : _getTextFields(),
      ),
    );
  }
}
