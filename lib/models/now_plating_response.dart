// To parse this JSON data, do
//
//     final nowPlayingResponse = nowPlayingResponseFromJson(jsonString);

import 'dart:convert';

import 'package:peliculas/models/models.dart';

class NowPlayingResponse {
  NowPlayingResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  ///ES UN FACTORY CONSTRUCTOR QUE RECIVE UN STRING
  ///Y CREA UNA INSTANCIA DE NowPlayingResponse.fromJson
  ///BASADO EN UN  JSON QUE RECIVE, SE PUEDE TOMAR DE UN MAPA
  factory NowPlayingResponse.fromRawJson(String str) =>
      NowPlayingResponse.fromJson(json.decode(str));

  /// tOMA TODA LA INSTANCIA DE LA CLASE Y LO CREA COMO MAPA
  // String toRawJson() => json.encode(toJson());

  ///
  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) =>
      NowPlayingResponse(
        dates: Dates.fromJson(json["dates"]),
        page: json["page"],
        results:
            List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  /*  Map<String, dynamic> toJson() => {
        "dates": dates.toJson(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      }; */
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromRawJson(String str) => Dates.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  /* Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      }; */
}
