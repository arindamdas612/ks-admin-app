import 'package:flutter/material.dart';

class Product {
  int id;
  final String title;
  final int categoryId;
  final int qty;
  final double markedPrice;
  final bool isActive;
  final List<Map<String, String>> productSpecs;
  List<dynamic> productImages;

  Product({
    @required this.id,
    @required this.title,
    @required this.categoryId,
    @required this.qty,
    @required this.markedPrice,
    @required this.isActive,
    @required this.productSpecs,
    @required this.productImages,
  });
}
