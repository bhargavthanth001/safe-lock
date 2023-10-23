import 'package:flutter/material.dart';
import 'package:safe_lock/utils.dart';
import 'package:safe_lock/view/lock_screen.dart';

class AppLock extends StatelessWidget with WidgetsBindingObserver {
  final Widget child;

  const AppLock({Key? key, required this.child}) : super(key: key);

  void showLockScreen(bool isLock) {
    debugPrint("This is the lock screen => ${isLock.toString()}");
    if (isLock == false) {
      Utils.shared.isLockScreen = true;
      Utils.shared.navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LockScreen(
            model: null,
            lock: false,
          ),
        ),
      );
      debugPrint(Utils.shared.isLockScreen.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint(state.toString());
    debugPrint("photo => ${Utils.shared.isPhotos}");
    debugPrint("Lock Screen => ${Utils.shared.isLockScreen}");
    debugPrint("is Inactive => ${Utils.shared.isInactive}");
    switch (state) {
      case AppLifecycleState.inactive:
        if (Utils.shared.isInactive == false) {
          debugPrint("Break...");
          break;
        }
      case AppLifecycleState.resumed:
        if (Utils.shared.isPhotos == false) {
          showLockScreen(Utils.shared.isLockScreen);
        } else {
          Utils.shared.isPhotos = false;
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return child;
  }
}
