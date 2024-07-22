class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<Genre> genres; // Lista de objetos Genre
  final int runtime;
  

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.runtime,
  });

 factory Movie.fromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['id'],
    title: json['title'],
    overview: json['overview'],
    posterPath: json['poster_path'] ?? '',
    voteAverage: (json['vote_average'] as num).toDouble(),
    releaseDate: json['release_date'] ?? '',
    genres: json['genres'] != null
        ? List<Genre>.from(json['genres'].map((x) => Genre.fromJson(x)))
        : [],
    runtime: json['runtime'] ?? 0,
  );
}

}
