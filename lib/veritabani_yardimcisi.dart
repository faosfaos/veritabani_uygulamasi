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
      //Veritabani yoksa uygulamanin getDatabasesPath() yoluna kopyalaniyor
      ByteData data = await rootBundle.load("lib/veritabani/$_dbName");
      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
      print("Veritabanı kopyalandı");
    }
    return openDatabase(dbPath);
  }

  //Tablo ile ilgili String degiskenler
  final String _filmlertabloAdi = "filmler";

  late Database db;

  Future<int> createFilm(ModelFilmler film) async {
    //Veritabanina erisiliyor
    db = await veritabanierisim();
    int eklenenID = await db.insert(_filmlertabloAdi, film.toMap());
    //eklenenID 0 dan buyuk ise eklenen verinin id si
    //eklenememis ise -1 donduruluyor
    return eklenenID > 0 ? eklenenID : -1;
  }

  Future<List<ModelFilmler>> readTumFilmler() async {
    //Veritabanina erisiliyor
    db = await veritabanierisim();
    //Bos filmlerListesi listesi olusturuluyor
    List<ModelFilmler> filmlerListesi = [];
    //Veritabanindan veriler getiriliyor
    List<Map<String, dynamic>> map = await db.query(_filmlertabloAdi);
    //map teki veriler ModelFilm e cevrilip filmlerListesi ne ekleniyor
    for (var i = 0; i < map.length; i++) {
      ModelFilmler film = ModelFilmler.toFilm(map[i]);
      filmlerListesi.add(film);
    }
    //filmlerListesi bos degil ise kendisi bos ise bos listes gonderiliyor
    return filmlerListesi.isNotEmpty ? filmlerListesi : [];
  }
}
