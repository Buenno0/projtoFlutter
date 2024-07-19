import 'package:flutter/material.dart';
import 'package:projeto_final/api_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projeto_final/models/movie.dart';
import 'package:projeto_final/database/database.dart';

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
  Map<String, dynamic>? _movieDetails;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  void _loadMovieDetails() async {
    final movieDetails = await _dbHelper.getMovie(widget.movie.id);
    if (movieDetails != null) {
      setState(() {
        _movieDetails = movieDetails;
        _reviewController.text = movieDetails['userReview'] ?? '';
        _watched = movieDetails['watched'] == 1;
      });
    }
  }

  void _saveReview() async {
    await _dbHelper.insertOrUpdateMovieReview(
      widget.movie.id,
      _reviewController.text,
      _watched ? 1 : 0,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resenha salva com sucesso!')),
    );
    _loadMovieDetails();
  }

  void _deleteReview() async {
    await _dbHelper.deleteMovie(widget.movie.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resenha excluída com sucesso!')),
    );
    setState(() {
      _reviewController.clear();
      _watched = false;
      _movieDetails = null;
    });
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
                  'Avaliação: ${widget.movie.voteAverage}',
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveReview,
                  child: Text('Salvar'),
                ),
                SizedBox(width: 8.0),
                if (_movieDetails != null)
                  ElevatedButton(
                    onPressed: _deleteReview,
                    child: Text('Excluir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_movieDetails != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resenha atual:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _movieDetails!['userReview'] ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Assistido: ',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _movieDetails!['watched'] == 1
                            ? Icons.check
                            : Icons.close,
                        color: _movieDetails!['watched'] == 1
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
