import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Text(
                  DateFormat('yyyy-MM-dd – HH:mm:ss').format(order.createDt),
                  style: TextStyle(fontSize: 20, fontFamily: 'PTSans'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(
                      color: order.orderValue > 0
                          ? Theme.of(context).accentColor
                          : Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage(
                          order.orderValue > 0
                              ? 'assets/images/rupee-symbol-file.png'
                              : 'assets/images/rupee-symbol-file-red.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      order.orderValue.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'PTSans',
                          color:
                              order.orderValue > 0 ? Colors.white : Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
