import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineCharts extends StatelessWidget {
  final List<Transaction> recentMonthlyTransactions;

  LineCharts(this.recentMonthlyTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(12, (index) {
      final myMonth = DateTime.now().subtract(
        Duration(days: index * 30),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentMonthlyTransactions.length; i++) {
        if (recentMonthlyTransactions[i].date.month == myMonth.month &&
            recentMonthlyTransactions[i].date.year == myMonth.year) {
          totalSum += recentMonthlyTransactions[i].amount;
        }
      }
      return {
        'month': DateFormat.MMM().format(myMonth).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  // List<Map<String, Object>> groupedTransactions;
  // void getValues (List<Map<String, Object>> groupedTransactionValues){
  //     groupedTransactionValues.map((data){
  //       groupedTransactions.add({
  //         'month' : data['month'],
  //         'amount' : data['amount']
  //       });
  //     });
  // }

  List<charts.Series<BarChartModel, String>> _createSampleData() {
    final List<BarChartModel> data = [];
    for (var i = 0; i < groupedTransactionValues.length; i++) {
      data.add(new BarChartModel(groupedTransactionValues[i]['month'], groupedTransactionValues[i]['amount']));
    }
    
    return [
      new charts.Series<BarChartModel, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartModel sales, _) => sales.month,
        measureFn: (BarChartModel sales, _) => sales.financial,
        data: data,
      )
  ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: charts.BarChart(_createSampleData(), animate: true,)  
    );
  }
}

class BarChartModel {
  String month;
  double financial;

  BarChartModel(
    this.month,
    this.financial,
  );
}
