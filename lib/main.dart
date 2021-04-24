import 'package:OutlayPlanner/widgets/chart_category.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import './widgets/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

import './screens/auth_screen.dart';
import 'screens/new_transaction.dart';
import 'screens/transaction_list.dart';
import 'widgets/chart_weekly.dart';
import './models/transaction.dart';
import './widgets/chart_monthly.dart';
import './backend/firestore.dart';

String currUserEmail;
List<Transaction> userTransactions = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: MaterialColor(0xff263238, globals.themeColor),
            primaryColor: globals.themeColor[900],
            // accentColor: Colors.purple,
            canvasColor: globals.themeColor[500],
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  button: TextStyle(color: Colors.white),
                ),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            )),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot){
              if (FirebaseAuth.instance.currentUser != null && globals.login == true) {
                
                  currUserEmail = FirebaseAuth.instance.currentUser.email;
                  return MyHomePage();
                
              } else {
                return AuthScreen();
              }
            })
        // (FirebaseAuth.instance.currentUser != null)? MyHomePage() : AuthScreen()

        );
  }
}

class MyHomePage extends StatefulWidget {
  // List<Transaction> userTransactions;

  // MyHomePage(this.userTransactions);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  _MyHomePageState() {
    mainScreen2();
  }

  Future<void> mainScreen2() async {
    currUserEmail = FirebaseAuth.instance.currentUser.email;

    print(currUserEmail);

    firestore.DocumentSnapshot docker =
        await transactions.doc(currUserEmail).get();
    docker.data().forEach((transaction, details) {
      final newTx = Transaction(
          category: details['category'],
          title: details['title'],
          amount: details['amount'],
          id: details['id'],
          date: DateTime.fromMicrosecondsSinceEpoch(
              details['date'].microsecondsSinceEpoch));
      userTransactions.add(newTx);
      print('khel gaya');
    });
    setState(() {
      isLoading = false;
    });
  }

  List<Transaction> get _recentTransactions {
    return userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Transaction> get _recentMonthlyTransactions {
    return userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 365),
        ),
      );
    }).toList();
  }

  // void _getUserTransaction()

  Map<String, double> get _categoryTransactions {
    Map<String, double> dataMap = {};
    for (var itr in userTransactions) {
      if (dataMap.containsKey(itr.category)) {
        dataMap[itr.category] += itr.amount;
      } else {
        dataMap[itr.category] = itr.amount;
      }
    }
    return dataMap;
  }

  Future<void> addUser(Map<String, Object> trans) {
    // Call the user's CollectionReference to add a new user
    return transactions
        .doc(currUserEmail)
        .update({trans['id'].toString().substring(0, 19): trans})
        .then((value) => print("transaction Added"))
        .catchError((error) => print("Failed to add transaction: $error"));
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate, String categoryy) {
    Map<String, Object> trans = {
      'title': txTitle,
      'amount': txAmount,
      'date': chosenDate,
      'id': DateTime.now().toString(),
      'category': categoryy
    };
    addUser(trans);

    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
      category: categoryy,
    );

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void _showChartWeekly(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Chart(_recentTransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _showChartMonthly(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            child: LineCharts(_recentMonthlyTransactions),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _showCategoryWise(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: ChartCategory(_categoryTransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewTransaction(_addNewTransaction),
      ),
    );
    // showModalBottomSheet(
    //   context: ctx,
    //   builder: (_) {
    //     return GestureDetector(
    //       onTap: () {},
    //       child: NewTransaction(_addNewTransaction),
    //       behavior: HitTestBehavior.opaque,
    //     );
    //   },
    // );
  }

  void stat() {
    setState(() {});
  }

  void _deleteTransaction(String id) {
    transactions.doc(currUserEmail).update({
      id.substring(0, 19): firestore.FieldValue.delete()
    }).catchError((error) => print("Failed to delete user's property: $error"));
    setState(() {
      userTransactions.removeWhere((tx) => tx.id == id);
    });
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
        title: Text(
          'OutlayPlanner',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle_sharp),
              iconSize: 35,
              onPressed: () => _alertDialog(context)),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 100,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              primary: globals.themeColor[100],
                            ),
                            child: Text(
                              "Daily",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            onPressed: () => _showChartWeekly(context),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              primary: globals.themeColor[100],
                            ),
                            child: Text(
                              "Monthly",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            onPressed: () => _showChartMonthly(context),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              primary: globals.themeColor[100],
                            ),
                            child: Text(
                              "Category",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            onPressed: () => _showCategoryWise(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Transactions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                  TransactionList(userTransactions, _deleteTransaction),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            padding: MaterialStateProperty.all(EdgeInsets.all(13)),
            elevation: MaterialStateProperty.all(10),
            backgroundColor: MaterialStateProperty.all(globals.themeColor[900]),
          ),
          child: Text(
            'Add Outlay',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ),
    );
  }
}
