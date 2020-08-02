import 'package:flutter/material.dart';

class OrderStatusChip extends StatelessWidget {
  final String itemStatus;

  OrderStatusChip({this.itemStatus});

  Color _statusColor;
  Color _statusText;
  IconData _statusIcon;

  @override
  Widget build(BuildContext context) {
    switch (itemStatus) {
      case 'In Cart':
        _statusColor = Colors.blue;
        _statusText = Colors.white;
        _statusIcon = Icons.shopping_cart;
        break;
      case 'Wishlisted':
        _statusColor = Colors.amber;
        _statusText = Colors.black;
        _statusIcon = Icons.star;
        break;
      case 'No Stock':
        _statusColor = Colors.red;
        _statusText = Colors.black;
        _statusIcon = Icons.warning;
        break;
      case 'Ordered':
        _statusColor = Colors.limeAccent;
        _statusText = Colors.black;
        _statusIcon = Icons.trip_origin;
        break;
      case 'Delivered':
        _statusColor = Colors.lightGreen;
        _statusText = Colors.black;
        _statusIcon = Icons.check_box;
        break;
      case 'Cancelled':
        _statusColor = Colors.grey;
        _statusText = Colors.black;
        _statusIcon = Icons.remove_circle_outline;
        break;
      case 'In Process':
        _statusColor = Colors.deepPurple;
        _statusText = Colors.black;
        _statusIcon = Icons.group_work;
        break;
      default:
        _statusColor = Colors.grey;
        _statusText = Colors.black;
        _statusIcon = Icons.dehaze;
    }

    return Chip(
      backgroundColor: _statusColor,
      avatar: Icon(
        _statusIcon,
        color: Theme.of(context).primaryColor,
      ),
      label: Text(
        itemStatus,
        style: TextStyle(color: _statusText, fontWeight: FontWeight.bold),
      ),
    );
  }
}
