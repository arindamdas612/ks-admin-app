import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './app_theme.dart';

import './screens/auth_screen.dart';

import './screens/home_screen.dart';

import './screens/category_overview_screen.dart';
import './screens/category_add_screen.dart';

import './screens/product_overview_screen.dart';
import './screens/product_add_screen.dart';
import './screens/product_add_spec_screen.dart';
import './screens/product_add_images_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_carousel.dart';

import './screens/order_overview_screen.dart';
import './screens/order_detail_screen.dart';
import './screens/order_timeline_screen.dart';

import './screens/user_overview_screen.dart';
import './screens/user_order_cart_screen.dart';

import './providers/auth.dart';
import './providers/categories.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './providers/users.dart';

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
          create: null,
          update: (ctx, auth, previousCategories) => Categories(
            auth.token,
            previousCategories == null ? [] : previousCategories.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: null,
          update: (ctx, auth, previousUsers) => Users(
            auth.token,
            auth.userId,
            previousUsers == null ? [] : previousUsers.users,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.darkTheme,
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
            ProductAddScreen.routeName: (_) => ProductAddScreen(),
            ProductSpecAddScreen.routeName: (_) => ProductSpecAddScreen(),
            ProductImageAddScreen.routeName: (_) => ProductImageAddScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            ProductCarousel.routName: (_) => ProductCarousel(),
            OrdersOverViewScreen.routeName: (_) => OrdersOverViewScreen(),
            OrderDetailScreen.routeName: (_) => OrderDetailScreen(),
            OrderTimeLineScreen.routeName: (_) => OrderTimeLineScreen(),
            UserOverViewScreen.routeName: (_) => UserOverViewScreen(),
            UserOrderCartScreen.routeName: (_) => UserOrderCartScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
