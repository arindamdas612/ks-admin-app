import 'package:flutter/material.dart';

class OrderStatusIcon extends StatelessWidget {
  final String status;

  OrderStatusIcon(this.status);

  @override
  Widget build(BuildContext context) {
    CircleAvatar icon;
    switch (status) {
      case 'Placed':
        icon = CircleAvatar(
          child: Icon(
            Icons.new_releases,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.blue,
        );
        break;
      case 'Acknowledged':
        icon = CircleAvatar(
          child: Icon(
            Icons.wb_incandescent,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.orangeAccent,
        );
        break;
      case 'Ready':
        icon = CircleAvatar(
          child: Icon(
            Icons.card_giftcard,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.yellowAccent,
        );
        break;
      case 'In Transit':
        icon = CircleAvatar(
          child: Icon(
            Icons.directions_bike,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.lightGreenAccent,
        );
        break;
      case 'Delivered':
        icon = CircleAvatar(
          child: Icon(
            Icons.done_outline,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.teal,
        );
        break;
      case 'Returned':
        icon = CircleAvatar(
          child: Icon(
            Icons.reply_all,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.blueGrey,
        );
        break;
      case 'No Stock (P)':
        icon = CircleAvatar(
          child: Icon(
            Icons.reply,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.lightBlueAccent,
        );
        break;
      case 'No Stock':
        icon = CircleAvatar(
          child: Icon(
            Icons.remove_circle,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.brown,
        );
        break;
      case 'Dismissed':
        icon = CircleAvatar(
          child: Icon(
            Icons.do_not_disturb_alt,
            color: Color(0xFF333131),
          ),
          backgroundColor: Colors.redAccent,
        );
        break;
      default:
        icon = CircleAvatar(
          child: Icon(
            Icons.account_balance_wallet,
            color: Colors.black12,
          ),
          backgroundColor: Colors.black,
        );
    }
    return icon;
  }
}
