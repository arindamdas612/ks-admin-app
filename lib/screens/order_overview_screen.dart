import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:ks_admin/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../widgets/app_drawer.dart';
import '../widgets/orders_recent.dart';

class OrdersOverViewScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrdersOverViewScreenState createState() => _OrdersOverViewScreenState();
}

class _OrdersOverViewScreenState extends State<OrdersOverViewScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<void> _refreshOrders(BuildContext context, bool userRequest) async =>
      userRequest
          ? await Provider.of<Orders>(context, listen: false)
              .setAndFetchOrders()
          : this._memoizer.runOnce(() async =>
              await Provider.of<Orders>(context, listen: false)
                  .setAndFetchOrders());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Recieved'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cached),
            onPressed: () async {
              try {
                await _refreshOrders(context, true);
                Toast.show("Orders refreshed!!!", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              } catch (error) {
                Toast.show("Order refresh failed!!!", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              }
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshOrders(context, false),
        builder: (_, snapShot) {
          return snapShot.connectionState == ConnectionState.waiting
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : OrdersRecent();
        },
      ),
    );
  }
}
