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
import 'package:rflutter_alert/rflutter_alert.dart';

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
        authResult.user.sendEmailVerification();
        Alert(
          style: AlertStyle(backgroundColor: globals.themeColor[100]),
          context: context,
          type: AlertType.info,
          onWillPopActive: true,
          title: "Please verify your Email",
          desc: "Click on the link sent at $email",
          closeFunction: () async {
            try {
              await FirebaseAuth.instance.currentUser.delete();
              showSnackBar("Previous sign up attempt cancelled", context);
            } on FirebaseAuthException catch (error) {
              if (error.code == 'requires-recent-login') {
                print(
                    'The user must reauthenticate before this operation can be executed.');
              }
              showSnackBar(error.message, context);
            } finally {
              Navigator.pop(context);
              setState(() {
                _isLoading = false;
              });
            }
          },
          buttons: [
            DialogButton(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.7],
                colors: [
                  Color(0xff90A4AE),
                  Color(0xff37474F),
                ],
              ),
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                await _auth.currentUser.reload();
                if (_auth.currentUser.emailVerified) {
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
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
                }
                
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ],
        ).show();
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
