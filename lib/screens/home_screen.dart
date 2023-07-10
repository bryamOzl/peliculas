import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/widgets/widgets.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/providers/movies_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    // print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: Icon(
              CupertinoIcons.search,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tarjetas principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            // Slider de peliculas
            MovieSlider(
              popularMovies: moviesProvider.popularMovies,
              title: 'Populares',
              oneNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
