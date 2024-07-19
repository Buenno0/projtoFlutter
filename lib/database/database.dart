import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String moviesTable = 'moviesTable';
  String colId = 'id';
  String colUserReview = 'userReview';
  String colWatched = 'watched';

  Future<Database?> get db async {
    _db ??= await _initDb();
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
      'CREATE TABLE $moviesTable($colId INTEGER PRIMARY KEY, $colUserReview TEXT, $colWatched INTEGER)',
    );
  }

  Future<int> insertOrUpdateMovieReview(int id, String userReview, int watched) async {
    final db = await this.db;
    final movie = {'id': id, 'userReview': userReview, 'watched': watched};

    final existingMovie = await getMovie(id);
    if (existingMovie != null) {
      return await db!.update(
        moviesTable,
        movie,
        where: '$colId = ?',
        whereArgs: [id],
      );
    } else {
      return await db!.insert(moviesTable, movie);
    }
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

  Future<int> deleteMovie(int id) async {
    final db = await this.db;
    final result = await db!.delete(
      moviesTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}

