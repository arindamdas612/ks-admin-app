import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _userEmail;
  String _name;
  int _userId;
  bool _isSuperUser;
  String _mobile;
  Timer _authTimer;

  bool get isAUth {
    //return token != null && _userId != null;
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userEmail {
    return token != null ? _userEmail : null;
  }

  int get userId {
    return token != null ? _userId : null;
  }

  String get name {
    return token != null ? _name : null;
  }

  String get mobile {
    return token != null ? _mobile : null;
  }

  bool get isSuperUser {
    return token != null ? _isSuperUser : null;
  }

  Future<void> _authenticate(String email, String password) async {
    try {
      Map<String, String> userHeader = {
        "Content-type": "application/json",
        "Accept": "application/json"
      };
      var url = 'http://10.0.2.2:8000/api/1/login/';
      print(url);
      var response = await http.post(
        url,
        headers: userHeader,
        body: json.encode(
          {
            'username': email,
            'password': password,
          },
        ),
      );
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['token'];
      url = 'http://10.0.2.2:8000/api/1/profile/';
      userHeader['Authorization'] = 'token $_token';
      response = await http.get(url, headers: userHeader);
      var allUsers = json.decode(response.body);
      print(allUsers);
      final loggedInUser =
          allUsers.firstWhere((user) => user['email'] == email);

      if (loggedInUser['is_superuser'] == false) {
        _token = null;
        throw HttpException('Only Admin can log in');
      }
      _token = responseData['token'];
      _userEmail = email;
      _userId = loggedInUser['id'];
      _name = loggedInUser['name'];
      _isSuperUser = loggedInUser['is_superuser'];
      _mobile = loggedInUser['mobile'];

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userEmail': _userEmail,
        'userId': _userId,
        'isSuperUser': _isSuperUser,
        'name': _name,
        'mobile': _mobile,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _userEmail = extractedUserData['userEmail'];
    _userId = extractedUserData['userId'];
    _name = extractedUserData['name'];
    _mobile = extractedUserData['mobile'];
    _isSuperUser = extractedUserData['isSuperUser'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userEmail = null;
    _name = null;
    _userId = null;
    _isSuperUser = null;
    _mobile = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    _authTimer = Timer(
      Duration(minutes: 1130),
      () => logout(),
    );
  }
}
