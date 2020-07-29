import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/order_status_icon.dart';
import '../widgets/order_chart.dart';

import '../providers/orders.dart';

class OrdersRecent extends StatefulWidget {
  @override
  _OrdersRecentState createState() => _OrdersRecentState();
}

class _OrdersRecentState extends State<OrdersRecent> {
  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Orders>(context, listen: false).items;

    var orderMap = orderData.map((order) => {
          'id': order.id,
          'displayId': order.displayId,
          'userMail': order.userMail,
          'userName': order.userName,
          'userMobile': order.userMobile,
          'orderItems': order.orderItems,
          'orderValue': order.orderValue,
          'orderStatus': order.orderStatus,
          'createDt': order.createDt,
          'updateDt': order.updateDt,
          'orderDt': DateFormat.yMd().format(order.createDt),
        });
    var groupedOrders = groupBy(orderMap, (obj) => obj['orderDt']);

    List<Widget> orderWidget = [];

    groupedOrders.forEach((key, value) {
      final dayOrders = groupedOrders[key];
      orderWidget.add(ExpansionTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(key),
        children: <Widget>[
          ...dayOrders
              .map((e) => Column(
                    children: <Widget>[
                      Card(
                        elevation: 10,
                        child: ListTile(
                          leading: OrderStatusIcon(e['orderStatus']),
                          title: Text(e['displayId']),
                        ),
                      ),
                      const Divider(),
                    ],
                  ))
              .toList()
        ],
      ));
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Card(
                child: OrderChart(),
                elevation: 20,
              ),
            ),
            const Divider(),
            ...orderWidget
          ],
        ),
      ),
    );
  }
}
