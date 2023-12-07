import 'package:flutter/material.dart';
import 'package:sentinex/models/patrol_account_details.dart';
import 'package:sentinex/models/user.dart';
import 'package:sentinex/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  PatrolAccountDetails? _patrolAccountDetails;

  final MAuthMethods _authMethods = MAuthMethods();

  User? get getUser => _user;
  PatrolAccountDetails? get getPatrolAccountDetails => _patrolAccountDetails;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    PatrolAccountDetails patrolAccountDetails =
        (await _authMethods.getAllPatrolAccounts()) as PatrolAccountDetails;
    _user = user;
    _patrolAccountDetails = patrolAccountDetails;
    notifyListeners();
  }
}
