import 'package:flutter/material.dart';
import 'package:projeto_final/api_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projeto_final/models/movie.dart';
import 'package:projeto_final/database/database_helper.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();
  bool _watched = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  void _loadMovieDetails() async {
    final movieDetails = await _dbHelper.getMovie(widget.movie.id);
    if (movieDetails != null) {
      setState(() {
        _reviewController.text = movieDetails['userReview'] ?? '';
        _watched = movieDetails['watched'] == 1;
      });
    }
  }

  void _saveMovieDetails() async {
    final movieDetails = {
      'id': widget.movie.id,
      'title': widget.movie.title,
      'posterPath': widget.movie.posterPath,
      'voteAverage': widget.movie.voteAverage,
      'overview': widget.movie.overview,
      'userReview': _reviewController.text,
      'watched': _watched ? 1 : 0,
    };
    await _dbHelper.insertMovie(movieDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConfig.imageBaseUrl}${widget.movie.posterPath}',
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.movie.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                SizedBox(width: 4.0),
                Text(
                  'Avaliaçao: ${widget.movie.voteAverage}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Sobre o filme:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.movie.overview,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Sua Avaliação:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escreva sua avaliação aqui...',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _watched,
                  onChanged: (value) {
                    setState(() {
                      _watched = value!;
                    });
                  },
                ),
                Text(
                  'Já assisti',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveMovieDetails,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
