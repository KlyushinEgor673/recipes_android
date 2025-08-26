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
        'name TEXT,'
        'images TEXT DEFAULT "[]",'
        'description TEXT DEFAULT ""'
        ');',
      );
    },
  );
}

Future<bool> insertRecipe(String name) async {
  final db = await openDB();
  final List<Map> recipes = await db.query(
    'recipes',
    where: 'name = ?',
    whereArgs: [name],
  );
  if (recipes.length == 0){
    await db.insert('recipes', {'name': name});
    return true;
  }
  return false;
  // db.close();
}

Future<List<Map>> selectRecipes() async {
  final db = await openDB();
  final List<Map> recipes = await db.query('recipes');
  // db.close();
  return recipes;
}

Future<void> deleteRecipe(int id) async {
  final db = await openDB();
  await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  // db.close();
}

Future<void> updateRecipe(int id, String newName) async {
  final db = await openDB();
  await db.update(
    'recipes',
    {'name': newName},
    where: 'id = ?',
    whereArgs: [id],
  );
  // db.close();
}

// Future<void> updateImages(int id, String images) async {
//   final db = await openDB();
//   await db.update(
//     'recipes',
//     {'images': images},
//     where: 'id = ?',
//     whereArgs: [id],
//   );
//   // db.close();
// }

Future<void> updateDescription(int id, String description) async {
  final db = await openDB();
  await db.update(
    'recipes',
    {'description': description},
    where: 'id = ?',
    whereArgs: [id],
  );
  // db.close();
}
