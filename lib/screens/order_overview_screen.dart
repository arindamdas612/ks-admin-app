import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:ks_admin/providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/orders_recent.dart';
import '../widgets/orders_by_user.dart';

class OrdersOverViewScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrdersOverViewScreenState createState() => _OrdersOverViewScreenState();
}

class _OrdersOverViewScreenState extends State<OrdersOverViewScreen> {
  int _currentIndex = 0;
  final _orderNavs = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: const Icon(
        Icons.redeem,
      ),
      title: const Text('Recent'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(
        Icons.people,
      ),
      title: const Text('by User'),
    )
  ];

  OrdersRecent _recentOrdersPage;
  OrdersByUser _byUserOrderPages;
  List<Widget> _orderPages;
  final PageStorageBucket _bucket = PageStorageBucket();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    _recentOrdersPage = OrdersRecent();
    _byUserOrderPages = OrdersByUser();
    _orderPages = [_recentOrdersPage, _byUserOrderPages];
    super.initState();
  }

  Future<void> _refreshOrders(BuildContext context) {
    return this._memoizer.runOnce(() async {
      await Provider.of<Orders>(context, listen: false).setAndFetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(_orderNavs.length == _orderPages.length);
    final bottomNavBar = BottomNavigationBar(
      items: _orderNavs,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.shifting,
      onTap: (int index) => setState(() {
        _currentIndex = index;
      }),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: PageStorage(
        bucket: _bucket,
        child: FutureBuilder(
          future: _refreshOrders(context),
          builder: (_, snapShot) {
            return snapShot.connectionState == ConnectionState.waiting
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: LinearProgressIndicator(),
                    ),
                  )
                : _orderPages[_currentIndex];
          },
        ),
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }
}
