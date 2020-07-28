import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/categories.dart';

import '../screens/product_add_screen.dart';

import '../models/product.dart';

import '../widgets/app_drawer.dart';
import '../widgets/categories_scroller.dart';
import '../widgets/product_card.dart';
import '../widgets/product_item.dart';

class ProductOverViewScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _isInit = true;
  var _categories;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  var _selctedCategory = -1;

  List<Product> selectedProducts = [];
  List<Widget> productWidgetList = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<void> getCategories() async {
    await Provider.of<Categories>(context, listen: false)
        .setAndFetchCategories();
    var categories = Provider.of<Categories>(context, listen: false).items;
    _categories = [...categories];
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      var categories = Provider.of<Categories>(context, listen: false).items;
      if (categories.length == 0) {
        getCategories();
      } else {
        _categories = [...categories];
      }
    }
    _isInit = false;
  }

  void selectedCategory(catId) {
    this.setState(() {
      _selctedCategory = catId;
    });
  }

  List<Widget> getProductWidgets(List<Product> prodList) {
    List<Widget> listItems = [];
    prodList.forEach((prod) {
      listItems.add(ProductCard(prod));
    });

    return listItems;
  }

  Future<void> _refreshProducts(BuildContext context) {
    return this._memoizer.runOnce(() async {
      await Provider.of<Products>(context, listen: false).setAndFetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirana Store'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () =>
                  Navigator.of(context).pushNamed(ProductAddScreen.routeName))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (ctx, productData, _) {
                      var prods = productData.items;
                      var categoryToFetch = _selctedCategory == -1
                          ? _categories[0].id
                          : _selctedCategory;
                      var prodWidget = getProductWidgets(
                        prods
                            .where((pd) => pd.categoryId == categoryToFetch)
                            .toList(),
                      );
                      return Container(
                        height: size.height,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            CategoriesScroller(selectedCategory),
                            Divider(
                              thickness: 3,
                              color: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                              child: prodWidget.length == 0
                                  ? Center(
                                      child: Image.asset(
                                        'assets/images/no_products_found.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ListView.builder(
                                      cacheExtent: closeTopContainer
                                          ? 0
                                          : categoryHeight * prodWidget.length,
                                      addAutomaticKeepAlives: true,
                                      controller: controller,
                                      itemCount: prodWidget.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        double scale = 1.0;
                                        if (topContainer > 0.5) {
                                          scale = index + 0.5 - topContainer;
                                          if (scale < 0) {
                                            scale = 0;
                                          } else if (scale > 1) {
                                            scale = 1;
                                          }
                                        }
                                        return ProductItem(
                                          scale,
                                          index,
                                          prodWidget[index],
                                          productData.items[index].id,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
