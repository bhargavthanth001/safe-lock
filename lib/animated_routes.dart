import 'package:flutter/cupertino.dart';
import 'package:safe_lock/model/album_model.dart';
import 'package:safe_lock/utils.dart';
import 'package:safe_lock/view/setting.dart';
import 'package:safe_lock/view/image_viewer.dart';
import 'package:safe_lock/view/lock_screen.dart';
import 'view/home_page.dart';

class AnimatedRoutes {
  static Route createRoute(
      AlbumModel? model, bool lock, String? enteredString) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        debugPrint("This is the gated data => $model $lock ,$enteredString");
        if (model == null && lock == false) {
          return const HomePage();
        } else {
          if (model!.password == null) {
            if (lock == true) {
              if (Utils.shared.isFinger) {
                return ImageView(model: model);
              } else {
                if (enteredString != null) {
                  return LockScreen(
                    model: model,
                    lock: lock,
                  );
                } else {
                  return SettingPage(albumModel: model);
                }
              }
            } else {
              return ImageView(model: model);
            }
          } else {
            if (lock == false) {
              return ImageView(model: model);
            } else {
              return SettingPage(
                albumModel: model,
              );
            }
          }
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final pageAnimate = animation.drive(tween);
        return SlideTransition(
          position: pageAnimate,
          child: child,
        );
      },
    );
  }
}
