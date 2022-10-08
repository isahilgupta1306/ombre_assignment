import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/session_manager.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  late final String uid;
  SessionManager prefs = SessionManager();
  GoogleSignInAccount get user => _user!;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future googleLogIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      _user = googleUser;

      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

      uid = auth.currentUser!.uid;

      prefs.setUserData(uid, user.displayName!, user.email);
      print("Google id  --> ${_user!.id} | from GoogleSigninProvider");
      print("User uid --> ${uid} | from GoogleSigninProvider");
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> userUID() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String uid1 = auth.currentUser!.uid;
    return uid1;
  }

  Future logout() async {
    FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    prefs.clearAll();
    notifyListeners();
    print("User logged out , data cleared !");
  }
}
