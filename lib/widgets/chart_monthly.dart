import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'global.dart' as globals;

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
    var finalTotalSum = 0.0;
    for (var i = 0; i < groupedTransactionValues.length; i++) {
      finalTotalSum += groupedTransactionValues[i]['amount'];
      data.add(new BarChartModel(groupedTransactionValues[i]['month'],
          groupedTransactionValues[i]['amount']));
    }
    print(finalTotalSum);
    return [
      new charts.Series<BarChartModel, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.gray.shade900,
        domainFn: (BarChartModel sales, _) => sales.month,
        measureFn: (BarChartModel sales, _) =>
            (sales.financial / finalTotalSum) * 100,
        data: data,
        labelAccessorFn: (BarChartModel sales, _) {
          return sales.financial < 1000
              ? '\₹${sales.financial.toStringAsFixed(0)}'
              : '\₹${(sales.financial / 1000).toStringAsFixed(1)}' + 'K';
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            color: globals.themeColor[900],
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              'Month-Wise distribution',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: globals.themeColor[100]),
            ),
          )),
          flex: 1,
        ),
        Expanded(
          flex: 11,
          child: Card(
                  color: globals.themeColor[200],
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: (recentMonthlyTransactions.isEmpty)
              ? Center(
                  child: Text('No transactions added yet!'),
                )
              : charts.BarChart(
                    _createSampleData(),
                    animate: false,
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickProviderSpec: new charts
                          .StaticNumericTickProviderSpec(<charts.TickSpec<num>>[
                        charts.TickSpec<num>(0),
                        charts.TickSpec<num>(20),
                        charts.TickSpec<num>(40),
                        charts.TickSpec<num>(60),
                        charts.TickSpec<num>(80),
                        charts.TickSpec<num>(100),
                      ]),
                      ),
                      //renderSpec: new charts.NoneRenderSpec(), //GridlineRendererSpec(
                      // Display the measure axis labels below the gridline.
                      //
                      // 'Before' & 'after' follow the axis value direction.
                      // Vertical axes draw 'before' below & 'after' above the tick.
                      // Horizontal axes draw 'before' left & 'after' right the tick.
                      //labelAnchor: charts.TickLabelAnchor.before,
                      // Left justify the text in the axis.
                      //
                      // Note: outside means that the secondary measure axis would right
                      // justify.
                      //labelJustification: charts.TickLabelJustification.outside,
                    
                    // primaryMeasureAxis: new charts.NumericAxisSpec(
                    //     showAxisLine: true,
                    //     viewport: new charts.NumericExtents(
                    //       groupedTransactionValues[groupedTransactionValues.length - 1]
                    //           ['month'],
                    //       6),

                    //     renderSpec: new charts.GridlineRendererSpec(
                    //       labelStyle: new charts.TextStyleSpec(
                    //           fontSize: 18, // size in Pts.
                    //           color: charts.MaterialPalette.black),

                    //       // Change the line colors to match text color.
                    //       lineStyle:
                    //           new charts.LineStyleSpec(color: charts.MaterialPalette.black),
                    //     )),
                    domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 14,
                          color: charts.MaterialPalette.black,
                        ),
                      ),
                      viewport: new charts.OrdinalViewport(
                          groupedTransactionValues[
                              groupedTransactionValues.length - 1]['month'],
                          4),
                    ),
                    behaviors: [
                      new charts.ChartTitle(
                        'Outlay Percentage(%)',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification:
                            charts.OutsideJustification.middle,
                        innerPadding: 3,
                        titleStyleSpec: charts.TextStyleSpec(
                            color: charts.MaterialPalette.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold.toString()),
                      ),
                      // Adding this behavior will allow tapping a bar to center it in the viewport
                      new charts.SlidingViewport(
                        charts.SelectionModelType.action,
                      ),
                      new charts.PanBehavior(),
                    ],
                    // defaultRenderer: new charts.BarRendererConfig(
                    // groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 3.0),
                    defaultRenderer: new charts.BarRendererConfig(
                      barRendererDecorator: new charts.BarLabelDecorator(
                          labelPosition: charts.BarLabelPosition.auto,
                          labelPadding: 15,
                          labelAnchor: charts.BarLabelAnchor.end,
                          insideLabelStyleSpec: charts.TextStyleSpec(
                            fontSize: 12,
                            fontWeight: FontWeight.bold.toString(),
                            color: charts.MaterialPalette.white,
                          ),
                          outsideLabelStyleSpec: charts.TextStyleSpec(
                            fontSize: 11,
                            fontWeight: FontWeight.bold.toString(),
                            color: charts.MaterialPalette.black,
                          )),
                      cornerStrategy: const charts.ConstCornerStrategy(20),
                    ),
                  ),
                ),
        ),
      ],
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
