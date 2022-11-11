import 'package:flutter/material.dart';

import '../witgets/witgets.dart';


class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const  Icon(Icons.search_off_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: const [

          //tarjetas principales
          CardSwiper(),
          
          //Slider de peliculas
          MoviSlider()

        ],
      ),
      )
    );
  }
}