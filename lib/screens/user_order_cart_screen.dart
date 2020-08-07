import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../providers/orders.dart';
import '../providers/users.dart';

import '../widgets/order_status_icon.dart';
import '../widgets/order_item_card.dart';

import '../screens/order_detail_screen.dart';

import '../models/order.dart';
import '../models/user.dart';

class UserOrderCartScreen extends StatefulWidget {
  static const routeName = '/user-order-cart';
  @override
  _UserOrderCartScreenState createState() => _UserOrderCartScreenState();
}

class _UserOrderCartScreenState extends State<UserOrderCartScreen> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  bool _isInit = true;
  List<Order> _orders;

  User _selectedUser;
  int _currentIndex = 1;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      int userId = ModalRoute.of(context).settings.arguments as int;
      _selectedUser =
          Provider.of<Users>(context, listen: false).userById(userId);
      _orders = _selectedUser.orders
          .map((orderId) =>
              Provider.of<Orders>(context, listen: false).findById(orderId))
          .toList();
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Widget noItems(String textToDisplay) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.remove_shopping_cart,
              size: 60,
              color: Colors.redAccent,
            ),
            Text(
              textToDisplay,
              style: TextStyle(
                  fontSize: 35,
                  color: Theme.of(context).accentColor,
                  fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );

  Widget getItemListWidget(bool isCart) =>
      (_selectedUser.cartItems.length == 0 && isCart) ||
              (_selectedUser.wishListed.length == 0 && !isCart)
          ? noItems(isCart ? 'Empty Cart' : 'No Wishlist')
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                itemBuilder: (context, index) => OrderItemCard(
                    orderItem: isCart
                        ? _selectedUser.cartItems[index]
                        : _selectedUser.wishListed[index]),
                itemCount: isCart
                    ? _selectedUser.cartItems.length
                    : _selectedUser.wishListed.length,
              ),
            );

  @override
  Widget build(BuildContext context) {
    Widget cartPage = getItemListWidget(true);
    Widget wishLitedItems = getItemListWidget(false);
    List<Widget> _tabPages = <Widget>[
      cartPage,
      _orders.length == 0
          ? noItems('No Orders Yet!!')
          : UserOrders(orders: _orders),
      wishLitedItems,
    ];
    final _navTabs = <Widget>[
      Icon(
        Icons.shopping_cart,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
      Icon(
        Icons.shopping_basket,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
      Icon(
        Icons.sentiment_very_satisfied,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedUser.name),
      ),
      body: _tabPages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _navTabs,
        index: _currentIndex,
        height: 50.0,
        color: Theme.of(context).accentColor,
        buttonBackgroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }
}

class UserOrders extends StatelessWidget {
  const UserOrders({
    Key key,
    @required List<Order> orders,
  })  : _orders = orders,
        super(key: key);

  final List<Order> _orders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            onTap: () => Navigator.of(context).pushNamed(
                OrderDetailScreen.routeName,
                arguments: _orders[index].id),
            leading: OrderStatusIcon(_orders[index].orderStatus),
            title: Text(
              _orders[index].displayId,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd HH:mm').format(_orders[index].createDt),
            ),
            trailing: Container(
              alignment: Alignment.center,
              height: 50,
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Image(
                      image: AssetImage(
                        _orders[index].orderValue > 0
                            ? 'assets/images/rupee-symbol-file-white.png'
                            : 'assets/images/rupee-symbol-file-red.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                    height: 15,
                    width: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _orders[index].orderValue.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PTSans',
                        color: _orders[index].orderValue > 0
                            ? Colors.white
                            : Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
