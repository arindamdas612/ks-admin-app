import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

import './order_status_icon.dart';

class OrderChart extends StatefulWidget {
  static const orderStatusList = [
    'Placed',
    'Acknowledged',
    'Ready',
    'In Transit',
    'Delivered',
    'Returned',
    'Partially Returned',
    'Dismissed',
  ];

  @override
  _OrderChartState createState() => _OrderChartState();
}

class _OrderChartState extends State<OrderChart> {
  Widget orderCountWidget(String statusName, BuildContext context, int count) =>
      Container(
        width: MediaQuery.of(context).size.width * 0.25,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(width: 1, color: Theme.of(context).accentColor),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            OrderStatusIcon(statusName),
            Text(count.toString(), style: TextStyle(fontSize: 15)),
            Text(
              statusName,
              style: TextStyle(fontSize: 8),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (context, orderData, child) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            orderCountWidget(
              OrderChart.orderStatusList[0],
              context,
              orderData.statusCount(OrderChart.orderStatusList[0]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                orderCountWidget(
                  OrderChart.orderStatusList[6],
                  context,
                  orderData.statusCount(OrderChart.orderStatusList[6]),
                ),
                orderCountWidget(
                  OrderChart.orderStatusList[5],
                  context,
                  orderData.statusCount(OrderChart.orderStatusList[5]),
                ),
                orderCountWidget(
                  OrderChart.orderStatusList[1],
                  context,
                  orderData.statusCount(OrderChart.orderStatusList[1]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                orderCountWidget(
                  OrderChart.orderStatusList[7],
                  context,
                  orderData.statusCount(OrderChart.orderStatusList[7]),
                ),
                orderCountWidget(
                  OrderChart.orderStatusList[2],
                  context,
                  orderData.statusCount(OrderChart.orderStatusList[2]),
                ),
              ],
            ),
            orderCountWidget(
              OrderChart.orderStatusList[3],
              context,
              orderData.statusCount(OrderChart.orderStatusList[3]),
            ),
            orderCountWidget(
              OrderChart.orderStatusList[4],
              context,
              orderData.statusCount(OrderChart.orderStatusList[4]),
            ),
          ],
        ),
      ),
    );
  }
}
