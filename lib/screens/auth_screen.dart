import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../widgets/auth/verticalText.dart';
import '../widgets/auth/textLogin.dart';

import '../models/http_exception.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor,
              ]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  VerticalText(),
                  TextLogin(),
                ]),
                AuthCard()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Widget emailInput() => Padding(
        padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.lightBlueAccent,
              labelText: 'E-Mail',
              labelStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['email'] = value;
            },
          ),
        ),
      );

  Widget passwordInput() => Padding(
        padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
            ),
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            controller: _passwordController,
            validator: (value) {
              if (value.isEmpty || value.length < 4) {
                return 'Password is too short!';
              }
              return null;
            },
            onSaved: (value) {
              _authData['password'] = value;
            },
          ),
        ),
      );

  Widget submitButton() => Padding(
        padding:
            const EdgeInsets.only(top: 40, right: 50, left: 200, bottom: 20),
        child: Container(
          alignment: Alignment.bottomRight,
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  1.0, // horizontal, move right 10
                  1.0, // vertical, move down 10
                ),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: FlatButton(
            onPressed: () => _submit(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.tealAccent,
                ),
              ],
            ),
          ),
        ),
      );

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
      );
      setState(() {
        _isLoading = false;
      });

      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      print(error.toString());
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid mail';
      } else if (error.toString().contains('WEEK_PASSWORD')) {
        errorMessage = 'This is pasword is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find an email with this E-Mail Address';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      var errorMessage = 'Could not authenticate you. Please try again later!!';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            emailInput(),
            passwordInput(),
            submitButton(),
          ],
        ),
      ),
    );
  }
}
