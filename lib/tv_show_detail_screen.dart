import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projeto_final/api_config.dart';
import 'package:projeto_final/models/tv_show.dart';
import 'package:projeto_final/database/database.dart';
import 'package:intl/intl.dart';

class TVShowDetailScreen extends StatefulWidget {
  final TVShow tvShow;

  const TVShowDetailScreen({required this.tvShow});

  @override
  _TVShowDetailScreenState createState() => _TVShowDetailScreenState();
}

class _TVShowDetailScreenState extends State<TVShowDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();
  bool _watched = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Map<String, dynamic>? _tvShowDetails;

  @override
  void initState() {
    super.initState();
    _loadTVShowDetails();
  }

  void _loadTVShowDetails() async {
    final tvShowDetails = await _dbHelper.getTVShow(widget.tvShow.id);
    if (tvShowDetails != null) {
      setState(() {
        _tvShowDetails = tvShowDetails;
        _reviewController.text = tvShowDetails['userReview'] ?? '';
        _watched = tvShowDetails['watched'] == 1;
      });
    }
  }

  void _saveReview() async {
    await _dbHelper.insertOrUpdateTVShowReview(
      widget.tvShow.id,
      _reviewController.text,
      _watched ? 1 : 0,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resenha salva com sucesso!')),
    );
    _loadTVShowDetails();
  }

  void _deleteReview() async {
    await _dbHelper.deleteTVShow(widget.tvShow.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resenha excluída com sucesso!')),
    );
    setState(() {
      _reviewController.clear();
      _watched = false;
      _tvShowDetails = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tvShow.name,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConfig.imageBaseUrl}${widget.tvShow.posterPath}',
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
              widget.tvShow.name,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black87,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Data de estreia: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.tvShow.firstAirDate))}',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
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
                  'Avaliação: ${widget.tvShow.voteAverage}',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Sobre a série:',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.tvShow.overview,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16.0,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Sua Avaliação:',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveReview,
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.deepPurple.shade100,
                    foregroundColor: Colors.black87,
                  ),
                ),
                SizedBox(width: 8.0),
                if (_tvShowDetails != null)
                  ElevatedButton(
                    onPressed: _deleteReview,
                    child: Text('Excluir'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.black87,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_tvShowDetails != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resenha atual:',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(160, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _tvShowDetails!['userReview'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Assistido: ',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(
                        _tvShowDetails!['watched'] == 1
                            ? Icons.check
                            : Icons.close,
                        color: _tvShowDetails!['watched'] == 1
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
