import 'package:flutter/material.dart';
import 'package:sentinex/models/user.dart';
import 'package:sentinex/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final MAuthMethods _authMethods = MAuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}