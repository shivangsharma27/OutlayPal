import 'package:OutlayPlanner/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'global.dart' as globals;

class ChartCategory extends StatelessWidget {
  final Map<String, double> categoryTransactions;

  ChartCategory(this.categoryTransactions);

  final List<Color> colorlist = [
    Colors.limeAccent,
    Colors.purpleAccent[400],
    Colors.orangeAccent[400],
    Colors.cyan[300],
    Colors.lightGreen,
    Colors.limeAccent[400],
    Colors.blue[400],
    Colors.red,
    globals.themeColor[200],
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: globals.themeColor[200],
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: PieChart(
        dataMap: categoryTransactions,
        animationDuration: Duration(milliseconds: 2000),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2,
        colorList: colorlist,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        ringStrokeWidth: 32,
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: globals.themeColor[900],
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          chartValueBackgroundColor: globals.themeColor[900],
          chartValueStyle: TextStyle(color: globals.themeColor[200],fontWeight: FontWeight.bold),
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: true,
          decimalPlaces: 1,
        ),
      ),
    );
  }
}
