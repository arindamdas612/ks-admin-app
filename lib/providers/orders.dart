import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/http_exception.dart';

class Orders with ChangeNotifier {
  String _authToken;
  List<Order> _items;

  Orders(
    this._authToken,
    this._items,
  );

  List<Order> get items {
    return [..._items];
  }

  int statusTotal(String orderStautus) {
    return _items.fold(
        0,
        (count, order) =>
            order.orderStatus == orderStautus ? count + 1 : count);
  }

  Future<void> setAndFetchOrders() async {
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/3/order/';
    try {
      final response = await http.get(url, headers: requestHeader);
      final extractedData = json.decode(response.body);
      if (extractedData['message_code'] > 0) {
        List<dynamic> orders = extractedData['orders'];
        List<Order> loadedOrders = [];
        orders.forEach((order) {
          List orderItems = order['order_items']
              .map((item) => {
                    'id': item['id'],
                    'productTile': item['product_title'],
                    'qty': item['qty'],
                    'unitPrice': item['unit_price'],
                    'status': item['status'],
                    'totalPrice': item['total_price']
                  })
              .toList();
          loadedOrders.add(
            Order(
              id: order['id'],
              displayId: order['display_id'],
              userMail: order['user_email'],
              userName: order['user_name'],
              userMobile: order['user_mobile'],
              orderItems: [...orderItems],
              orderValue: order['order_value'],
              orderStatus: order['status'],
              createDt: DateTime.parse(order['created_on']),
              updateDt: DateTime.parse(order['update_on']),
              orderDt: order['order_dt'],
            ),
          );
        });
        _items = [...loadedOrders];
        notifyListeners();
      } else {
        throw HttpException(extractedData['details']);
      }
    } catch (error) {
      throw (error);
    }
  }
}
