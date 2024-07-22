import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  // Tabelas para filmes e séries
  String moviesTable = 'moviesTable';
  String tvShowsTable = 'tvShowsTable';

  // Colunas comuns
  String colId = 'id';
  String colUserReview = 'userReview';
  String colWatched = 'watched';

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'media.db');

    final mediaDb = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return mediaDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $moviesTable(
        $colId INTEGER PRIMARY KEY, 
        $colUserReview TEXT, 
        $colWatched INTEGER
      )
      ''',
    );

    await db.execute(
      '''
      CREATE TABLE $tvShowsTable(
        $colId INTEGER PRIMARY KEY, 
        $colUserReview TEXT, 
        $colWatched INTEGER
      )
      ''',
    );
  }

  // Métodos para filmes
  Future<int> insertOrUpdateMovieReview(
    int id,
    String userReview,
    int watched,
  ) async {
    final db = await this.db;
    final movie = {
      'id': id,
      'userReview': userReview,
      'watched': watched,
    };

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

  // Métodos para séries
  Future<int> insertOrUpdateTVShowReview(
    int id,
    String userReview,
    int watched,
  ) async {
    final db = await this.db;
    final tvShow = {
      'id': id,
      'userReview': userReview,
      'watched': watched,
    };

    final existingTVShow = await getTVShow(id);
    if (existingTVShow != null) {
      return await db!.update(
        tvShowsTable,
        tvShow,
        where: '$colId = ?',
        whereArgs: [id],
      );
    } else {
      return await db!.insert(tvShowsTable, tvShow);
    }
  }

  Future<Map<String, dynamic>?> getTVShow(int id) async {
    final db = await this.db;
    final result = await db!.query(
      tvShowsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteTVShow(int id) async {
    final db = await this.db;
    final result = await db!.delete(
      tvShowsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
