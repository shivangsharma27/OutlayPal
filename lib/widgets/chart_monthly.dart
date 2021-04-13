import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
        'month': DateFormat.MMM().format(myMonth).substring(0,3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }
    final List<double> aaa = []; 


  final Map<String,double> mapp = {
    'Jan':0,
    'Feb':1,
    'Mar':2,
    'Apr':3,
    'May':4,
    'Jun':5,
    'Jul':6,
    'Aug':7,
    'Sep':8,
    'Oct':9,
    'Nov':10,
    'Dec':11,
  };



  @override
  Widget build(BuildContext context) {
    const cutOffYValue = 0.0;
    const yearTextStyle = TextStyle(fontSize: 12, color: Colors.black);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: groupedTransactionValues.map((data) {
                print(data['month']);
                aaa.add(data['amount']);
                return FlSpot(mapp[data['month']], data['amount']);
              }).toList(),
              isCurved: false,
              barWidth: 2,
              colors: [
                Colors.black,
              ],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.lightBlue.withOpacity(0.5)],
                cutOffY: cutOffYValue,
                applyCutOffY: true,
              ),
              aboveBarData: BarAreaData(
                show: true,
                colors: [Colors.lightGreen.withOpacity(0.5)],
                cutOffY: cutOffYValue,
                applyCutOffY: true,
              ),
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          minY: 0,
          // maxY: 100,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 12,
                textStyle: yearTextStyle,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'JAN';
                    case 1:
                      return 'FEB';
                    case 2:
                      return 'MAR';
                    case 3:
                      return 'APR';
                    case 4:
                      return 'MAY';
                    case 5:
                      return 'JUN';
                    case 6:
                      return 'JUL';
                    case 7:
                      return 'AUG';
                    case 8:
                      return 'SEP';
                    case 9:
                      return 'OCT';
                    case 10:
                      return 'NOV';
                    case 11:
                      return 'DEC';
                    default:
                      return '';
                  }
                }),
            leftTitles: SideTitles(
              showTitles: true,
              // reservedSize: 10,
              getTitles: (value) {
                for(var i in aaa){
                    print(i);
                }
                // if(aaa.contains(value)){
                //   // print(value);
                  return '${value}';
              // }
                // else
                //   return '${value}';
              },
            ),
          ),
          axisTitleData: FlAxisTitleData(
              leftTitle:
                  AxisTitle(showTitle: true, titleText: 'Value', margin: 10),
              bottomTitle: AxisTitle(
                  showTitle: true,
                  margin: 10,
                  titleText: 'Year',
                  textStyle: yearTextStyle,
                  textAlign: TextAlign.right)),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (double value) {
              return value == 1 || value == 2 || value == 3 || value == 5;
            },
          ),
        ),
      ),
    );
  }
}
