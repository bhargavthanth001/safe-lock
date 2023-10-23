import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_lock/animated_routes.dart';
import 'package:safe_lock/data_handler/data_handler.dart';
import 'package:safe_lock/model/album_model.dart';
import 'package:safe_lock/view/image_viewer.dart';
import '../service/authentication_service.dart';
import '../utils.dart';

class LockScreen extends StatefulWidget {
  final AlbumModel? model;
  final bool lock;

  const LockScreen({
    super.key,
    required this.model,
    required this.lock,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool isNavigate = false;
  String enteredPin = '';

  void checkCredential() async {
    isNavigate = await LocalAuth.authenticate();
    if (isNavigate) {
      Timer(const Duration(seconds: 1), () {
        Utils.shared.isLockScreen = false;
        debugPrint("condition changed");
      });
      if (widget.model == null) {
        if (Utils.shared.widget == null) {
          // ignore:, use_build_context_synchronously
          Navigator.pushReplacement(context,
              AnimatedRoutes.createRoute(widget.model, widget.lock, null));
        } else {
          debugPrint("Navigate to the widget ${Utils.shared.widget}");
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Utils.shared.widget!));
        }
      } else {
        if (widget.model!.password == null) {
          return;
        } else {
          if (widget.model!.password != null && widget.lock == true) {
            Utils.shared.isInactive = true;
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageView(model: widget.model!)));
          }
        }
      }
    }
  }

  @override
  void initState() {
    if (Utils.shared.credential == false) {
      LocalAuth.checkBiometric();
      LocalAuth.getAvailableBiometrics();
      checkCredential();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Icon(
              Icons.lock,
              color: Colors.blue,
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/images/logo.png",
              height: 80,
              width: 80,
            ),
            const Spacer(),
            Text(
              Utils.shared.isAlbumLock
                  ? "Enter the album pin"
                  : Utils.shared.pin != null
                      ? "Enter the confirm pin"
                      : "Enter the pin",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 1; i <= 4; i++)
                  Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= enteredPin.length
                          ? Colors.blue
                          : Colors.grey.shade400,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 330,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      _buildButton('0'),
                      _buildButton('⌫', onPressed: _backspace),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        "cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        ));
  }

  _buildButton(String text, {VoidCallback? onPressed}) {
    return MaterialButton(
      height: 70,
      minWidth: 70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      onPressed: onPressed ?? () => _input(text),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  _input(String text) {
    setState(() {
      if (enteredPin.length < 4) {
        enteredPin += text;
      }
    });
    if (enteredPin.length == 4) {
      debugPrint("===> ${widget.model.toString()}");
      if (enteredPin == "1234" && widget.model == null) {
        Utils.shared.isLockScreen = false;
        debugPrint(Utils.shared.widget.toString());
        if (Utils.shared.widget == null) {
          debugPrint("hello 1");
          Navigator.of(context).pushReplacement(AnimatedRoutes.createRoute(
            widget.model,
            widget.lock,
            null,
          ));
        } else {
          debugPrint("hello 2");
          debugPrint(Utils.shared.widget.toString());
          Utils.shared.isAlbumLock = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Utils.shared.widget!),
          );
        }
        enteredPin = "";
      } else if (widget.model != null) {
        debugPrint(enteredPin);
        debugPrint(widget.model!.password.toString());
        if (widget.model!.password == null) {
          if (Utils.shared.pin == null) {
            Utils.shared.pin = enteredPin;
            Utils.shared.credential = true;
            debugPrint("hello 3");
            Utils.shared.navigatorKey.currentState?.pushReplacement(
              AnimatedRoutes.createRoute(
                widget.model,
                true,
                Utils.shared.pin,
              ),
            );
            enteredPin = "";
          } else {
            if (Utils.shared.pin == enteredPin) {
              widget.model!.password = Utils.shared.pin;
              Utils.shared.credential = false;
              DataHandler.setPassword(widget.model!);
              debugPrint("hello 4");
              Utils.shared.navigatorKey.currentState
                  ?.pushReplacement(AnimatedRoutes.createRoute(
                widget.model,
                true,
                null,
              ));
              Utils.shared.pin = null;
            } else {
              debugPrint("toast 1");
              _toast();
            }
          }
        } else if (enteredPin == widget.model!.password) {
          if (widget.model!.password == enteredPin && widget.lock == false) {
            debugPrint("hello 5");
            Utils.shared.navigatorKey.currentState?.pushReplacement(
                AnimatedRoutes.createRoute(widget.model, widget.lock, null));
            Utils.shared.isAlbumLock = false;
          } else {
            if (widget.model!.password == enteredPin && widget.lock == true) {
              debugPrint("hello 6");
              widget.model!.password = null;
              DataHandler.setPassword(widget.model!);
              Utils.shared.navigatorKey.currentState?.pushReplacement(
                  AnimatedRoutes.createRoute(widget.model, widget.lock, null));
            }
          }
        } else {
          debugPrint("toast 2");
          _toast();
        }
        enteredPin = "";
      } else {
        debugPrint("toast 3");
        _toast();
        enteredPin = "";
      }
    }
  }

  _backspace() {
    setState(() {
      if (enteredPin.isNotEmpty) {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      }
    });
  }

  _toast() {
    return Fluttertoast.showToast(
      msg: "Please enter the valid pin",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
