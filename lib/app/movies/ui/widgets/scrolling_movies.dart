import 'package:flutter/material.dart';
import 'package:movie_app/app/movies/data/models/genres.dart';
import 'package:movie_app/app/movies/data/models/movie.dart';
import 'package:movie_app/app/movies/ui/widgets/particular_genre_movie_item.dart';

class ScrollingMoviesWidget extends StatefulWidget {
  final ThemeData themeData;
  final String? api, title;
  final List<Genres> genres;
  ScrollingMoviesWidget(
      {required this.themeData, this.api, this.title, required this.genres});
  @override
  _ScrollingMoviesWidgetState createState() => _ScrollingMoviesWidgetState();
}

class _ScrollingMoviesWidgetState extends State<ScrollingMoviesWidget> {
  List<Movie>? moviesList;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    MovieList.fetch(widget.api!).then((value) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Text(widget.title!, style: widget.themeData.textTheme.headline5),
        ),
        Expanded(
          child: moviesList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildRepeatedMovieList(),
        ),
      ],
    );
  }
}
