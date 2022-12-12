

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = 'f8eb2cde5414c7c6fb5c2a70b394d9f4';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es_ES';

  List<Movie> onDisplayMovies=[];
  List<Movie> popularMovies=[];


  MoviesProvider(){
    // print('MOviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  getOnDisplayMovies() async{
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key' : _apiKey,  
      'language': _language,
      'page'    : '1'
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    final nowPlayingRespone = NowPlayingResponse.fromJson(response.body);

    onDisplayMovies = nowPlayingRespone.results;

    notifyListeners();
  }

  getPopularMovies() async{
    var url = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key' : _apiKey,  
      'language': _language,
      'page'    : '1'
    });

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    final popularRespone = PopularResponse.fromJson(response.body);

    popularMovies = [ ...popularMovies, ...popularRespone.results];

    notifyListeners();    
  }




}