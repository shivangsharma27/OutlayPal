import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'global.dart' as globals;

import 'chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
              child: Container(
                 margin: EdgeInsets.symmetric(vertical:4),
                color: globals.themeColor[900],
                padding: EdgeInsets.symmetric(horizontal:10,vertical:3),
                child: Text(
            'Day-Wise distribution',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: globals.themeColor[100]),
          ),
              )),
          flex: 1,
        ),
        Expanded(
          flex: 11,
          child: Card(
            color: globals.themeColor[200],
            elevation: 6,
            margin: EdgeInsets.fromLTRB(10,0,10,10),
            child:  (recentTransactions.isEmpty)
              ? Center(
                  child: Text('No transactions added yet!'),
                )
              : Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: groupedTransactionValues.map((data) {
                  return Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      data['day'],
                      data['amount'],
                      totalSpending == 0.0
                          ? 0.0
                          : (data['amount'] as double) / totalSpending,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
