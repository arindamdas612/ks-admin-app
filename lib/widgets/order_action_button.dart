import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../widgets/order_status_icon.dart';

import '../providers/orders.dart';

import '../models/http_exception.dart';

class OrderActionButton extends StatelessWidget {
  final action;
  final orderId;

  final Map<String, dynamic> actionColors = {
    'Placed': Colors.blue,
    'Acknowledged': Colors.orangeAccent,
    'Ready': Colors.yellowAccent,
    'In Transit': Colors.greenAccent,
    'Delivered': Colors.teal,
    'Returned': Colors.blueGrey,
    'No Stock (P)': Colors.lightBlueAccent,
    'No Stock': Colors.brown,
    'Dismissed': Colors.red
  };

  OrderActionButton(this.action, this.orderId);

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF333131),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: actionColors[action].withAlpha(200),
          )
        ],
      ),
      child: FlatButton.icon(
        icon: OrderStatusIcon(action),
        onPressed: () async {
          try {
            final responseMessage =
                await Provider.of<Orders>(context, listen: false)
                    .changeStatus(orderId, action);
            Toast.show(responseMessage, context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } on HttpException catch (error) {
            _showErrorDialog(error.toString(), context);
          } catch (error) {
            _showErrorDialog('Error occured. Try Again', context);
          }
        },
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(action),
        ),
      ),
    );
  }
}
