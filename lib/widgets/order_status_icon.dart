import 'package:flutter/material.dart';
import '../helpers/get_order_status_maps.dart';

class OrderStatusIcon extends StatelessWidget {
  final String status;

  OrderStatusIcon(this.status);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Icon(
        OrderStatusHelper().getStatusIcon(status),
        color: OrderStatusHelper().getStatusColor(status),
      ),
      backgroundColor: Colors.black45,
    );
  }
}
