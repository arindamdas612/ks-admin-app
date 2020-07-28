import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/product_card.dart';

class ProductItem extends StatelessWidget {
  final double scale;
  final ProductCard productWidget;
  final int index;
  final int id;

  ProductItem(this.scale, this.index, this.productWidget, this.id);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: scale,
      child: Transform(
        transform: Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.bottomCenter,
        child: Align(
            heightFactor: 0.7,
            alignment: Alignment.topCenter,
            child: productWidget),
      ),
    );
  }
}
