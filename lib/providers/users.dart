import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ks_admin/models/http_exception.dart';

import '../models/user.dart';

class Users with ChangeNotifier {
  String _authToken;
  int _authId;
  List<User> _users = [];

  Users(
    this._authToken,
    this._authId,
    this._users,
  );

  List<User> get users => _users.where((user) => user.id != _authId).toList();

  User userById(int userId) => _users.firstWhere((user) => user.id == userId);

  List<User> get appUsers => _users.where((user) => !user.isAdmin).toList();

  List<User> get adminUsers => _users.where((user) => user.isAdmin).toList();

  Future<void> setAndFetchUsers() async {
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/1/all-users/';
    try {
      final response = await http.get(url, headers: requestHeader);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        throw HttpException('No response from Server');
      }
      if (extractedData['message_code'] != 0) {
        throw HttpException(extractedData['message']);
      } else {
        List<User> loadedUsers = [];

        extractedData['users'].forEach((user) {
          List cartItems = [];
          List wishListedItems = [];
          cartItems = user['cart_items']
              .map((item) => {
                    'id': item['id'] as int,
                    'productTitle': item['product_title'],
                    'qty': item['qty'],
                    'unitPrice': item['unit_price'],
                    'status': item['status'],
                    'totalPrice': item['total_price'],
                    'imageUrl': item['image_URL']
                  })
              .toList();
          wishListedItems = user['wishlisted_items']
              .map((item) => {
                    'id': item['id'] as int,
                    'productTitle': item['product_title'],
                    'qty': item['qty'],
                    'unitPrice': item['unit_price'],
                    'status': item['status'],
                    'totalPrice': item['total_price'],
                    'imageUrl': item['image_URL']
                  })
              .toList();
          loadedUsers.add(
            User(
                id: user['id'] as int,
                name: user['name'],
                email: user['email'],
                mobile: user['mobile'],
                isActive: user['is_active'],
                isAdmin: user['is_admin'],
                orders: user['orders'] != null ? [...user['orders']] : [],
                cartItems: [...cartItems],
                wishListed: [...wishListedItems]),
          );
          _users = [...loadedUsers];
          notifyListeners();
        });
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<String> changeStatus(int userId) async {
    User userToUpdate = userById(userId);
    int toUpdateIndex = _users.indexWhere((user) => user.id == userId);
    User updatedUser = User(
      id: userToUpdate.id,
      name: userToUpdate.name,
      email: userToUpdate.email,
      mobile: userToUpdate.mobile,
      isActive: !userToUpdate.isActive,
      isAdmin: userToUpdate.isAdmin,
      orders: [...userToUpdate.orders],
      cartItems: [...userToUpdate.cartItems],
      wishListed: [...userToUpdate.wishListed],
    );
    _users.removeAt(toUpdateIndex);
    _users.insert(toUpdateIndex, updatedUser);
    notifyListeners();
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/1/all-users/';

    try {
      final response = await http.put(
        url,
        headers: requestHeader,
        body: json.encode(
          {
            'actionType': 'STATUS',
            'userId': userId,
          },
        ),
      );
      final extractedData = json.decode(response.body);
      if (extractedData['message_code'] != 0) {
        _users.removeAt(toUpdateIndex);
        _users.insert(toUpdateIndex, userToUpdate);
        notifyListeners();
        throw HttpException(extractedData['message']);
      } else {
        return extractedData['message'];
      }
    } catch (error) {
      _users.removeAt(toUpdateIndex);
      _users.insert(toUpdateIndex, userToUpdate);
      notifyListeners();
      throw error;
    }
  }
}
