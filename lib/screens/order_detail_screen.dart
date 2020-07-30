import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/orders';
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var orderId = ModalRoute.of(context).settings.arguments;
    Order order = Provider.of<Orders>(context, listen: false).findById(orderId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.displayId,
        ),
      ),
      body: Container(
        child: Center(
          child: Text(order.orderStatus),
        ),
      ),
    );
  }
}
