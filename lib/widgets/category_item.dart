import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/category_add_screen.dart';

import '../providers/categories.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String name;
  final String description;

  CategoryItem({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        decoration: BoxDecoration(
          color: null,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withAlpha(100),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Icon(
          Icons.delete_forever,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: null,
          boxShadow: [
            BoxShadow(
              color: Colors.tealAccent.withAlpha(100),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Icon(
          Icons.mode_edit,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          try {
            await Provider.of<Categories>(
              context,
              listen: false,
            ).deleteCategory(id);
          } catch (error) {
            scaffold.showSnackBar(SnackBar(
              content: Text('Deleteing Failed'),
            ));
          }
        }
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                'Are you sure you want to delete the Category?',
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
              ],
            ),
          );
        } else {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Confirm the Edit Category Action'),
              content: const Text(
                'confirm this to enter the Edit-Category Screen',
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                    Navigator.of(context).pushNamed(
                      CategoryAddScreen.routeName,
                      arguments: id,
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
      child: Card(
        elevation: 10,
        child: ListTile(
          title: Text(name),
          leading: CircleAvatar(
            child: Icon(
              Icons.bubble_chart,
              color: Theme.of(context).primaryColor,
            ),
          ),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
