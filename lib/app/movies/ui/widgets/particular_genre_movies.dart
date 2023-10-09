import 'package:flutter/material.dart';
import 'package:movie_app/app/movies/data/models/genres.dart';
import 'package:movie_app/app/movies/data/models/movie.dart';
import 'package:movie_app/app/movies/ui/widgets/particular_genre_movie_item.dart';

class ParticularGenreMovies extends StatefulWidget {
  final ThemeData themeData;
  final String api;
  final List<Genres> genres;
  ParticularGenreMovies(
      {required this.themeData, required this.api, required this.genres});
  @override
  _ParticularGenreMoviesState createState() => _ParticularGenreMoviesState();
}

class _ParticularGenreMoviesState extends State<ParticularGenreMovies> {
  List<Movie>? moviesList;

  @override
  void initState() {
    super.initState();
    MovieList.fetch(widget.api).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  Widget _buildRepeatedMovieList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: moviesList!.length * 10,
      itemBuilder: (BuildContext context, int index) {
        final movieIndex = index % moviesList!.length;
        final movie = moviesList![movieIndex];
        return ParticularGenreMovieItem(
          themeData: widget.themeData,
          movie: movie,
          genres: widget.genres,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor.withOpacity(0.8),
      child: moviesList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildRepeatedMovieList(),
    );
  }
}
