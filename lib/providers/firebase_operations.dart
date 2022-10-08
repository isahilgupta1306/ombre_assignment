import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ombre_assignment/services/session_manager.dart';

import '../services/user_models.dart';

class FirebaseOperationsProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  User user = FirebaseAuth.instance.currentUser!;
  late UserModel userModel;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('onGoingEvents');
  SessionManager prefs = SessionManager();

  bool isDeleted = false;
  bool isSubmitted = false;
  Future<void> addUser(String fullName, String emailAddress, String uid,
      String channelName, String channelToken) async {
    userModel =
        UserModel(fullName, channelName, channelToken, emailAddress, uid);
    String id = '';
    await prefs.getUserData().then((value) => id = value['auth_token']);

    if (!isSubmitted) {
      await userCollection.doc(id).set(userModel.toMap());
      isSubmitted = true;
    } else {
      updateUserData(
        fullName,
        emailAddress,
        uid,
        channelName,
        channelToken,
      );
    }
    isDeleted = false;
    print("From Firebase option method ->");
    print(id);
  }

  Future<void> updateUserData(
    String fullName,
    String emailAddress,
    String uid,
    String channelName,
    String channelToken,
  ) async {
    userModel =
        UserModel(fullName, channelName, channelToken, emailAddress, uid);
    String id = '';
    await prefs.getUserData().then((value) => id = value['auth_token']);
    await userCollection.doc(id).update(userModel.toMap());
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    var data;
    await FirebaseFirestore.instance.collection('users').doc(userId).get().then(
        (DocumentSnapshot doc) => data = doc.data() as Map<String, dynamic>);

    return data;
  }

  Future<void> addEventToFirestore(String fullName, String channelName,
      String channelToken, String uid) async {
    String id = '';
    await prefs.getUserData().then((value) => id = value['auth_token']);
    final events = <String, dynamic>{
      "username": fullName,
      "channelName": channelName,
      "channelToken": channelToken,
      "host-uid": id,
    };

    await eventCollection
        .doc(id)
        .set(events)
        .then((value) => print(" Data added sucessfully"));
  }

  Future<QuerySnapshot<Object?>> getOnGoingEventData() async {
    var dataSnapshot;
    try {
      await eventCollection.get().then((value) => dataSnapshot = value);
      return dataSnapshot;
    } catch (e) {
      print(e.toString());
      return dataSnapshot;
    }
  }

  Future<void> deleteData(String userId) async {
    String id = '';
    await prefs.getUserData().then((value) => id = value['auth_token']);
    print('uid from deleteData method --> $id');
    await eventCollection.doc(id).delete();
    isDeleted = true;
    print("Data deleted");

    notifyListeners();
  }
}
