import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'models/tv_show.dart'; // Certifique-se de que você tenha um modelo TVShow

class TVShowService {
  static Future<List<TVShow>> fetchTopRatedTVShows() async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/tv/top_rated?api_key=${ApiConfig.apiKey}&language=${ApiConfig.language}',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => TVShow.fromJson(json)).toList();
    } else {
      throw Exception('Falha em buscar as séries');
    }
  }
}
