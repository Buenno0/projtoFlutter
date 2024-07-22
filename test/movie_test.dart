import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

import 'package:projeto_final/api_config.dart';
import 'package:projeto_final/movie_service.dart';

// Crie uma classe MockClient
class MockClient extends Mock implements http.Client {}

void main() async {
  // Instancie o MockClient
  final client = MockClient();

  // Simula uma resposta HTTP bem-sucedida com uma lista de filmes
  when(client.get(
    Uri.parse('${ApiConfig.baseUrl}/movie/popular?api_key=${ApiConfig.apiKey}&language=${ApiConfig.language}'),
  )).thenAnswer((_) async => http.Response(
    jsonEncode({
      'results': [
        {
          'id': 1,
          'title': 'Inception',
          'overview': 'A mind-bending thriller about dreams within dreams.',
          'poster_path': '/poster_path.jpg',
          'vote_average': 8.8,
          'release_date': '2010-07-16',
          'genres': [
            {'name': 'Action'},
            {'name': 'Science Fiction'}
          ],
          'runtime': 148
        }
      ]
    }),
    200,
  ));

  // Use o cliente simulado para chamar a função fetchMovies
  final movies = await MovieService.fetchMovies();

  // Imprime as variáveis para ver o que está sendo retornado
  for (var movie in movies) {
    print('Title: ${movie.title}');
    print('Overview: ${movie.overview}');
    print('Poster Path: ${movie.posterPath}');
    print('Vote Average: ${movie.voteAverage}');
    print('Release Date: ${movie.releaseDate}');
    print('Genres: ${movie.genres}');
    print('Runtime: ${movie.runtime}');
  }
}
