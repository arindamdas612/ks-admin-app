import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/timeline.dart';

import '../providers/orders.dart';

import '../helpers/get_order_status_maps.dart';

class OrderTimeLineScreen extends StatelessWidget {
  static const routeName = '/order-timeline';

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments as int;
    return Consumer<Orders>(
      builder: (context, orderData, _) {
        List<Map<String, dynamic>> orderActivites =
            orderData.findById(id).orderActivities;
        return Scaffold(
          appBar: AppBar(
            title: Text('Order Timeline'),
          ),
          body: Timeline(
            children: <Widget>[
              ...orderActivites
                  .map((orderActivity) => Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: OrderStatusHelper()
                                .getStatusColor(orderActivity['nextStatus'])
                                .withAlpha(100),
                            blurRadius: 25,
                          )
                        ]),
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              orderActivity['nextStatus'],
                              style: TextStyle(
                                color: OrderStatusHelper().getStatusColor(
                                    orderActivity['nextStatus']),
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('yyyy/MM/dd – HH:mm').format(
                                orderActivity['activityDate'],
                              ),
                            ),
                            trailing: Text(
                              orderActivity['userName'],
                              style: TextStyle(
                                color: orderActivity['isAdmin']
                                    ? Theme.of(context).accentColor
                                    : Colors.blueGrey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList()
            ],
            indicators: <Widget>[
              ...orderActivites
                  .map(
                    (orderActivity) => Icon(
                      OrderStatusHelper()
                          .getStatusIcon(orderActivity['nextStatus']),
                      color: OrderStatusHelper()
                          .getStatusColor(orderActivity['nextStatus']),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
