import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:outfit_customizer_1/models/clothing_item.dart';
import 'package:outfit_customizer_1/models/outfit.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('wardrobe.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS outfits(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              topId INTEGER,
              bottomId INTEGER,
              shoesId INTEGER,
              extraItemIds TEXT,
              createdAt TEXT
            )
          ''');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clothing_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        color TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE outfits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        topId INTEGER,
        bottomId INTEGER,
        shoesId INTEGER,
        extraItemIds TEXT,
        createdAt TEXT
      )
    ''');
  }


  Future<int> insertClothing(ClothingItem item) async {
    final db = await instance.database;

    return await db.insert(
      'clothing_items',
      item.toMap(),
    );
  }


  Future<List<ClothingItem>> getAllClothes() async {
    final db = await instance.database;

    final result = await db.query('clothing_items');

    return result
        .map((item) => ClothingItem.fromMap(item))
        .toList();
  }

  Future<int> updateClothing(ClothingItem item) async {
    final db = await instance.database;

    return await db.update(
      'clothing_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteClothing(int id) async {
    final db = await instance.database;

    return await db.delete(
      'clothing_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ClothingItem?> getClothingById(int? id) async {

    if (id == null) return null;

    final db = await database;

    final result = await db.query(
      'clothing_items',
      where: 'id=?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return ClothingItem.fromMap(result.first);
  }


  Future<int> updateOutfit(Outfit outfit) async {

    final db = await database;

    return await db.update(

      'outfits',

      outfit.toMap(),

      where: 'id=?',

      whereArgs: [outfit.id],

    );
  }


  Future<int> insertOutfit(Outfit outfit) async {
    final db = await database;

    return await db.insert(
      'outfits',
      outfit.toMap(),
    );
  }

  Future<List<Outfit>> getAllOutfits() async {
    final db = await database;

    final maps = await db.query(
      'outfits',
      orderBy: 'createdAt DESC',
    );

    return maps
        .map((e) => Outfit.fromMap(e))
        .toList();
  }

  Future<void> deleteOutfit(int id) async {
    final db = await database;

    await db.delete(
      'outfits',
      where: 'id=?',
      whereArgs: [id],
    );
  }


}

