import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_card.dart';

import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  final double scale;
  final ProductCard productWidget;
  final int index;
  final int id;

  ProductItem(
    this.scale,
    this.index,
    this.productWidget,
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        height: 120,
        alignment: Alignment.centerLeft,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: null,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withAlpha(100),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) async {
        try {
          await Provider.of<Products>(context, listen: false).deleteProduct(id);
        } catch (error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Error occured'),
            ),
          );
        }
      },
      confirmDismiss: (_) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Remove Product'),
          content: Text(
              'This action will remove the product permanently. Continue?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
      key: ValueKey(id),
      child: Opacity(
        opacity: scale,
        child: Transform(
          transform: Matrix4.identity()..scale(scale, scale),
          alignment: Alignment.bottomCenter,
          child: Align(
              heightFactor: 0.7,
              alignment: Alignment.topCenter,
              child: productWidget),
        ),
      ),
    );
  }
}
