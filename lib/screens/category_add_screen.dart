import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/categoy.dart';

import '../providers/categories.dart';

class CategoryAddScreen extends StatefulWidget {
  static const routeName = '/new-category';

  @override
  _CategoryAddScreenState createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  final _form = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  var _initValues = {
    'name': '',
    'description': '',
  };
  var _appBarTile = 'Add a new Category';
  var _isInit = true;
  Category _editedCategory = Category(
    id: null,
    name: '',
    description: '',
  );
  var _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final categoryId = ModalRoute.of(context).settings.arguments as int;
      if (categoryId != null) {
        _editedCategory = Provider.of<Categories>(context, listen: false)
            .findById(categoryId);
        _initValues = {
          'name': _editedCategory.name,
          'description': _editedCategory.description,
        };
        _appBarTile = '${_editedCategory.name} - Edit';
      }
    }
    _isInit = false;
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });
    if (_editedCategory.id != null) {
      await Provider.of<Categories>(context, listen: false)
          .updateCategory(_editedCategory.id, _editedCategory);
      Navigator.of(context).pop();
    } else {
      try {
        Provider.of<Categories>(context, listen: false)
            .addCategory(_editedCategory);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Something went wrong!!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTile),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['name'],
                        decoration: InputDecoration(
                          labelText: 'Category Name',
                          icon: const Icon(Icons.title),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(
                          _descriptionFocusNode,
                        ),
                        onSaved: (value) {
                          _editedCategory = Category(
                            id: _editedCategory.id,
                            name: value,
                            description: _editedCategory.description,
                          );
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Please provide a value' : null,
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          icon: const Icon(Icons.description),
                          hintText: 'some description fot the product',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedCategory = Category(
                            id: _editedCategory.id,
                            name: _editedCategory.name,
                            description: value,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length <= 5) {
                            return 'Should be atleast 5 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
