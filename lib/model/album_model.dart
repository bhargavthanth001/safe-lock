import 'dart:convert';

// ignore: non_constant_identifier_names
AlbumModel AlbumModelFromJson(String str) =>
    AlbumModel.fromJson(json.decode(str));

// ignore: non_constant_identifier_names
String AlbumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
  String title;
  List<String> images;
  String? password;
  String createdAt;

  AlbumModel({
    required this.title,
    required this.images,
    required this.password,
    required this.createdAt,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      title: json["title"],
      images: List<String>.from(json["images"].map((x) => x)),
      password: json["password"],
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "images": List<dynamic>.from(images.map((x) => x)),
        "password": password,
        "createdAt": createdAt,
      };
}
