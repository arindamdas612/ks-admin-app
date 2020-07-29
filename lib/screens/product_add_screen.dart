import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../providers/categories.dart';
import '../providers/products.dart';

import '../models/product.dart';

import './product_add_spec_screen.dart';
import '../screens/product_add_images_screen.dart';

class ProductAddScreen extends StatefulWidget {
  static const routeName = '/product-add';
  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  List<Map<String, String>> _productSpecification = [];
  List<MultipartFile> _productImage = [];

  var _productQuantity = 1;
  var _productCategory = 0;
  var _isActive = true;

  var _isLoading = false;

  void _adjustQuantity(bool increaseQuantity) {
    final newValue =
        increaseQuantity ? _productQuantity + 1 : _productQuantity - 1;
    if (newValue >= 1) {
      setState(() {
        _productQuantity = newValue;
      });
    }
  }

  Future<void> _submitData() async {
    if (_titleController.text.isEmpty) {
      return;
    }
    if (_productCategory <= 0) {
      return;
    }
    if (_priceController.text.isEmpty) {
      return;
    }
    if (double.tryParse(_priceController.text) == null) {
      return;
    }
    if (_productSpecification.length == 0) {
      return;
    }
    if (_productImage.length == 0) {
      return;
    }
    this.setState(() {
      _isLoading = true;
    });
    final newProduct = Product(
      id: null,
      title: _titleController.text,
      categoryId: _productCategory,
      qty: _productQuantity,
      markedPrice: double.parse(_priceController.text),
      isActive: _isActive,
      productSpecs: [..._productSpecification],
      productImages: [..._productImage],
    );
    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(newProduct);
      this.setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (error) {}
  }

  void addSpec(List<Map<String, String>> allSpecs) {
    _productSpecification.clear();
    this.setState(() {
      _productSpecification = [...allSpecs];
    });
  }

  void getImages(List<Asset> images) async {
    _productImage.clear();
    int count = 0;
    final imgResponse = images.map((img) async {
      ByteData byteData = await img.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename: 'P_<${DateTime.now().toIso8601String()}>_$count.jpg',
        contentType: MediaType("image", "jpg"),
      );
      setState(() {
        _productImage.add(multipartFile);
      });

      count++;
    }).toList();
    imgResponse.clear();
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<Categories>(context, listen: false)
        .items
        .map((cat) => {'id': cat.id, 'name': cat.name})
        .toList();
    categoryList.insert(0, {'name': 'Select Category', 'id': 0});

    return Scaffold(
      appBar: AppBar(
        title: Text('Add product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _submitData(),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Product Title',
                              icon: const Icon(Icons.title),
                            ),
                            onSubmitted: (value) {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                DropdownButton<int>(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (value) => this.setState(() {
                                    _productCategory = value;
                                  }),
                                  value: _productCategory,
                                  items: categoryList
                                      .map<DropdownMenuItem<int>>(
                                        (cat) => DropdownMenuItem<int>(
                                          child: Text(cat['name']),
                                          value: cat['id'],
                                        ),
                                      )
                                      .toList(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Active?'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Switch(
                                    value: _isActive,
                                    onChanged: (value) => this.setState(() {
                                          _isActive = value;
                                        }))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => _adjustQuantity(false),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                width: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  _productQuantity.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _adjustQuantity(true),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Marked Price',
                              icon: Container(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/rupee-symbol-file.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                height: 30,
                                width: 30,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(ProductSpecAddScreen.routeName,
                                        arguments: {
                                      'specList': _productSpecification,
                                      'addFunc': addSpec,
                                    }),
                                icon: Icon(
                                  Icons.settings_applications,
                                  color: _productSpecification.length == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                label: Text(
                                  'Add Specs (${_productSpecification.length.toString()})',
                                  style: TextStyle(
                                      color: _productSpecification.length == 0
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                color: _productSpecification.length == 0
                                    ? Theme.of(context).errorColor
                                    : Theme.of(context).accentColor,
                              ),
                              FlatButton.icon(
                                onPressed: () =>
                                    Navigator.of(context).pushNamed(
                                  ProductImageAddScreen.routeName,
                                  arguments: getImages,
                                ),
                                icon: Icon(
                                  Icons.image,
                                  color: _productImage.length == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                label: Text(
                                  'Add Images (${_productImage.length.toString()})',
                                  style: TextStyle(
                                      color: _productImage.length == 0
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                color: _productImage.length == 0
                                    ? Theme.of(context).errorColor
                                    : Theme.of(context).accentColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
