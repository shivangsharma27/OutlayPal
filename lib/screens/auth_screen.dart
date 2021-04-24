import 'package:OutlayPlanner/main.dart';
import 'package:OutlayPlanner/widgets/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:OutlayPlanner/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../backend/firestore.dart';
import '../widgets/global.dart' as globals;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
        });
        await FirebaseFirestore.instance
            .collection('Transactions')
            .doc(email)
            .set({});
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: globals.themeColor[200]),
          ),
          backgroundColor: globals.themeColor[900],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'An error occurred, please check your credentials!',
            style: TextStyle(color: globals.themeColor[900]),
          ),
          backgroundColor: globals.themeColor[200],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getGradient(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AuthForm(
          _submitAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
