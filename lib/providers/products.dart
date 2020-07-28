import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  String _authToken;
  List<Product> _items;

  Products(
    this._authToken,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  Product findById(int id) {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    return _items[productIndex];
  }

  Future<void> setAndFetchProducts() async {
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/2/product/';

    try {
      final response = await http.get(url, headers: requestHeader);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      List<dynamic> prods = extractedData['products'];
      final List<Product> loadedProducts = [];
      prods.forEach((product) {
        List specs = product['specs'];
        List<Map<String, String>> specsFormated = specs
            .map((sp) =>
                {'key': sp['key'].toString(), 'value': sp['value'].toString()})
            .toList();
        loadedProducts.add(
          Product(
            id: product['id'],
            title: product['title'],
            categoryId: product['categoryId'],
            qty: product['qty'],
            markedPrice: product['markedPrice'],
            isActive: product['isActive'],
            productSpecs: [...specsFormated],
            productImages: [...product['imageUrls']],
          ),
        );
      });
      _items = [...loadedProducts];
      //notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    var url = 'http://10.0.2.2:8000/api/2/product/';
    Uri uri = Uri.parse(url);

    var request = http.MultipartRequest(
      'POST',
      uri,
    );

    newProduct.productImages.forEach((imageFile) {
      request.files.add(imageFile);
    });
    request.headers['authorization'] = "token $_authToken";
    request.headers['content-type'] = "multipart/form-data";
    request.headers['accept'] = "application/json";
    request.fields['title'] = newProduct.title;
    request.fields['categoryId'] = newProduct.categoryId.toString();
    request.fields['isActive'] = newProduct.isActive ? 'y' : 'n';
    request.fields['markedPrice'] = newProduct.markedPrice.toStringAsFixed(2);
    request.fields['qty'] = newProduct.qty.toString();
    request.fields['specs'] = json.encode(newProduct.productSpecs);

    try {
      http.Response response =
          await http.Response.fromStream(await request.send());
      var extractedData = json.decode(response.body);
      final respCode = extractedData['message_code'];
      if (respCode == 0) {
        throw HttpException(extractedData['error']);
      } else {
        newProduct.id = extractedData['productId'];
        newProduct.productImages = [...extractedData['image_urls']];
        _items.add(newProduct);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> saveToServer(Product updatedProduct) async {
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/2/product/update/';

    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: json.encode({
          'id': updatedProduct.id.toString(),
          'title': updatedProduct.title,
          'categoryId': updatedProduct.categoryId.toString(),
          'markedPrice': updatedProduct.markedPrice.toString(),
          'isActive': updatedProduct.isActive ? 'y' : 'n',
          'qty': updatedProduct.qty,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['message_code'] > 0) {
        return true;
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProductSpecifications(
      int id, List<Map<String, String>> updatedSpecification) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Product productToUpdate = _items[productIndex];
    Product newProduct = Product(
      id: productToUpdate.id,
      title: productToUpdate.title,
      categoryId: productToUpdate.categoryId,
      qty: productToUpdate.qty,
      markedPrice: productToUpdate.markedPrice,
      isActive: productToUpdate.isActive,
      productSpecs: [...updatedSpecification],
      productImages: [...productToUpdate.productImages],
    );
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/2/product/update/';
    try {
      final response = await http.patch(
        url,
        headers: requestHeader,
        body: json.encode({
          'id': newProduct.id.toString(),
          'specs': json.encode(newProduct.productSpecs)
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['message_code'] > 0) {
        _items.removeAt(productIndex);
        _items.insert(productIndex, newProduct);
        notifyListeners();
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> replaceProductImages(
      int id, List<http.MultipartFile> newImageSet) async {
    var url = 'http://10.0.2.2:8000/api/2/product/';
    Uri uri = Uri.parse(url);
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Product productToUpdate = _items[productIndex];
    var request = http.MultipartRequest(
      'PUT',
      uri,
    );
    newImageSet.forEach((imageFile) {
      request.files.add(imageFile);
    });
    request.headers['authorization'] = "token $_authToken";
    request.headers['content-type'] = "multipart/form-data";
    request.headers['accept'] = "application/json";
    request.fields['id'] = id.toString();

    try {
      http.Response response =
          await http.Response.fromStream(await request.send());
      var extractedData = json.decode(response.body);
      final respCode = extractedData['message_code'];
      if (respCode == 0) {
        throw HttpException(extractedData['error']);
      } else {
        Product updatedProduct = Product(
          id: productToUpdate.id,
          title: productToUpdate.title,
          categoryId: productToUpdate.categoryId,
          qty: productToUpdate.qty,
          markedPrice: productToUpdate.markedPrice,
          isActive: productToUpdate.isActive,
          productSpecs: [...productToUpdate.productSpecs],
          productImages: [...extractedData['image_urls']],
        );
        _items.removeAt(productIndex);
        _items.insert(productIndex, updatedProduct);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(int id) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/2/product/update/?id=$id';
    try {
      final response = await http.delete(url, headers: requestHeader);
      var extractedData = json.decode(response.body);
      final respCode = extractedData['message_code'];
      if (respCode == 0) {
        throw HttpException(extractedData['details']);
      } else {
        _items.removeAt(productIndex);
        notifyListeners();
      }
    } catch (error) {
      throw HttpException('Error Occured');
    }
  }

  Future<void> updateTitle(int id, String newTitle) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Product productToUpdate = _items[productIndex];
    Product newProduct = Product(
      id: productToUpdate.id,
      title: newTitle,
      categoryId: productToUpdate.categoryId,
      qty: productToUpdate.qty,
      markedPrice: productToUpdate.markedPrice,
      isActive: productToUpdate.isActive,
      productSpecs: [...productToUpdate.productSpecs],
      productImages: [...productToUpdate.productImages],
    );
    try {
      bool success = await saveToServer(newProduct);
      if (success) {
        _items.removeAt(productIndex);
        _items.insert(productIndex, newProduct);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updatePrice(int id, double newPrice) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Product productToUpdate = _items[productIndex];
    Product newProduct = Product(
      id: productToUpdate.id,
      title: productToUpdate.title,
      categoryId: productToUpdate.categoryId,
      qty: productToUpdate.qty,
      markedPrice: newPrice,
      isActive: productToUpdate.isActive,
      productSpecs: [...productToUpdate.productSpecs],
      productImages: [...productToUpdate.productImages],
    );

    try {
      bool success = await saveToServer(newProduct);
      if (success) {
        _items.removeAt(productIndex);
        _items.insert(productIndex, newProduct);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> changeStatus(int id, bool value) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Product productToUpdate = _items[productIndex];
    Product newProduct = Product(
      id: productToUpdate.id,
      title: productToUpdate.title,
      categoryId: productToUpdate.categoryId,
      qty: productToUpdate.qty,
      markedPrice: productToUpdate.markedPrice,
      isActive: value,
      productSpecs: [...productToUpdate.productSpecs],
      productImages: [...productToUpdate.productImages],
    );
    try {
      bool success = await saveToServer(newProduct);
      if (success) {
        _items.removeAt(productIndex);
        _items.insert(productIndex, newProduct);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addQuantity(int id, int addQuantity) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    Product productToUpdate = _items[productIndex];
    Product newProduct = Product(
      id: productToUpdate.id,
      title: productToUpdate.title,
      categoryId: productToUpdate.categoryId,
      qty: productToUpdate.qty + addQuantity,
      markedPrice: productToUpdate.markedPrice,
      isActive: productToUpdate.isActive,
      productSpecs: [...productToUpdate.productSpecs],
      productImages: [...productToUpdate.productImages],
    );
    try {
      bool success = await saveToServer(newProduct);
      if (success) {
        _items.removeAt(productIndex);
        _items.insert(productIndex, newProduct);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
