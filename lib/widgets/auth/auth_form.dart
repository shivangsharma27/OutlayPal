import 'package:flutter/material.dart';
import '../global.dart' as globals;

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height:10),// for logo
        Card(
          elevation: 10,
          color: globals.themeColor[100],
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(fontSize: 16),
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        style: TextStyle(fontSize: 16),
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(hintText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                      SizedBox(height: 5,),
                    TextFormField(
                      style: TextStyle(fontSize: 16,),
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(hintText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(height: 12),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                          padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                          elevation: MaterialStateProperty.all(10),
                          backgroundColor:
                              MaterialStateProperty.all(globals.themeColor[900]),
                        ),
                        child: Text(_isLogin ? 'Login' : 'Signup',style: TextStyle(fontSize: 16),),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        child: Text(
                          _isLogin
                              ? 'Create new account'
                              : 'I already have an account !',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ButtonStyle(),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            globals.login = !globals.login;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
