import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './screens/category_overview_screen.dart';
import './screens/product_overview_screen.dart';
import 'screens/category_add_screen.dart';

import './providers/auth.dart';
import './providers/categories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Categories>(
          update: (ctx, auth, previousCategories) => Categories(
              auth.token,
              auth.userId,
              previousCategories == null ? [] : previousCategories.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.green,
          ),
          home: authData.isAUth
              ? HomeScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthScreen(),
                ),
          routes: {
            CategoryOverviewScreen.routeName: (_) => CategoryOverviewScreen(),
            CategoryAddScreen.routeName: (_) => CategoryAddScreen(),
            ProductOverViewScreen.routeName: (_) => ProductOverViewScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
