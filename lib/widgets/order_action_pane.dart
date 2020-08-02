import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

import '../widgets/order_action_button.dart';

class OrderActionPane extends StatelessWidget {
  final List<Widget> noActionWidget = [
    Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
    Container(
      alignment: Alignment.center,
      child: Center(
        child: const Text(
          'Order Complete! Actions Unavailable',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    )
  ];

  final orderId;

  OrderActionPane({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context).findById(orderId);
    List<Widget> actionWidget = order.orderActions
        .map((action) => OrderActionButton(action, order.id))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 30,
              color: Theme.of(context).accentColor.withAlpha(200))
        ],
      ),
      child: Card(
        child: actionWidget.length == 0
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: noActionWidget),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          actionWidget[0],
                          if (actionWidget.length >= 4)
                            SizedBox(
                              height: 20,
                            ),
                          if (actionWidget.length >= 4) actionWidget[2],
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          if (actionWidget.length >= 2) actionWidget[1],
                          if (actionWidget.length == 4)
                            SizedBox(
                              height: 20,
                            ),
                          if (actionWidget.length == 4) actionWidget[3]
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
