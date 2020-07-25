import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<Auth>(context).name;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kirana Store'),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Text('Welcome - $userName'),
        ));
  }
}
