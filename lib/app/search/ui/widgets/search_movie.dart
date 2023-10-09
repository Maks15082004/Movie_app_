import 'package:flutter/material.dart';
import 'package:movie_app/app/core/data/network/api/endpoints.dart';
import 'package:movie_app/app/movies/data/models/genres.dart';
import 'package:movie_app/app/movies/data/models/movie.dart';
import 'package:movie_app/app/movies/ui/widgets/particular_genre_movie_item.dart';

class SearchMovieWidget extends StatefulWidget {
  final ThemeData? themeData;
  final String? query;
  final List<Genres>? genres;
  final Function(Movie)? onTap;
  SearchMovieWidget({this.themeData, this.query, this.genres, this.onTap});
  @override
  _SearchMovieWidgetState createState() => _SearchMovieWidgetState();
}

class _SearchMovieWidgetState extends State<SearchMovieWidget> {
  List<Movie>? moviesList;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    MovieList.fetch(Endpoints.movieSearchUrl(widget.query!)).then((value) {
      setState(() {
        moviesList = value;
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  Widget _buildRepeatedMovieList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: moviesList!.length * 10,
      itemBuilder: (BuildContext context, int index) {
        final movieIndex = index % moviesList!.length;
        final movie = moviesList![movieIndex];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              widget.onTap!(movie);
            },
            child: ParticularGenreMovieItem(
              themeData: widget.themeData!,
              movie: movie,
              genres: widget.genres!,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData!.primaryColor,
      child: moviesList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : moviesList!.length == 0
              ? Center(
                  child: Text(
                    "Oops! couldn't find the movie",
                    style: widget.themeData!.textTheme.bodyText1,
                  ),
                )
              : _buildRepeatedMovieList(),
    );
  }
}
