import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../screens/product_add_spec_screen.dart';
import '../screens/product_add_images_screen.dart';
import './product_carousel.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-category';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product _product;
  List<MultipartFile> _replacedImages;
  double _qtyAddValue = 0;
  final _priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> addSpec(List<Map<String, String>> allSpecs) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .updateProductSpecifications(
        _product.id,
        allSpecs,
      );
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Specification Update Success'),
          content: Text('Product Specification Updated'),
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Specification Update Failed'),
          content:
              Text('An Error occured while updating the Product Specification'),
        ),
      );
    }
  }

  Future<void> replaceProductImages(List<Asset> images) async {
    this.setState(() {
      _isLoading = true;
    });
    int count = 0;
    _replacedImages = [];
    await Future.forEach(images, (img) async {
      ByteData byteData = await img.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename: 'P_<${DateTime.now().toIso8601String()}>_$count.jpg',
        contentType: MediaType("image", "jpg"),
      );
      _replacedImages.add(multipartFile);
      count++;
    });
    if (_replacedImages.length > 0)
      await Provider.of<Products>(context, listen: false)
          .replaceProductImages(_product.id, _replacedImages);
    this.setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      final productId = ModalRoute.of(context).settings.arguments as int;
      if (productId != null) {
        var loadedProducts =
            Provider.of<Products>(context, listen: false).items;
        _product =
            loadedProducts.firstWhere((element) => element.id == productId);
      }
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 500,
                    pinned: true,
                    actions: <Widget>[
                      Consumer<Products>(
                        builder: (ctx, prodData, _) => IconButton(
                          icon: Icon(Icons.view_carousel),
                          onPressed: () => Navigator.of(context).pushNamed(
                            ProductCarousel.routName,
                            arguments: [
                              ...prodData.findById(_product.id).productImages
                            ],
                          ),
                        ),
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        _product.title,
                        style: TextStyle(color: Colors.black54),
                      ),
                      background: Hero(
                        tag: _product.id,
                        child: Consumer<Products>(
                          builder: (ctx, prodData, _) {
                            Product prod = prodData.findById(_product.id);
                            return prod.productImages.length == 0
                                ? Image.asset(
                                    'assets/images/image_place_holder.png',
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(prod.productImages[0],
                                    fit: BoxFit.cover);
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      'Update New Price',
                                      style: TextStyle(
                                        color: Colors.cyan,
                                      ),
                                    ),
                                    content: TextField(
                                      controller: _priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
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
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.cyan,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(
                                            color: Colors.cyan,
                                          ),
                                        ),
                                        onPressed: () {
                                          double newPrice = (double.tryParse(
                                                      _priceController.text) !=
                                                  null)
                                              ? double.parse(
                                                  _priceController.text)
                                              : null;
                                          if (newPrice != null) {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .updatePrice(
                                                    _product.id, newPrice);
                                          }
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Consumer<Products>(
                                builder: (ctx, productData, _) => Text(
                                  '₹ ${productData.findById(_product.id).markedPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Consumer<Products>(
                              builder: (cts, productsData, _) => Text(
                                'Quantity: ${productsData.findById(_product.id).qty}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Consumer<Products>(
                              builder: (ctx, prodData, _) => FlatButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(ProductSpecAddScreen.routeName,
                                        arguments: {
                                      'specList': prodData
                                          .findById(_product.id)
                                          .productSpecs,
                                      'addFunc': addSpec,
                                    }),
                                icon: Icon(Icons.update),
                                label: Text('Specs'),
                                color: Colors.lightBlue,
                              ),
                            ),
                            FlatButton.icon(
                              onPressed: () => Navigator.of(context).pushNamed(
                                ProductImageAddScreen.routeName,
                                arguments: replaceProductImages,
                              ),
                              icon: Icon(Icons.cloud_upload),
                              label: Text('Replace'),
                              color: Colors.amberAccent,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Slider(
                          min: -50.0,
                          max: 50.0,
                          divisions: 100,
                          label: '${_qtyAddValue.toStringAsFixed(0)}',
                          value: _qtyAddValue,
                          onChanged: (value) => this.setState(() {
                            _qtyAddValue = value;
                          }),
                        ),
                        Consumer<Products>(
                          builder: (ctx, prodData, _) => FlatButton.icon(
                            color: Theme.of(context).primaryColor,
                            label: Text(
                              _qtyAddValue < 0
                                  ? 'Remove ${(_qtyAddValue * -1).toStringAsFixed(0)} items'
                                  : 'Add ${_qtyAddValue.toStringAsFixed(0)} items',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            icon: Icon(
                              Icons.system_update_alt,
                              color: Colors.white,
                            ),
                            onPressed: _qtyAddValue != 0
                                ? () {
                                    var newValue =
                                        (prodData.findById(_product.id).qty +
                                            _qtyAddValue);
                                    if (newValue >= 0) {
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .addQuantity(
                                        _product.id,
                                        int.parse(
                                            _qtyAddValue.toStringAsFixed(0)),
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(
                                              'Product Quantity updated!!'),
                                          content: Text(
                                            'Quantity modified',
                                          ),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                              Text('Quantity update Failed!!'),
                                          content: Text(
                                            'Cannot modify the quantity. The result is negatve and not allowed',
                                          ),
                                        ),
                                      );
                                    }
                                    this.setState(() {
                                      _qtyAddValue = 0;
                                    });
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Consumer<Products>(
                            builder: (ctx, prodData, _) => DataTable(
                                  dividerThickness: 2,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Key',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Value',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  rows: <DataRow>[
                                    ...prodData
                                        .findById(_product.id)
                                        .productSpecs
                                        .map(
                                          (specs) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(specs['key'])),
                                              DataCell(Text(specs['value'])),
                                            ],
                                          ),
                                        ),
                                  ],
                                )
                            // Container(
                            //   child: Column(children: <Widget>[
                            //     ...prodData
                            //         .findById(_product.id)
                            //         .productSpecs
                            //         .map(
                            //           (prod) => Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceEvenly,
                            //             children: <Widget>[
                            //               Text(
                            //                 prod['key'],
                            //                 style: TextStyle(
                            //                     color: Colors.blue, fontSize: 20),
                            //               ),
                            //               Icon(
                            //                 Icons.keyboard_arrow_right,
                            //                 color: Theme.of(context)
                            //                     .primaryColorLight,
                            //               ),
                            //               Text(
                            //                 prod['value'],
                            //                 style: TextStyle(
                            //                     color: Colors.blueAccent,
                            //                     fontSize: 20),
                            //               ),
                            //             ],
                            //           ),
                            //         )
                            //         .toList()
                            //   ]),
                            // ),
                            ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
