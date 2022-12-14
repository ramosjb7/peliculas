

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/search_response.dart';
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = 'f8eb2cde5414c7c6fb5c2a70b394d9f4';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es_ES';

  List<Movie> onDisplayMovies=[];
  List<Movie> popularMovies=[];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionsStreamControler = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionsStreamControler.stream;



  MoviesProvider(){
    // print('MOviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1])async{
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,  
      'language': _language,
      'page'    : '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    return response.body;
  }

  

  getOnDisplayMovies() async{
    
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingRespone = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingRespone.results;

    notifyListeners();
  }



  getPopularMovies() async{
    _popularPage ++; 
    
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularRespone = PopularResponse.fromJson(jsonData);

    popularMovies = [ ...popularMovies, ...popularRespone.results];

    notifyListeners();    
  }

  Future<List<Cast>> getMovieCast(int movieId)async{

    if(movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovie(String query) async{

    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key' : _apiKey,  
      'language': _language,
      'query'   : query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;

  }

  void getSuggestionByQuery(String searchTerm){

    debouncer.value = '';
    debouncer.onValue = (value)async{
      final results = await searchMovie(value);
      _suggestionsStreamControler.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 

      debouncer.value = searchTerm;

    });

    Future.delayed(const Duration(milliseconds: 301)).then((value) => timer.cancel());

  }






}