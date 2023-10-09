import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/app/core/data/network/api/endpoints.dart';

class GenresList {
  List<Genres>? genres;

  GenresList({this.genres});

  GenresList.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = [];
      json['genres'].forEach((v) {
        genres?.add(new Genres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genres != null) {
      data['genres'] = this.genres?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Genres {
  int? id;
  String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  static Future<GenresList> fetch() async {
    GenresList genresList;
    var res = await http.get(Uri.parse(Endpoints.genresUrl()));
    var decodeRes = jsonDecode(res.body);
    genresList = GenresList.fromJson(decodeRes);
    return genresList;
  }
}
