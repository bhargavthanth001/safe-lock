import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:safe_lock/model/album_model.dart';
import 'package:safe_lock/view/image_viewer.dart';
import '../utils.dart';

class SingleView extends StatelessWidget {
  const SingleView(
      {super.key, required this.model, required this.initialIndex});

  final AlbumModel model;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Utils.shared.widget = ImageView(model: model);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: model.images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions.customChild(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Image.file(File(model.images[index]))),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
