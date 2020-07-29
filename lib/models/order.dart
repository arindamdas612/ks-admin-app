import 'package:flutter/cupertino.dart';

class Order {
  final int id;
  final String displayId;
  final String userMail;
  final String userName;
  final String userMobile;
  final List<Map<String, dynamic>> orderItems;
  final double orderValue;
  final String orderStatus;
  final DateTime createDt;
  final DateTime updateDt;
  final String orderDt;

  Order({
    @required this.id,
    @required this.displayId,
    @required this.userMail,
    @required this.userName,
    @required this.userMobile,
    @required this.orderItems,
    @required this.orderValue,
    @required this.orderStatus,
    @required this.createDt,
    @required this.updateDt,
    @required this.orderDt,
  });
}
