// To parse this JSON data, do
//
//     final creditResponse = creditResponseFromJson(jsonString);

import 'dart:convert';

import 'package:peliculas/models/models.dart';

class CreditResponse {
  int id;
  List<Cast> cast;
  List<Cast> crew;

  CreditResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CreditResponse.fromRawJson(String str) =>
      CreditResponse.fromJson(json.decode(str));

  factory CreditResponse.fromJson(Map<String, dynamic> json) => CreditResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
      );
}
