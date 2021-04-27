import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'global.dart' as globals;

class ChartCategory extends StatelessWidget {
  final Map<String, double> categoryTransactions;

  ChartCategory(this.categoryTransactions);

  final List<Color> colorlist = [
    Colors.yellow,
    Colors.purpleAccent[400],
    Colors.orangeAccent[400],
    Colors.cyan[300],
    Colors.lightGreen,
    Colors.limeAccent[400],
    Colors.blue[400],
    Colors.red,
    globals.themeColor[500],
  ];

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
            'Category-Wise distribution',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: globals.themeColor[100]),
          ),
              )),
          flex: 1,
        ),
        Expanded(
          flex:11,
                  child: Card(
            color: globals.themeColor[200],
            elevation: 6,
            margin: EdgeInsets.fromLTRB(10,0,10,10),
            child: (categoryTransactions.isEmpty)? Center(child:Text("No Transactions Added yet!"),):
            PieChart(
              dataMap: categoryTransactions,
              animationDuration: Duration(milliseconds: 2000),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 1.5,
              colorList: colorlist,
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              ringStrokeWidth: 32,
              legendOptions: LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: globals.themeColor[900],
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                chartValueBackgroundColor: globals.themeColor[900],
                chartValueStyle: TextStyle(color: globals.themeColor[200],fontSize: 10),
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: true,
                decimalPlaces: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
