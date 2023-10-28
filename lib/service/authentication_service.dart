import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final auth = LocalAuthentication();
  static bool canCheckBiometric = false;

  //store available biometric like fingerprint , faceId;
  static List<BiometricType> availableBiometric = [];

  //variable to check we can access the app or not
  static String authorize = "Not Authorized";

  static Future<void> checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    canCheckBiometric = canCheckBiometric;
  }

  static Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    availableBiometric = availableBiometrics;
  }

  static Future<bool> authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: "Scan your fingerprint",
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return authenticated;
  }
}
