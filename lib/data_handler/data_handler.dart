import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/album_model.dart';

class DataHandler {
  SharedPreferences? preferences;
  static const key = "albums";
  static bool isTitle = false;

  static Future<void> saveAlbum(AlbumModel albumModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingList = prefs.getStringList(key) ?? [];
    String encodedData = jsonEncode(albumModel.toJson());
    debugPrint("this  is the data => $encodedData");
    existingList.add(encodedData);
    await prefs.setStringList(key, existingList);
  }

  static Future<List<AlbumModel>?> getAlbums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedData = prefs.getStringList(key) ?? [];
    debugPrint("get data is :- $encodedData");
    List<AlbumModel> albumList = [];

    for (var i = 0; i < encodedData.length; i++) {
      debugPrint("hello $i");
      AlbumModel data = AlbumModel.fromJson(jsonDecode(encodedData[i]));
      debugPrint("This is the code");
      albumList.add(data);
      debugPrint("album list is => ${albumList[i].toString()}");
    }
    debugPrint("album is => ${albumList.toString()}");
    if (albumList.isNotEmpty) {
      return albumList;
    } else {
      return null;
    }
  }

  static Future<void> setPassword(AlbumModel data) async {
    List<AlbumModel>? albumModels = await getAlbums();

    int index = albumModels!.indexWhere((model) => model.title == data.title);

    if (index != -1) {
      albumModels[index].password = data.password;
      debugPrint("This is the => ${albumModels[index].toJson()}");
      List<String> modelStrings = albumModels.map((model) {
        return jsonEncode(model.toJson());
      }).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, modelStrings);
    }
  }

  static Future<void> addImages(AlbumModel data) async {
    List<AlbumModel>? albumModels = await getAlbums();

    int index = albumModels!.indexWhere((model) => model.title == data.title);

    if (index != -1) {
      albumModels[index].images = data.images;
      debugPrint("This is the => ${albumModels[index].toJson()}");
      List<String> modelStrings = albumModels.map((model) {
        return jsonEncode(model.toJson());
      }).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, modelStrings);
    }
  }

  static Future<void> removeAlbum(AlbumModel data) async {
    List<AlbumModel>? albumModels = await getAlbums();

    int index = albumModels!.indexWhere((model) => model.title == data.title);

    if (index != -1) {
      albumModels.removeAt(index);
      List<String> modelStrings = albumModels.map((model) {
        return jsonEncode(model.toJson());
      }).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, modelStrings);
    }
  }

  static Future<bool> validate(String title) async {
    try {
      List<AlbumModel>? albumModels = await getAlbums();

      if (albumModels == null) {
        return false;
      }
      int index = albumModels.indexWhere((model) => model.title == title);

      if (index != -1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error in validate: $e");
      return false;
    }
  }

  void remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
