// ignore_for_file: unused_import

import 'package:expense_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        var sumTotal = 0.0;
        for (var i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            sumTotal += recentTransactions[i].amount;
          }
        }
        print(DateFormat.E().format(weekDay));
        print(sumTotal);
        return {
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': sumTotal,
        };
      },
    ).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValue);
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map(
            (data) {
              return Flexible(
                fit:FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending==0 ? 0.0:(data['amount'] as double) / totalSpending,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
