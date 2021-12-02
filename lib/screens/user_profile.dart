import 'package:OutlayPal/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';
import '../widgets/global.dart' as globals;

class User_profile extends StatelessWidget {
  String userName;
  double monthlyAmount = 0.0;
  final List<Transaction> lastYearTransactions;

  User_profile(this.userName, this.lastYearTransactions) {
    String myMonth = DateTime.now().month.toString();
    for (var i = 0; i < lastYearTransactions.length; i++) {
      if (lastYearTransactions[i].date.month.toString() == myMonth) {
        monthlyAmount += lastYearTransactions[i].amount;
      }
    }
    userName = userName.substring(0, userName.indexOf('@'));
  }

  void _alertDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(backgroundColor: globals.themeColor[100]),
      title: "Are u Sure?",
      desc: "You will be signed out.",
      buttons: [
        DialogButton(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7],
            colors: [
              //Sunkist
              Color(0xff90A4AE),
              Color(0xff37474F),
            ],
          ),
          child: Text(
            "YES",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            userTransactions = [];
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7],
            colors: [
              Color(0xff90A4AE),
              Color(0xff37474F),
            ],
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          width: 190,
          height: 45,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.account_circle_sharp),
              onPressed: () => {},
              iconSize: 200,
            ),
            Text(
              "User name:" + userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Total expenses this month:" + monthlyAmount.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => _alertDialog(context),
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
