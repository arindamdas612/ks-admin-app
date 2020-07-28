import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/categoy.dart';
import '../models/http_exception.dart';

class Categories with ChangeNotifier {
  String _authToken;
  List<Category> _items;

  Categories(
    this._authToken,
    this._items,
  );

  List<Category> get items {
    return _items;
  }

  Category findById(int categoryId) {
    return _items.firstWhere(
      (category) => categoryId == category.id,
    );
  }

  Future<void> setAndFetchCategories() async {
    try {
      Map<String, String> requestHeader = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "token $_authToken",
      };
      var url = 'http://10.0.2.2:8000/api/2/category/';
      final response = await http.get(url, headers: requestHeader);
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Category> loadedCategories = [];
      extractedData.forEach(
        (category) => loadedCategories.add(
          Category(
              id: category['id'],
              name: category['name'],
              description: category['description']),
        ),
      );
      _items = [...loadedCategories];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addCategory(Category category) async {
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/2/category/';
    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: json.encode(
          {
            'name': category.name,
            'description': category.description,
          },
        ),
      );
      final id = json.decode(response.body)['id'];
      final newCategory = Category(
        id: id,
        name: category.name,
        description: category.description,
      );
      _items.add(newCategory);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateCategory(int id, Category category) async {
    final categoryIndex = _items.indexWhere((cat) => cat.id == id);
    if (categoryIndex >= 0) {
      Map<String, String> requestHeader = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "token $_authToken",
      };
      var url = 'http://10.0.2.2:8000/api/2/category/$id/';
      await http.patch(
        url,
        headers: requestHeader,
        body: json.encode({
          'name': category.name,
          'description': category.description,
        }),
      );
      _items[categoryIndex] = category;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int id) async {
    final existingCategoryIndex = _items.indexWhere((cat) => cat.id == id);
    final existingCategory = _items[existingCategoryIndex];
    _items.removeAt(existingCategoryIndex);
    Map<String, String> requestHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "token $_authToken",
    };
    var url = 'http://10.0.2.2:8000/api/2/category/$id/';
    final response = await http.delete(url, headers: requestHeader);
    if (response.statusCode >= 400) {
      _items.insert(existingCategoryIndex, existingCategory);
      notifyListeners();
      throw HttpException('Could not delete Category');
    }
  }
}
