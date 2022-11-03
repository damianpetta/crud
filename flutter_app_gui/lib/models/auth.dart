import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userRole = '';
  String? _userName;
  bool _isAuth = false;
  var authTimer;

  Future<void> register(
      String userLogin, String userPassword, String userRole) async {
    var url = Uri.parse('http://10.0.2.2:8080/register');
    try {
      final response = await http.post(url,
          body: json.encode({
            'username': userLogin,
            'password': userPassword,
            'role': userRole,
          }));
      final responseData = json.decode(response.body);

      await login(userLogin, userPassword);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String login, String password,
      [bool guest = false]) async {
    if (!guest) {
      var url = Uri.parse('http://10.0.2.2:8080/login');
      try {
        final response = await http.post(url,
            body: json.encode({
              'username': login,
              'password': password,
            }));

        final responseData = json.decode(response.body);
        var tokenData = Jwt.parseJwt(responseData['accessToken']);
        var refreshData = Jwt.parseJwt(responseData['refreshToken']);
        _token = responseData['accessToken'];
        _userName = tokenData['username'];
        _userRole = tokenData['role'];
        _expiryDate = Jwt.getExpiryDate(responseData['accessToken']);
        _isAuth = true;
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final accessToken = json.encode(
          {
            'token': _token,
            'userRole': _userRole,
            'expiryDate': _expiryDate!.toIso8601String(),
          },
        );
        final refreshToken = json.encode(
          {
            'token': responseData['refreshToken'],
            'userRole': refreshData['role'],
            'expiryDate': Jwt.getExpiryDate(responseData['refreshToken'])!
                .toIso8601String(),
          },
        );
        prefs.setString('accessToken', accessToken);
        prefs.setString('refreshToken', refreshToken);
      } catch (error) {
        throw error;
      }
    } else {
      _userName = 'guest';
      _userRole = 'guest';
      _token = 'unauthorized';
      _isAuth = true;
      notifyListeners();
    }
  }

  bool get isAuth {
    return _isAuth;
  }

  String get userRole {
    return _userRole!;
  }

  String get userName {
    return _userName!;
  }

  String get token {
    return _token!;
  }

  Future<void> logout() async {
    _userRole = '';
    _userName = '';
    _token = '';
    _isAuth = false;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpiry), (() async {
      final flag = await tryRefreshToken();
      if (flag) {
        return;
      } else {
        logout();
      }
    }));
  }

  Future<bool> tryAutologin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('accessToken')) {
      return false;
    } else {
      final extractedUserData = await prefs.getString('accessToken');
      final userData = json.decode(extractedUserData!) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(userData['expiryDate'] as String);
      if (expiryDate.isBefore(DateTime.now())) {
        return tryRefreshToken();
      } else {
        _token = userData['token'];
        _userRole = userData['userRole'];
        _expiryDate = expiryDate;
        _isAuth = true;
        notifyListeners();
        _autoLogout();
        return true;
      }
    }
  }

  Future<bool> tryRefreshToken() async {
    print("try to refresh token");
    final prefs = await SharedPreferences.getInstance();
    String refreshTokenString;
    if (!prefs.containsKey('refreshToken')) {
      return false;
    } else {
      final extractedUserData = await prefs.getString('refreshToken');
      final userData = json.decode(extractedUserData!) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(userData['expiryDate'] as String);
      refreshTokenString = await userData['token'];
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      } else {
        var url = Uri.parse('http://10.0.2.2:8080/refresh');
        try {
          final response = await http.post(url,
              body: json.encode({
                "refresh_token": refreshTokenString,
              }));

          final responseData = json.decode(response.body);
          var tokenData = Jwt.parseJwt(responseData['accessToken']);
          var refreshData = Jwt.parseJwt(responseData['refreshToken']);
          _token = responseData['accessToken'];
          _userName = tokenData['username'];
          _userRole = tokenData['role'];
          _expiryDate = Jwt.getExpiryDate(responseData['accessToken']);
          _isAuth = true;
          notifyListeners();

          final accessToken = json.encode(
            {
              'token': _token,
              'userRole': _userRole,
              'expiryDate': _expiryDate!.toIso8601String(),
            },
          );
          final refreshToken = json.encode(
            {
              'token': responseData['refreshToken'],
              'userRole': refreshData['role'],
              'expiryDate': Jwt.getExpiryDate(responseData['refreshToken'])!
                  .toIso8601String(),
            },
          );
          prefs.setString('accessToken', accessToken);
          prefs.setString('refreshToken', refreshToken);

          notifyListeners();
          _autoLogout();
          return true;
        } catch (error) {
          throw error;
        }
      }
    }
  }
}
