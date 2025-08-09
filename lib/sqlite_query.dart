import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openDB() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'mydb.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE recipes('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name TEXT);',
      );
    },
  );
}

Future<void> insertRecipe(String name) async {
  final db = await openDB();
  await db.insert('recipes', {'name': name});
  db.close();
}

Future<List<Map>> selectRecipes() async {
  final db = await openDB();
  final List<Map> recipes = await db.query('recipes');
  print(recipes);
  return recipes;
}
