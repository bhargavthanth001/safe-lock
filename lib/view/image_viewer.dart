import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe_lock/data_handler/data_handler.dart';
import 'package:safe_lock/model/album_model.dart';
import 'package:safe_lock/utils.dart';
import 'package:safe_lock/view/home_page.dart';
import 'package:safe_lock/view/single_image_view.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:multiple_images_picker/multiple_images_picker.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key, required this.model});

  final AlbumModel model;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  List<Asset> imageAssets = [];
  bool loading = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Utils.shared.isLockScreen = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build called");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        title: Text(widget.model.title),
        leading: IconButton(
          onPressed: () {
            Utils.shared.widget = null;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          },
          icon: const Icon(Icons.keyboard_backspace_sharp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // ignore: unnecessary_null_comparison
          child: widget.model.images.isNotEmpty
              ? GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(
                    widget.model.images.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          Utils.shared.widget = SingleView(
                            model: widget.model,
                            initialIndex: index,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SingleView(
                                model: widget.model,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.all(1),
                          child: Image.file(
                            File(
                              widget.model.images[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Empty album",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.shared.isPhotos = true;
          _pickImage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _pickImage() async {
    List<Asset> resultList = [];
    List<File> files = [];
    resultList = await MultipleImagesPicker.pickImages(
      maxImages: 30,
      enableCamera: false,
      materialOptions: const MaterialOptions(
        actionBarColor: "#2196F3", //0xFF2196F3
        statusBarColor: "#2196F3",
        useDetailsView: false,
      ),
    );
    for (Asset asset in resultList) {
      final ByteData byteData = await asset.getByteData();
      final List<int> byteList = byteData.buffer.asUint8List();
      final docDir = await getApplicationDocumentsDirectory();
      final File file = File("${docDir.path}/${asset.name}");
      await file.writeAsBytes(byteList);
      debugPrint(file.toString());
      files.add(file);
    }
    List<String> imagePaths = files.map((file) => file.path).toList();
    for (int i = 0; i < imagePaths.length; i++) {
      widget.model.images.add(imagePaths[i]);
    }
    DataHandler.addImages(widget.model);
    files = [];
    setState(() {});
    debugPrint("Called...");
  }
}
