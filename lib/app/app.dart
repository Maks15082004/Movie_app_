import 'package:flutter/material.dart';
import 'package:movie_app/app/core/data/network/api/endpoints.dart';
import 'package:movie_app/app/movies/data/models/genres.dart';
import 'package:movie_app/app/movies/data/models/movie.dart';
import 'package:movie_app/app/movies/ui/screens/movie_detail.dart';
import 'package:movie_app/app/movies/ui/screens/settings.dart';
import 'package:movie_app/app/movies/ui/widgets/scrolling_movies.dart';
import 'package:movie_app/app/search/ui/screens/search_view.dart';
import 'package:movie_app/app/theme/theme_state.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeState>(
      create: (_) => ThemeState(),
      child: MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue, canvasColor: Colors.transparent),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Genres> _genres = [];
  @override
  void initState() {
    super.initState();
    Genres.fetch().then((value) {
      _genres = value.genres ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: state.themeData.hintColor,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            centerTitle: true,
            title: Text(
              'Movies',
              style: state.themeData.textTheme.headline5,
            ),
            backgroundColor: state.themeData.primaryColor,
            actions: <Widget>[
              IconButton(
                color: state.themeData.hintColor,
                icon: Icon(Icons.search),
                onPressed: () async {
                  final Movie? result = await showSearch<Movie?>(
                      context: context,
                      delegate: MovieSearchScreen(
                          themeData: state.themeData, genres: _genres));
                  if (result != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                                movie: result,
                                themeData: state.themeData,
                                genres: _genres,
                                heroId: '${result.id}search')));
                  }
                },
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Top Rated'),
                Tab(text: 'Upcoming Movies'),
              ],
              labelColor: Color.fromARGB(255, 132, 104, 221),
              unselectedLabelColor: Color.fromARGB(255, 69, 78, 88),
            ),
          ),
          drawer: Drawer(
            child: SettingsScreen(),
          ),
          body: Container(
            color: state.themeData.primaryColor,
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                ScrollingMoviesWidget(
                  themeData: state.themeData,
                  title: 'Top Rated',
                  api: Endpoints.topRatedUrl(1),
                  genres: _genres,
                ),
                ScrollingMoviesWidget(
                  themeData: state.themeData,
                  title: 'Upcoming Movies',
                  api: Endpoints.upcomingMoviesUrl(1),
                  genres: _genres,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
