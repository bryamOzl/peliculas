import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider({
    Key? key,
    required this.popularMovies,
    this.title,
    required this.oneNextPage,
  }) : super(key: key);

  final List<Movie> popularMovies;
  final String? title;
  final Function oneNextPage;

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // print(scrollController.position.pixels);
      // print(scrollController.position.maxScrollExtent);
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        // print('Obtener siguiente pagina');
        widget.oneNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (this.widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                this.widget.title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.popularMovies.length,
              itemBuilder: (_, int index) => _MoviePoster(
                movie: widget.popularMovies[index],
                heroId:
                    '${widget.title}-$index-${widget.popularMovies[index].id}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({
    Key? key,
    required this.movie,
    required this.heroId,
  }) : super(key: key);

  final Movie movie;
  final String heroId;

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      // color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage('${movie.fullPosterImg}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100),
            child: Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
