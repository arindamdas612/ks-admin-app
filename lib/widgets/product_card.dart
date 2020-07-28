import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product _product;
  final _titleController = TextEditingController();

  ProductCard(this._product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => Provider.of<Products>(context, listen: false)
          .changeStatus(_product.id, !_product.isActive),
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailScreen.routeName,
        arguments: _product.id,
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Update Title'),
            content: TextField(
              controller: _titleController,
              decoration: InputDecoration(icon: Icon(Icons.title)),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'Cancel',
                ),
              ),
              FlatButton(
                onPressed: () {
                  String newTitle = _titleController.text;
                  if (newTitle.isNotEmpty)
                    Provider.of<Products>(context, listen: false)
                        .updateTitle(_product.id, newTitle);
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Update',
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: _product.isActive ? Colors.white : Colors.white70,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ],
        ),
        child: ListTile(
          leading: Hero(
            tag: _product.id,
            child: FadeInImage(
              placeholder: AssetImage(
                'assets/images/image_place_holder.png',
              ),
              image: _product.productImages.length == 0
                  ? AssetImage(
                      'assets/images/image_place_holder.png',
                    )
                  : NetworkImage(
                      _product.productImages[0],
                    ),
            ),
          ),
          title: Text(
            _product.title,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            '${_product.qty} Left',
            style: TextStyle(
              fontSize: 12,
              color: _product.qty < 5 ? Colors.red : Colors.green,
            ),
          ),
          trailing: Text(
            '₹ ${_product.markedPrice.toStringAsFixed(2)}',
          ),
        ),
      ),
    );
  }
}
