import 'package:flutter/material.dart';
import 'package:movie_app/app/core/data/network/api/constants.dart';
import 'package:movie_app/app/movies/data/models/genres.dart';
import 'package:movie_app/app/movies/data/models/movie.dart';
import 'package:movie_app/app/movies/ui/screens/movie_detail.dart';

class ParticularGenreMovieItem extends StatelessWidget {
  final ThemeData themeData;
  final Movie movie;
  final List<Genres> genres;

  ParticularGenreMovieItem({
    required this.themeData,
    required this.movie,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(
                movie: movie,
                themeData: themeData,
                genres: genres,
                heroId: '${movie.id}',
              ),
            ),
          );
        },
        child: Container(
          height: 150,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeData.primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 1,
                      color: themeData.hintColor,
                    ),
                  ),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 118.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          movie.title!,
                          style: themeData.textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 0.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                movie.voteAverage!,
                                style: themeData.textTheme.bodyText1,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 8,
                child: Hero(
                  tag: '${movie.id}',
                  child: SizedBox(
                    width: 100,
                    height: 125,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage(
                        image: NetworkImage(
                            TMDB_BASE_IMAGE_URL + 'w500/' + movie.posterPath!),
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/images/loading.gif'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
