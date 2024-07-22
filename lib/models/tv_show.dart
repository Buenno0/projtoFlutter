class TVShow {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage; 
  final String firstAirDate; 
 

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.firstAirDate,

  });

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(),
      firstAirDate: json['first_air_date'],
    );
  }
}

