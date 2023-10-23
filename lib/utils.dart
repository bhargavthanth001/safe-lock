import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_lock/model/album_model.dart';

class Utils {
  static Utils shared = Utils();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool isLockScreen = true;
  Widget? widget;
  String? pin;
  bool isPhotos = false;
  bool isAlbumLock = false;
  bool isFinger = false;
  bool credential = false;
  bool isInactive = false;
  bool usePin = false;

  toast() {
    return Fluttertoast.showToast(
      msg: "Please enter the valid pin",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
