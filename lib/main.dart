import 'package:OutlayPlanner/widgets/chart_category.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import './screens/auth_screen.dart';
import './widgets/new_transaction.dart';
import 'screens/transaction_list.dart';
import 'widgets/chart_weekly.dart';
import './models/transaction.dart';
import './widgets/chart_monthly.dart';
import './backend/firestore.dart';

String currUserEmail;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Transaction> _userTransaction = [];
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
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
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              currUserEmail = FirebaseAuth.instance.currentUser.email;
              transactions
                  .doc(currUserEmail)
                  .get()
                  .then((firestore.DocumentSnapshot documentSnapshot) {
                documentSnapshot.data().forEach((transaction, details) {
                  final newTx = Transaction(
                      category: details['category'],
                      title: details['title'],
                      amount: details['amount'],
                      id: details['id'],
                      date:DateTime.fromMicrosecondsSinceEpoch( details['date'].microsecondsSinceEpoch));
                  _userTransaction.add(newTx);
                });
              });
              return MyHomePage(_userTransaction);
            }
            return AuthScreen();
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Transaction> userTransactions;

  MyHomePage(this.userTransactions);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Transaction> get _recentTransactions {
    return widget.userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Transaction> get _recentMonthlyTransactions {
    return widget.userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 365),
        ),
      );
    }).toList();
  }

  // void _getUserTransaction()
  Map<String, double> dataMap = {};
  Map<String, double> get _categoryTransactions {
    for (var itr in widget.userTransactions) {
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
        .update({trans['id'].toString().substring(0,19):trans})
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
      widget.userTransactions.add(newTx);
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
          child: LineCharts(_recentMonthlyTransactions),
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

  void _deleteTransaction(String id) {
    setState(() {
      widget.userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
        ),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app_outlined),
                      SizedBox(width: 4),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                  ),
                  child: Text("Weekly"),
                  onPressed: () => _showChartWeekly(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                  ),
                  child: Text("Monthly"),
                  onPressed: () => _showChartMonthly(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                  ),
                  child: Text("Category"),
                  onPressed: () => _showCategoryWise(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            TransactionList(widget.userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
