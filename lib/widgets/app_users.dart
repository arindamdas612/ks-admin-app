import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/users.dart';

import '../models/http_exception.dart';
import '../models/user.dart';

import '../screens/user_order_cart_screen.dart';

class AppUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Users>(
      builder: (context, userData, _) => Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: userData.appUsers.length,
          itemBuilder: (context, index) =>
              UserCard(user: userData.appUsers[index]),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({
    this.user,
    Key key,
  }) : super(key: key);

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          user.isActive
              ? BoxShadow(
                  blurRadius: 10,
                  color: Theme.of(context).accentColor.withAlpha(100),
                )
              : BoxShadow(
                  blurRadius: 10,
                  color: Theme.of(context).errorColor.withAlpha(100),
                )
        ],
      ),
      width: double.infinity,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () => Navigator.of(context)
                  .pushNamed(UserOrderCartScreen.routeName, arguments: user.id),
              isThreeLine: true,
              leading: CircleAvatar(
                child: Icon(
                  user.isAdmin ? Icons.person : Icons.people,
                  color: user.isAdmin
                      ? Theme.of(context).accentColor
                      : Colors.lightGreenAccent,
                ),
              ),
              title: Text(user.name),
              subtitle: Text('+91 - ${user.mobile} \n ${user.email}'),
              trailing: InkWell(
                key: ValueKey(user.id),
                onTap: () async {
                  try {
                    await Provider.of<Users>(context, listen: false)
                        .changeStatus(user.id);
                    Toast.show('User modified!!!', context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } on HttpException catch (error) {
                    _showErrorDialog('$error', context);
                  } catch (error) {
                    _showErrorDialog('Error occured. Try Again', context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 5,
                          blurRadius: 10,
                          color: user.isActive
                              ? Colors.greenAccent.withAlpha(100)
                              : Colors.redAccent.withAlpha(100))
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      user.isActive ? Icons.person : Icons.person_outline,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Chip(
                    backgroundColor: Theme.of(context).accentColor,
                    avatar: CircleAvatar(
                      child: Icon(
                        user.orders.length > 0
                            ? Icons.shopping_basket
                            : Icons.remove_circle,
                        size: 20,
                        color: Theme.of(context).accentColor,
                      ),
                      maxRadius: 50,
                    ),
                    label: Text(
                      'Orders (${user.orders.length})',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.lightGreen,
                    avatar: CircleAvatar(
                      child: Icon(
                        user.cartItems.length > 0
                            ? Icons.shopping_cart
                            : Icons.remove_shopping_cart,
                        size: 20,
                        color: Colors.lightGreen,
                      ),
                      maxRadius: 50,
                    ),
                    label: Text(
                      'Cart Items (${user.cartItems.length})',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.blueAccent,
                    avatar: CircleAvatar(
                      child: Icon(
                        user.wishListed.length > 0
                            ? Icons.sentiment_very_satisfied
                            : Icons.sentiment_dissatisfied,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                      maxRadius: 50,
                    ),
                    label: Text(
                      'Wishlist (${user.wishListed.length})',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 10),
            ),
          ],
        ),
      ),
    );
  }
}
