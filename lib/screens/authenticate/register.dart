import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../models/firebase_exception.dart';
import '../../services/auth_service.dart';
import '../../utils/validation.dart';

enum RegisterType { EmailAndPassword, Google }

class Register extends StatelessWidget {
  static const routeName = '/register';

  final Function toggleView;
  Register({this.toggleView});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
                      'assets/logo/logo_transparent.png',
                      fit: BoxFit.cover,
                    ),
                  )),
              Text(
                'Please register to continue',
                style: Theme.of(context).primaryTextTheme.subtitle,
              ),
              RegisterForm(toggleView: this.toggleView),
            ],
          ),
        )));
  }
}

class RegisterForm extends StatefulWidget {
  final Function toggleView;
  RegisterForm({Key key, @required this.toggleView}) : super(key: key);

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

  Widget _getOrDevider(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'or',
            style: Theme.of(context).primaryTextTheme.display2,
          ),
        ),
        Expanded(
          child: Divider(),
        )
      ],
    );
  }

  Widget _signUpWithGoogleButton() {
    return RaisedButton(
      onPressed: () => _submit(RegisterType.Google),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(
              image: AssetImage("assets/images/google_logo.png"), height: 30.0),
          Spacer(),
          Text(
            'Sign in with Google',
          ),
          Spacer(),
        ],
      ),
    );
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
        /* case LoginType.Google:
          await Provider.of<AuthService>(context, listen: false).signInWithGoogle();
          break; */
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              style: Theme.of(context).primaryTextTheme.display1,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).primaryTextTheme.headline,
                  labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: ValidatorUtil.validateEmail,
              onSaved: (value) {
                _authData['email'] = value;
              },
            ),
            TextFormField(
              style: Theme.of(context).primaryTextTheme.display1,
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).primaryTextTheme.headline,
                  labelText: 'Password'),
              obscureText: true,
              controller: _passwordController,
              validator: ValidatorUtil.validatePassword,
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? LinearProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        child: Text('Register'),
                        onPressed: () => _submit(RegisterType.EmailAndPassword),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _getOrDevider(context),
                      SizedBox(
                        height: 10,
                      ),
                      _signUpWithGoogleButton(),
                      SizedBox(
                        height: 30,
                      ),
                      FlatButton(
                        child: Text('Already have an account?'),
                        onPressed: () => widget.toggleView(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textColor:
                            Theme.of(context).primaryTextTheme.subtitle.color,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
