// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, annotate_overrides, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  final List<Transactions> transaction;
  final Function deleteTransactions;
  TransactionsList(this.transaction, this.deleteTransactions);

  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: transaction.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/image/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  elevation: 20,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('₹ ${transaction[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transaction[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(transaction[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            icon: Icon(Icons.delete),
                            label: Text('Delete'),
                            // textColor: Theme.of(context).errorColor,
                            onPressed: () =>
                                deleteTransactions(transaction[index].id),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () =>
                                deleteTransactions(transaction[index].id),
                          ),
                  ),
                );
              },
              itemCount: transaction.length,
            ),
    );
  }
}
