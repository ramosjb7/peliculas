

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = 'f8eb2cde5414c7c6fb5c2a70b394d9f4';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es_ES';

  List<Movie> onDisplayMovies=[];
  List<Movie> popularMovies=[];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;


  MoviesProvider(){
    // print('MOviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1])async{
    var url = Uri.https(_baseUrl, endpoint, {
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




}