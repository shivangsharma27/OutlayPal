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
            primarySwatch: Colors.lightGreen,
            accentColor: Colors.purple,
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
              if (FirebaseAuth.instance.currentUser != null) {
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
  Map<String, double> dataMap = {};
  Map<String, double> get _categoryTransactions {
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

  void stat() {
    setState(() {});
  }

  void _deleteTransaction(String id) {
    transactions
        .doc(currUserEmail)
        .update({id.substring(0, 19): firestore.FieldValue.delete()})
          .catchError(
              (error) => print("Failed to delete user's property: $error"));
    setState(() {
      userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OutlayPlanner',
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
                userTransactions = [];
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  TransactionList(userTransactions, _deleteTransaction),
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
