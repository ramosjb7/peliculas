

import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      Text('buildAccions')
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Text('buildLeading');
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('buildSuggestions: $query');
  }

}