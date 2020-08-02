import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../models/http_exception.dart';

class Orders with ChangeNotifier {
  String _authToken;
  List<Order> _items;

  Orders(
    this._authToken,
    this._items,
  );

  List<Order> updatedOrders(allOrders) {
    List<Order> loadedOrders = [];
    allOrders.forEach((order) {
      List orderItems = order['order_items']
          .map((item) => {
                'id': item['id'],
                'productTitle': item['product_title'],
                'qty': item['qty'],
                'unitPrice': item['unit_price'],
                'status': item['status'],
                'totalPrice': item['total_price'],
                'imageUrl': item['image_URL']
              })
          .toList();
      List orderActivites = order['order_activity']
          .map((activity) => {
                'id': activity['id'],
                'prevStatus': activity['prev_status'],
                'nextStatus': activity['next_status'],
                'activityDate':
                    DateTime.parse(activity['activity_dt']).toLocal(),
                'userName': activity['user'],
                'isAdmin': activity['is_admin'],
              })
          .toList();
      DateTime createDt = DateTime.parse(order['created_on']).toLocal();
      loadedOrders.add(
        Order(
            id: order['id'],
            displayId: order['display_id'],
            userMail: order['user_email'],
            userName: order['user_name'],
            userMobile: order['user_mobile'],
            orderItems: [...orderItems],
            orderActivities: [...orderActivites],
            orderValue: order['order_value'],
            orderStatus: order['status'],
            createDt: createDt,
            updateDt: DateTime.parse(order['update_on']).toLocal(),
            orderDt: DateFormat('dd-MM-yyyy').format(createDt),
            orderActions: [...order['available_actions']]),
      );
    });
    return loadedOrders;
  }

  Order upatedOrder(orderData) {
    List orderItems = orderData['order_items']
        .map((item) => {
              'id': item['id'],
              'productTitle': item['product_title'],
              'qty': item['qty'],
              'unitPrice': item['unit_price'],
              'status': item['status'],
              'totalPrice': item['total_price'],
              'imageUrl': item['image_URL']
            })
        .toList();
    List orderActivites = orderData['order_activity']
        .map((activity) => {
              'id': activity['id'],
              'prevStatus': activity['prev_status'],
              'nextStatus': activity['next_status'],
              'activityDate': DateTime.parse(activity['activity_dt']).toLocal(),
              'userName': activity['user'],
              'isAdmin': activity['is_admin'],
            })
        .toList();
    DateTime createDt = DateTime.parse(orderData['created_on']).toLocal();
    Order loadedOrder = Order(
        id: orderData['id'],
        displayId: orderData['display_id'],
        userMail: orderData['user_email'],
        userName: orderData['user_name'],
        userMobile: orderData['user_mobile'],
        orderItems: [...orderItems],
        orderActivities: [...orderActivites],
        orderValue: orderData['order_value'],
        orderStatus: orderData['status'],
        createDt: createDt,
        updateDt: DateTime.parse(orderData['update_on']).toLocal(),
        orderDt: DateFormat('dd-MM-yyyy').format(createDt),
        orderActions: [...orderData['available_actions']]);
    return loadedOrder;
  }

  List<Order> get items {
    return [..._items];
  }

  Order findById(int orderId) =>
      _items.firstWhere((order) => order.id == orderId);

  int statusCount(String orderStautus) => _items.fold(
      0,
      (totalCount, order) =>
          order.orderStatus == orderStautus ? totalCount + 1 : totalCount);

  int dayCount(String orderDate) => _items.fold(
      0,
      (totalCount, order) =>
          order.orderDt == orderDate ? totalCount + 1 : totalCount);

  double dayAmount(String orderDate) => _items.fold(
      0.0,
      (totalCount, order) => order.orderDt == orderDate
          ? totalCount + order.orderValue
          : totalCount);

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
        List<Order> loadedOrders = updatedOrders(orders);
        _items = [...loadedOrders];
        notifyListeners();
      } else {
        throw HttpException(extractedData['details']);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> changeItemStatus(int orderItemId, bool noStock) async {
    var nextStatus = noStock ? 'Ordered' : 'No Stock';
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/3/order/';
    try {
      final response = await http.put(
        url,
        headers: requestHeader,
        body: json.encode(
          {
            'id': orderItemId,
            'nextStatus': nextStatus,
          },
        ),
      );
      var extractedData = json.decode(response.body);
      if ((extractedData['message_code'] == 1) ||
          (extractedData['message_code'] == 2)) {
        throw HttpException(extractedData['message']);
      } else {
        var orderId = extractedData['order_id'];
        int orderIndex = _items.indexWhere((order) => order.id == orderId);
        Order updatedOrder = upatedOrder(extractedData['updated_order_data']);
        _items.removeAt(orderIndex);
        _items.insert(orderIndex, updatedOrder);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> changeStatus(int orderId, String nextAction) async {
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/3/order/';
    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: json.encode(
          {
            'id': orderId,
            'status': nextAction,
          },
        ),
      );
      var extractedData = json.decode(response.body);
      if ((extractedData['message_code'] == 1) ||
          (extractedData['message_code'] == 2)) {
        throw HttpException(extractedData['message']);
      } else {
        int orderIndex = _items.indexWhere((order) => order.id == orderId);
        Order updatedOrder = upatedOrder(extractedData['updated_order_data']);
        _items.removeAt(orderIndex);
        _items.insert(orderIndex, updatedOrder);
        notifyListeners();
        return extractedData['message'];
      }
    } catch (error) {
      throw error;
    }
  }
}
