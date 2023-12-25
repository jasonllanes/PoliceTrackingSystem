import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/models/user.dart' as model;
import '../models/patrol_account_details.dart' as patrol_model;

class MAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User?> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("Users").doc(currentUser.uid).get();

    if (snap.exists) {
      return model.User.fromSnap(snap);
    } else {
      return null;
    }
  }

  //Show all names in a list without a model
  Future<String> viewAllPatrolAccounts() async {
    String res = "Something went wrong!";

    try {
      QuerySnapshot snap = await _firestore
          .collection("Users")
          .orderBy("timestamp", descending: true)
          .get();

      snap.docs.forEach((element) {
        print(element..data());
      });

      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
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
            .collection("Users")
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
    required String first_name,
    required String last_name,
    required String rank,
    required String badge_number,
    required String deployment,
    required String image_evidence,
    required GeoPoint location,
    required String station,
    required String status,
    required Timestamp timestamp,
    required Timestamp lastUpdated,
  }) async {
    String res = "Something went wrong!";

    try {
      if (name.isEmpty || badge_number.isEmpty) {
        res = "Please fill up the fields";
      } else {
        patrol_model.PatrolAccountDetails _patrols =
            patrol_model.PatrolAccountDetails(
          name: name,
          first_name: first_name,
          last_name: last_name,
          rank: rank,
          badge_number: badge_number,
          deployment: deployment,
          image_evidence: image_evidence,
          location: location,
          station: station,
          status: status,
          timestamp: timestamp,
          lastUpdated: timestamp,
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

  Future<String> updatePatrolAccount(
      {required String name,
      required String first_name,
      required String last_name,
      required String rank,
      required String badge_number,
      required Timestamp lastUpdated}) async {
    String res = "Something went wrong!";

    try {
      if (badge_number.isEmpty ||
          first_name.isEmpty ||
          last_name.isEmpty ||
          rank.isEmpty) {
        res = "Please fill up the fields";
      } else {
        await _firestore.collection("Users").doc(badge_number).update({
          "name": name,
          "first_name": first_name,
          "last_name": last_name,
          "rank": rank,
          "badge_number": badge_number,
          "lastUpdated": lastUpdated,
        });

        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateStation({
    required String station,
  }) async {
    String res = "Something went wrong!";

    try {
      if (station.isEmpty) {
        res = "Please fill up the fields";
      } else {
        await _firestore.collection("Dropdown").doc("data").update({
          "stations": FieldValue.arrayUnion([station])
        });

        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateDeployment({required String deployment}) async {
    String res = "Something went wrong!";

    try {
      if (deployment.isEmpty) {
        res = "Please fill up the fields";
      } else {
        await _firestore.collection("Dropdown").doc("data").update({
          "deployments": FieldValue.arrayUnion([deployment])
        });

        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteAccount({required String badge_number}) async {
    String res = "Something went wrong!";

    try {
      await _firestore.collection("Users").doc(badge_number).delete();

      res = "Success";
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
