import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final bool isActive;
  final bool isAdmin;
  final List<int> orders;
  final List<Map<String, dynamic>> cartItems;
  final List<Map<String, dynamic>> wishListed;

  User(
      {@required this.id,
      @required this.name,
      @required this.email,
      @required this.mobile,
      @required this.isActive,
      @required this.isAdmin,
      @required this.orders,
      @required this.cartItems,
      @required this.wishListed});
}
