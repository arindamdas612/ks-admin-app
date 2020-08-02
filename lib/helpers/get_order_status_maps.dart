import 'package:flutter/material.dart';

class OrderStatusHelper {
  IconData icon;
  Color color;
  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Placed':
        icon = Icons.new_releases;
        break;
      case 'Acknowledged':
        icon = Icons.wb_incandescent;
        break;
      case 'Ready':
        icon = Icons.card_giftcard;
        break;
      case 'In Transit':
        icon = Icons.directions_bike;
        break;
      case 'Delivered':
        icon = Icons.done_outline;
        break;
      case 'Returned':
        icon = Icons.reply_all;
        break;
      case 'No Stock (P)':
        icon = Icons.reply;
        break;
      case 'No Stock':
        icon = Icons.remove_circle;
        break;
      case 'Dismissed':
        icon = Icons.do_not_disturb_alt;
        break;
      default:
        icon = Icons.account_balance_wallet;
    }
    return icon;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Placed':
        color = Colors.blue;
        break;
      case 'Acknowledged':
        color = Colors.orangeAccent;
        break;
      case 'Ready':
        color = Colors.yellowAccent;
        break;
      case 'In Transit':
        color = Colors.lightGreenAccent;
        break;
      case 'Delivered':
        color = Colors.teal;
        break;
      case 'Returned':
        color = Colors.blueGrey;
        break;
      case 'No Stock (P)':
        color = Colors.lightBlueAccent;
        break;
      case 'No Stock':
        color = Colors.brown;
        break;
      case 'Dismissed':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
    }
    return color;
  }
}
