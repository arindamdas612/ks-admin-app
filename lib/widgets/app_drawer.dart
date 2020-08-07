import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/home_screen.dart';
import '../screens/category_overview_screen.dart';
import '../screens/product_overview_screen.dart';
import '../screens/order_overview_screen.dart';
import '../screens/user_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<Auth>(context).name;
    var curRoute = ModalRoute.of(context).settings.name;
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text(
            'Hello $name',
          ),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          selected: curRoute == HomeScreen.routeName,
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName),
        ),
        const Divider(),
        ListTile(
          selected: curRoute == UserOverViewScreen.routeName,
          leading: const Icon(Icons.people),
          title: const Text('Users'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(UserOverViewScreen.routeName),
        ),
        const Divider(),
        ListTile(
          selected: curRoute == OrdersOverViewScreen.routeName,
          leading: const Icon(Icons.flash_auto),
          title: const Text('Orders'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(OrdersOverViewScreen.routeName),
        ),
        const Divider(),
        ListTile(
          selected: curRoute == CategoryOverviewScreen.routeName,
          leading: const Icon(Icons.category),
          title: const Text('Categories'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(CategoryOverviewScreen.routeName),
        ),
        const Divider(),
        ListTile(
          selected: curRoute == ProductOverViewScreen.routeName,
          leading: const Icon(Icons.fastfood),
          title: const Text('Products'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(ProductOverViewScreen.routeName),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    ));
  }
}
