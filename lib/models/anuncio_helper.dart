import 'package:packages_persistencia/database_helper.dart';
import 'package:packages_persistencia/models/anuncio.dart';
import 'package:sqflite/sqflite.dart';

class AnuncioHelper {
  static final String tableName = 'anuncios';
  static final String idColumn = 'id';
  static final String tituloColumn = 'titulo';
  static final String descricaoColumn = 'descricao';
  static final String precoColumn = 'preco';
  static final String imagePathColumn = 'imagePath';

  static String get createScript {
    return "CREATE TABLE ${tableName}($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "$tituloColumn TEXT NOT NULL, $descricaoColumn TEXT NOT NULL, $precoColumn INTEGER NOT NULL, $imagePathColumn STRING);";
  }

  Future<Anuncio?> saveAnuncio(Anuncio anuncio) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      anuncio.id = await db.insert(tableName, anuncio.toMap());
      return anuncio;
    }
    return null;
  }

  Future<List<Anuncio>?> getAll() async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedAnuncios = await db.query(tableName, columns: [
      idColumn,
      tituloColumn,
      descricaoColumn,
      precoColumn,
      imagePathColumn
    ]);

    List<Anuncio> anuncios = List.empty(growable: true);

    for (Map anuncio in returnedAnuncios) {
      anuncios.add(Anuncio.fromMap(anuncio));
    }
    return anuncios;
  }

  Future<Anuncio?> getById(int id) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedAnuncio = await db.query(tableName,
        columns: [
          idColumn,
          tituloColumn,
          descricaoColumn,
          precoColumn,
          imagePathColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    return Anuncio.fromMap(returnedAnuncio.first);
  }

  Future<int?> editAnuncio(Anuncio anuncio) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db.update(tableName, anuncio.toMap(),
        where: "$idColumn = ?", whereArgs: [anuncio.id]);
  }

  Future<int?> deletAnuncio(Anuncio anuncio) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db
        .delete(tableName, where: "$idColumn = ?", whereArgs: [anuncio.id]);
  }
}
