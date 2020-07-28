import 'package:flutter/material.dart';

import '../widgets/spec_form.dart';

class ProductSpecAddScreen extends StatefulWidget {
  static const routeName = '/add-prod-specifications';
  @override
  _ProductSpecAddScreenState createState() => _ProductSpecAddScreenState();
}

class _ProductSpecAddScreenState extends State<ProductSpecAddScreen> {
  List<Map<String, String>> specificationList;
  Function addSpecification;
  List<SpecForm> forms = [];
  var _isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final prodDetails =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      specificationList = prodDetails['specList'];
      addSpecification = prodDetails['addFunc'];
    }
    _isInit = false;
  }

  void _onDelete(int index) {
    this.setState(() {
      specificationList.removeAt(index);
    });
  }

  void onSave() {
    forms.forEach((form) => form.isValid());
    List<Map<String, String>> newSpecs = [];
    forms.forEach((form) => newSpecs.add(form.getData()));
    addSpecification(newSpecs);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    forms.clear();
    for (int i = 0; i < specificationList.length; i++) {
      forms.add(
        SpecForm(
          key: GlobalKey(),
          sKey: specificationList[i]['key'],
          sValue: specificationList[i]['value'],
          onDelete: () {
            _onDelete(i);
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Specifications'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.system_update_alt),
            onPressed: onSave,
          )
        ],
      ),
      body: specificationList.length == 0
          ? Center(
              child:
                  Text('Tap on the add button to add Product Specifications'),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) => forms[i],
              itemCount: specificationList.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this.setState(() {
          specificationList.add({'key': '', 'value': ''});
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}
