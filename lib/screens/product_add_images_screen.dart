import 'package:flutter/material.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';

class ProductImageAddScreen extends StatefulWidget {
  static const routeName = '/product-add-image';
  @override
  _ProductImageAddScreenState createState() => _ProductImageAddScreenState();
}

class _ProductImageAddScreenState extends State<ProductImageAddScreen> {
  List<Asset> images = List<Asset>();
  Function _replaceImages;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _replaceImages = ModalRoute.of(context).settings.arguments as Function;
    }
    _isInit = false;
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        materialOptions: MaterialOptions(
          allViewTitle: "Select Images",
          actionBarColor: "#333131",
          actionBarTitleColor: "#FFFFFF",
          lightStatusBar: false,
          statusBarColor: '#333131',
          startInAllView: true,
          selectCircleStrokeColor: "#000000",
          selectionLimitReachedText: "You can't select any more.",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Add Images'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: loadAssets,
          ),
          IconButton(
            icon: Icon(
              Icons.save,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              _replaceImages(images);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
  }
}
