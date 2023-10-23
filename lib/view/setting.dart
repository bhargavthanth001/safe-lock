import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_lock/data_handler/data_handler.dart';
import 'package:safe_lock/view/home_page.dart';
import '../model/album_model.dart';
import '../utils.dart';
import 'lock_screen.dart';

class SettingPage extends StatefulWidget {
  final AlbumModel albumModel;

  const SettingPage({super.key, required this.albumModel});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Utils.shared.isLockScreen = false;
      debugPrint("condition changed");
    });
    Utils.shared.isInactive = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int countImage = widget.albumModel.images.isNotEmpty
        ? widget.albumModel.images.length - 1
        : 0;
    debugPrint("Model name is => ${widget.albumModel}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumModel.title),
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        leading: IconButton(
          onPressed: () {
            Utils.shared.isLockScreen = false;
            Utils.shared.widget = null;
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.keyboard_backspace_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  image: widget.albumModel.images.isEmpty
                      ? const DecorationImage(
                          image: AssetImage("assets/images/placeholder.png"))
                      : DecorationImage(
                          image: FileImage(
                            File(
                              widget.albumModel.images.last,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        color: Colors.black.withOpacity(0.7)),
                    child: Text(
                      "+ ${countImage.toString()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: const Text("Lock"),
                  trailing: Switch(
                    // This bool value toggles the switch.
                    value: widget.albumModel.password != null,
                    activeColor: Colors.green,
                    onChanged: (bool value) {
                      Utils.shared.isLockScreen = true;
                      Utils.shared.isInactive = true;
                      debugPrint("-> ${widget.albumModel.toString()}");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LockScreen(
                            model: widget.albumModel,
                            lock: widget.albumModel.password != null
                                ? true
                                : false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: _dialog,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _dialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Album"),
            content:
                const Text("Do you want to remove this album from Safe Lock ?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    DataHandler.removeAlbum(widget.albumModel);
                    Utils.shared.isLockScreen = false;
                    Utils.shared.widget = null;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false);
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }
}
