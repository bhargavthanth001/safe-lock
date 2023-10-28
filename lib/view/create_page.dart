import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_lock/data_handler/data_handler.dart';
import 'package:safe_lock/model/album_model.dart';
import 'package:safe_lock/utils.dart';
import 'package:safe_lock/view/home_page.dart';

class AddAlbum extends StatefulWidget {
  const AddAlbum({super.key});

  @override
  State<AddAlbum> createState() => _AddAlbumState();
}

class _AddAlbumState extends State<AddAlbum> {
  final title = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        leading: IconButton(
          onPressed: () {
            Utils.shared.widget = null;
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(
            Icons.keyboard_backspace_outlined,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Icon(
                    Icons.folder_copy_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: title,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "title must needed";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide()),
                          hintText: "Enter the title",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Utils.shared.widget = null;
                          bool valid = formKey.currentState!.validate();
                          Utils.shared.isPhotos = false;
                          bool isTitleExist =
                              await DataHandler.validate(title.text);
                          if (valid) {
                            debugPrint("title is => ${DataHandler.isTitle}");
                            if (isTitleExist) {
                              Fluttertoast.showToast(
                                  msg: "title already exist");
                            } else {
                              final data = AlbumModel(
                                title: title.text,
                                images: [],
                                password: null,
                                createdAt: DateTime.now().toString(),
                              );
                              DataHandler.saveAlbum(data);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                              title.text = "";
                            }
                          } else {
                            formKey.currentState!.validate();
                          }
                        },
                        child: const Text("Add"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
