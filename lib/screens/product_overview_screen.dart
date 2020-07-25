import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class ProductOverViewScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kirana Store'),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Text('Products'),
        ));
  }
}
