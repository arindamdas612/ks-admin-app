import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_status_icon.dart';
import '../widgets/order_chart.dart';
import '../widgets/status_count_icon.dart';

import '../providers/orders.dart';

import '../screens/order_detail_screen.dart';

class OrdersRecent extends StatefulWidget {
  @override
  _OrdersRecentState createState() => _OrdersRecentState();
}

class _OrdersRecentState extends State<OrdersRecent> {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).items;

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
          'orderDt': order.orderDt,
        });
    var groupedOrders = groupBy(orderMap, (obj) => obj['orderDt']);

    List<Widget> orderWidget = [];

    groupedOrders.forEach((key, value) {
      final dayOrders = groupedOrders[key];
      orderWidget.add(Card(
        elevation: 6,
        color: Colors.black12,
        child: ExpansionTile(
          leading: StatusCountIcon(
            Provider.of<Orders>(context, listen: false).dayCount(key),
          ),
          title: Text(key),
          subtitle: Text(
              '₹ ${Provider.of<Orders>(context, listen: false).dayAmount(key)}'),
          children: <Widget>[
            ...dayOrders
                .map((e) => Column(
                      children: <Widget>[
                        InkWell(
                          splashColor: Theme.of(context).accentColor,
                          onTap: () => Navigator.of(context).pushNamed(
                            OrderDetailScreen.routeName,
                            arguments: e['id'],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                leading: OrderStatusIcon(e['orderStatus']),
                                title: Text(e['displayId']),
                                subtitle: Text(e['userMail']),
                                trailing:
                                    Text('₹ ${e['orderValue'].toString()}'),
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ))
                .toList()
          ],
        ),
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
