import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:veritabani_uygulamasi/models/model_filmler.dart';

class VeritabaniYardimcisi {
  VeritabaniYardimcisi._privateConstructor();

  static final VeritabaniYardimcisi _nesne =
      VeritabaniYardimcisi._privateConstructor();

  factory VeritabaniYardimcisi() {
    return _nesne;
  }

  static const _dbName = "filmler.db";
  static Future<Database> veritabanierisim() async {
    String dbPath = join(await getDatabasesPath(), _dbName);
    if (await databaseExists(dbPath)) {
      print("Veritabanı var");
    } else {
      ByteData data = await rootBundle.load("lib/veritabani/$_dbName");
      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
      print("Veritabanı kopyalandı");
    }
    return openDatabase(dbPath);
  }

  final String _filmlertabloAdi = "filmler";

  Database? db;

  Future<int> createFilm(ModelFilmler film) async {
    db = await veritabanierisim();
    if (db != null) {
      int eklenenID = await db!.insert(_filmlertabloAdi, film.toMap());
      return eklenenID;
    } else {
      return -1;
    }
  }

  Future<List<ModelFilmler>> readTumFilmler() async {
    db = await veritabanierisim();
    List<ModelFilmler> filmlerListesi = [];
    if (db != null) {
      List<Map<String, dynamic>> map = await db!.query(_filmlertabloAdi);

      for (var i = 0; i < map.length; i++) {
        ModelFilmler film = ModelFilmler.toFilm(map[i]);
        filmlerListesi.add(film);
      }
      return filmlerListesi;
    } else {
      return [];
    }
  }
}
