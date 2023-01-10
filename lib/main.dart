// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:expense_tracker/widgets/user_transactions.dart';
import 'package:flutter/material.dart';
import './models/transactions.dart';
import './widgets/new_transactions.dart';
import './widgets/transactions_list.dart';
import './widgets/chart.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> userTransactions = [];

  List<Transactions> get recentTransactions {
    return userTransactions.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void addNewTransactions(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transactions(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
    );

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void deleteTransactions(String id) {
    setState(() {
      userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(addNewTransactions);
      },
    );
  }

  bool showChart = false;

  List<Widget> buildLandScape(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
            value: showChart,
            onChanged: (val) {
              setState(
                () {
                  showChart = val;
                },
              );
            },
          )
        ],
      ),
      showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6,
              child: Chart(recentTransactions),
            )
          : txList
    ];
  }

  List<Widget> buildPotrait(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(recentTransactions),
      ),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      elevation: 3,
      title: Text(
        'Personal Expenses',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          color: Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            startAddNewTransaction(context);
          },
        ),
      ],
    );
    final txList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionsList(userTransactions, deleteTransactions),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              ...buildLandScape(
                mediaQuery,
                appBar,
                txList,
              ),
            if (!isLandscape)
              ...buildPotrait(
                mediaQuery,
                appBar,
                txList,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_library_add),
        onPressed: () {
          startAddNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
