import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/products.dart';

class CategoriesScroller extends StatelessWidget {
  final Function changeProducts;

  CategoriesScroller(this.changeProducts);

  String getProductCountById(categoryId, products) {
    var pd = products.where((prod) => prod.categoryId == categoryId).toList();
    return pd.length == 0
        ? 'No Products'
        : pd.length == 1 ? '1 Product' : '${pd.length} Products';
  }

  Widget build(BuildContext context) {
    var categories = Provider.of<Categories>(context, listen: false).items;
    var products = Provider.of<Products>(context, listen: false).items;
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 75;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              ...categories.map((category) {
                return GestureDetector(
                  onTap: () => changeProducts(category.id, products),
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.green]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            category.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            getProductCountById(category.id, products),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }
}
