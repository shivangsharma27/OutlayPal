import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/global.dart' as globals;
import './new_transaction.dart';

import '../models/transaction.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  Map<String, Object> categoryIcons = {
    'Food': Icon(
      Icons.restaurant,
      color: Colors.orange[800],
    ),
    'Transport': Icon(Icons.train, color: Colors.pink[300]),
    'Health': Icon(
      Icons.healing,
      color: Colors.orange[200],
    ),
    'Entertainment': Icon(
      Icons.attractions,
      color: Colors.limeAccent[400],
    ),
    'Fuel': Icon(
      Icons.local_gas_station,
      color: Colors.yellow[800],
    ),
    'Bills': Icon(
      Icons.list_alt,
      color: Colors.lightGreen,
    ),
    'Fashion': Icon(Icons.dry_cleaning, color: Colors.blue[400]),
    'Groceries': Icon(
      Icons.local_grocery_store,
      color: Colors.red,
    ),
    'Others': Icon(
      Icons.add_circle,
      color: globals.themeColor[200],
    ),
  };

  void _alertDialog(BuildContext context, int index) {
    Alert(
      style: AlertStyle(backgroundColor: globals.themeColor[100]),
      context: context,
      type: AlertType.warning,
      title: "Are u Sure?",
      desc: "This will permanently delete your transaction.",
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
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            deleteTx(transactions[index].id);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
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
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 310,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                SizedBox(
                  height: 20,),
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/csk.png',
                      fit: BoxFit.cover,
                    )),
              ],
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Card(
                  color: globals.themeColor[200],
                  elevation: 10,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    leading: CircleAvatar(
                      backgroundColor: globals.themeColor[900],
                      radius: 30,
                      child: categoryIcons[transactions[index].category],
                    ),
                    title: Text(
                      transactions[index].title,
                      // style: Theme.of(context).textTheme.headline6,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '\₹${transactions[index].amount}',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(transactions[index].date),
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          iconSize: 30,
                          icon: Icon(Icons.delete),
                          color: globals.themeColor[900],
                          onPressed: () => _alertDialog(context, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
