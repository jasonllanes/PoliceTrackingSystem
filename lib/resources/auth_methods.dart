import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "email": email,
          "password": password,
        });

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
