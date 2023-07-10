import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';

import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = 'b62e9f68ad425c0ccd9f0c010a9b4bc6';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;

  MoviesProvider() {
    print('MoviesProvider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  ///PARA ARGUMENTOS OPCIONALES ENTRE METODOS [int page = 1]
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    // var url = Uri.https(_baseUrl, '3/movie/now_playing', {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    // var url = Uri.https(_baseUrl, '3/movie/now_playing', {
    //   'api_key': _apiKey,
    //   'language': _language,
    //   'page': '1',
    // });
    // final response = await http.get(url);

    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();

    // final Map<String, dynamic> decodeData = json.decode(response.body);
    // response.statusCode==200
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromRawJson(jsonData);

    /// OPERADOR SPREED
    /// ...DESESTRUCTURAR = ES DECIR SE PUEDE ANIADIR MAS OBJETOS
    /// MANTENIENDO LOS ANTERIRORES
    /// TOMA LAS PELICULAS ACTUALES Y CONCATENA LOS RESULTADOS
    popularMovies = [...popularMovies, ...popularResponse.results];
    // print(popularMovies[0].posterPath);
    notifyListeners();
  }

  Map<int, List<Cast>> moviesCast = {};

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    // print('pidiendo info de los servidores');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditResponse = CreditResponse.fromRawJson(jsonData);
    moviesCast[movieId] = creditResponse.cast;
    return creditResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromRawJson(response.body);
    return searchResponse.results;
  }

///////////////////////////////////////////////////////////////////////////
  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final result = await this.searchMovie(value);
      this._suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
