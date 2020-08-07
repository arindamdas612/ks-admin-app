import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users.dart';
import '../providers/orders.dart';

import '../widgets/app_drawer.dart';
import '../widgets/app_users.dart';

class UserOverViewScreen extends StatefulWidget {
  static const routeName = '/user';
  @override
  _UserOverViewScreenState createState() => _UserOverViewScreenState();
}

class _UserOverViewScreenState extends State<UserOverViewScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<void> _refreshUsers(BuildContext ctx, bool userRequest) async {
    userRequest
        ? await Provider.of<Users>(context, listen: false).setAndFetchUsers()
        : this._memoizer.runOnce(() async {
            await Provider.of<Users>(context, listen: false).setAndFetchUsers();
            await Provider.of<Orders>(context, listen: false)
                .setAndFetchOrders();
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Users'),
      ),
      drawer: AppDrawer(),
      // body: AppUsers(),
      body: FutureBuilder(
        future: _refreshUsers(context, false),
        builder: (_, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : AppUsers(),
      ),
    );
  }
}
