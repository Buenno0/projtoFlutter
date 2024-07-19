import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String moviesTable = 'moviesTable';
  String colId = 'id';
  String colTitle = 'title';
  String colPosterPath = 'posterPath';
  String colVoteAverage = 'voteAverage';
  String colOverview = 'overview';
  String colUserReview = 'userReview';
  String colWatched = 'watched';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');

    final moviesDb = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return moviesDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $moviesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colPosterPath TEXT, $colVoteAverage DOUBLE, $colOverview TEXT, $colUserReview TEXT, $colWatched INTEGER)',
    );
  }

  Future<int> insertMovie(Map<String, dynamic> movie) async {
    final db = await this.db;
    final result = await db!.insert(moviesTable, movie);
    return result;
  }

  Future<Map<String, dynamic>?> getMovie(int id) async {
    final db = await this.db;
    final result = await db!.query(
      moviesTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateMovie(Map<String, dynamic> movie) async {
    final db = await this.db;
    final result = await db!.update(
      moviesTable,
      movie,
      where: '$colId = ?',
      whereArgs: [movie[colId]],
    );
    return result;
  }
}
