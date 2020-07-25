import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/category_item.dart';

import 'category_add_screen.dart';

import '../providers/categories.dart';

class CategoryOverviewScreen extends StatefulWidget {
  static const routeName = '/categories';
  @override
  _CategoryOverviewScreenState createState() => _CategoryOverviewScreenState();
}

class _CategoryOverviewScreenState extends State<CategoryOverviewScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Categories>(context, listen: false)
        .setAndFetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirana Store'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: () =>
                Navigator.of(context).pushNamed(CategoryAddScreen.routeName),
          )
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
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Categories>(
                      builder: (ctx, categoryData, _) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => CategoryItem(
                            id: categoryData.items[i].id,
                            name: categoryData.items[i].name,
                            description: categoryData.items[i].description,
                          ),
                          itemCount: categoryData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
