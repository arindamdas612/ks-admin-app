import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';

import '../providers/orders.dart';

import '../screens/order_timeline_screen.dart';

import '../widgets/order_status_icon.dart';
import '../widgets/order_header.dart';
import '../widgets/order_action_pane.dart';
import '../widgets/order_item_card.dart';

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
    return Consumer<Orders>(
      builder: (ctx, orderData, _) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              OrderStatusIcon(orderData.findById(orderId).orderStatus),
              SizedBox(
                width: 20,
              ),
              Text(
                order.displayId,
              ),
            ],
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: CircleAvatar(
            child: Icon(Icons.timeline),
          ),
          mini: true,
          onPressed: () => Navigator.of(context)
              .pushNamed(OrderTimeLineScreen.routeName, arguments: order.id),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              OrderHeader(
                order: orderData.findById(order.id),
              ),
              Divider(),
              OrderActionPane(
                orderId: orderData.findById(order.id).id,
              ),
              Divider(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView.builder(
                    itemBuilder: (context, index) => OrderItemCard(
                        orderItem:
                            orderData.findById(order.id).orderItems[index]),
                    itemCount: orderData.findById(order.id).orderItems.length,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
