import 'package:flutter/material.dart';
import 'global.dart' as globals;

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            height: 15,
            child: Stack(
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: globals.themeColor[900],
                      // border: Border.symmetric(
                      //   horizontal: BorderSide(
                      //     color: globals.themeColor[900],
                      //     width: 2.0,
                      //   ),
                      // ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: globals.themeColor[900],
                      width: 2.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 20,
            child: FittedBox(
              child: Text(
                '\₹${spendingAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
