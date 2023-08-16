import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUserModel with ChangeNotifier {
  User? _user;

  String? _userName;
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

      _userName = _userData!['info']['name'];
      _userPosition = _userData!['info']['position'];
    } else {
      _userName = null;
      _userPosition = null;
      _userData = null;
    }

    notifyListeners();
  }

  User? get user => _user;
  String? get userName => _userName;
  String? get displayName => _userName != null ? '$_userName님 ' : '';
  String? get userPosition => _userPosition;
  Map<String, dynamic>? get userData => _userData;
}

class CampGenerateModel with ChangeNotifier {
  String? _campType;
  bool _campEtcTypeFormFolded = true;

  void setCampType(String campType) {
    _campType = campType;

    if (campType == '기타') {
      _campEtcTypeFormFolded = false;
    } else {
      _campEtcTypeFormFolded = true;
    }
    notifyListeners();
  }

  String? get campType => _campType;

  bool get campEtcTypeFormFolded => _campEtcTypeFormFolded;
}
