import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../search/search_delegate.dart';
import '../witgets/witgets.dart';


class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: const  Icon(Icons.search_off_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [

          //tarjetas principales
          CardSwiper(movies: moviesProvider.onDisplayMovies),
          
          //Slider de peliculas
          MoviSlider(
            movies: moviesProvider.popularMovies,
            title: 'Populares!',
            onNextpage: () => moviesProvider.getPopularMovies()
          )

        ],
      ),
      )
    );
  }
}