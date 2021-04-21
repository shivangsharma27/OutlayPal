import 'package:OutlayPlanner/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartCategory extends StatelessWidget {

  final Map<String,double> categoryTransactions;

  ChartCategory(this.categoryTransactions);
  
  final List<Color> colorlist = [Colors.orange, Colors.pink,Colors.green[100]];

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: categoryTransactions,
      animationDuration: Duration(milliseconds: 2000),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 1.5,
      colorList: colorlist,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}
