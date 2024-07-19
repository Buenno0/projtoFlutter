import 'package:flutter/material.dart';
import 'movie_list_view.dart';
import 'movie_service.dart';
import 'models/movie.dart';

void main() {
  runApp(MovieExplorerApp());
}

class MovieExplorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explorador de Filmes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MovieExplorerHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MovieExplorerHomePage extends StatefulWidget {
  @override
  _MovieExplorerHomePageState createState() => _MovieExplorerHomePageState();
}

class _MovieExplorerHomePageState extends State<MovieExplorerHomePage> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final List<Movie> fetchedMovies = await MovieService.fetchMovies();
      setState(() {
        movies = fetchedMovies;
      });
    } catch (e) {
      print('Erro ao procurar filmes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorador de filmes'),
      ),
      body: MovieListView(movies: movies),
    );
  }
}