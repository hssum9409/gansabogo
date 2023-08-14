import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUserModel with ChangeNotifier {
  User? _user;
  String? _userPosition;
  Map<String, dynamic>? _userData;

  Future<void> setUser(User? user) async {
    _user = user;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get()
          .then((value) {
        _userData = value.data();
      });
    }

    _userPosition = _userData!['position'];

    notifyListeners();
  }

  User? get user => _user;
  String? get userPosition => _userPosition;
  Map<String, dynamic>? get userData => _userData;
}
