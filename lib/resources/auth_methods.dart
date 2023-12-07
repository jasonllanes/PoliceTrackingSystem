import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/models/user.dart' as model;
import '../models/patrol_account_details.dart' as patrol_model;
import '../models/patrol_account_details.dart';

class MAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<List> getAllPatrolAccounts() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .orderBy("timestamp", descending: true)
        .get();

    return List.from(
        querySnapshot.docs.map((e) => PatrolAccountDetails.fromSnap(e)));
  }

  Future<String> singUpUser({
    required String email,
    required String password,
  }) async {
    String res = "Something went wrong!";

    try {
      if (email.isEmpty || password.isEmpty) {
        res = "Please fill up the fields";
      } else {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        print(userCredential.user!.uid);

        model.User _user = model.User(
          uid: userCredential.user!.uid,
          email: email,
          password: "",
        );

        await _firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(_user.toJson());

        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign in with email and password
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    String res = 'Something went wrong!';
    try {
      if (email.isEmpty || password.isEmpty) {
        res = "Please fill up the fields";
      } else {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Add Account
  Future<String> addPatrolAccount({
    required String name,
    required String badge_number,
    required String deployment,
    required String image_evidence,
    required GeoPoint location,
    required String station,
    required String status,
    required Timestamp timestamp,
  }) async {
    String res = "Something went wrong!";

    try {
      if (name.isEmpty || badge_number.isEmpty) {
        res = "Please fill up the fields";
      } else {
        patrol_model.PatrolAccountDetails _patrols =
            patrol_model.PatrolAccountDetails(
          name: name,
          badge_number: badge_number,
          deployment: deployment,
          image_evidence: image_evidence,
          location: location,
          station: station,
          status: status,
          timestamp: timestamp,
        );

        await _firestore
            .collection("Users")
            .doc(badge_number)
            .set(_patrols.toJson());

        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign out
  Future<String> signOut() async {
    String res = "Something went wrong!";
    try {
      await _auth.signOut();

      res = "Success";
    } catch (e) {
      print(e.toString());
    }

    return res;
  }
}
