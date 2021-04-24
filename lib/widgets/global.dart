library my_prj.globals;

import 'dart:math';

import 'package:flutter/material.dart';

bool login = true;
Map<int, Color> themeColor = {
  50: Colors.blueGrey[50],
  100: Colors.blueGrey[100],
  200: Colors.blueGrey[200],
  300: Colors.blueGrey[300],
  400: Colors.blueGrey[400],
  500: Colors.blueGrey[500],
  600: Colors.blueGrey[600],
  700: Colors.blueGrey[700],
  800: Colors.blueGrey[800],
  900: Colors.blueGrey[900]
}; //263238
// Map<int, Color> themeColor = {
//   50: Colors.lime[50],
//   100: Colors.lime[100],
//   200: Colors.lime[200],
//   300: Colors.lime[300],
//   400: Colors.lime[400],
//   500: Colors.lime[500],
//   600: Colors.lime[600],
//   700: Colors.lime[700],
//   800: Colors.lime[800],
//   900: Colors.lime[900],
//   1000: Colors.limeAccent,
//   1100: Colors.limeAccent[100],
//   1200: Colors.limeAccent[400],
//   1300: Colors.limeAccent[700]
// };//827717

BoxDecoration getGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.2, 0.7],
      colors: [
        //Sunkist
        Color(0xff90A4AE),
        Color(0xff37474F),
      ],
    ),
  );
}

void showSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    new SnackBar(backgroundColor: themeColor[900],
     // padding: EdgeInsets.symmetric(v),
      elevation: 4,
      duration: Duration(seconds: 3),
      content: Text(text,style: TextStyle(fontSize:14),),
      shape: RoundedRectangleBorder(
          side: BorderSide.none, borderRadius: BorderRadius.circular(8.0)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
