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
  final String _idFilm = "id";
  final String _adFilm = "film_adi";
  final String _konuFilm = "film_konusu";
  final String _kategoriFilm = "film_kategori";
  final String _yilFilm = "film_yili";
  final String _imdbFilm = "film_imdb";

  late Database db;
  //CRUD OPERASYONLAR
  //1-Create
  Future<int> createFilm(ModelFilmler film) async {
    //Veritabanina erisiliyor
    db = await veritabanierisim();
    int eklenenID = await db.insert(_filmlertabloAdi, film.toMap());
    //eklenenID 0 dan buyuk ise eklenen verinin id si
    //eklenememis ise -1 donduruluyor
    return eklenenID > 0 ? eklenenID : -1;
  }

  //2-Read
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

  //3- Update
  Future<int> updateFilm(ModelFilmler film) async {
    //Veritabanina erisiliyor
    db = await veritabanierisim();
    int count = await db.update(
      _filmlertabloAdi,
      film.toMap(),
      where: "$_idFilm=?",
      whereArgs: [film.id],
    );
    //count 0 dan büyük ise en az bir veri güncellenmiştir
    // degilse bir hata olusmustur. Hata  olusmus ise 0 geri donduruyoruz
    return count > 0 ? count : 0;
  }

  //4- Delete

  void deleteFilm(int id) async {
    //Veritabanina erisiliyor
    db = await veritabanierisim();
    db.delete(
      _filmlertabloAdi,
      where: "$_idFilm=?",
      whereArgs: [id],
    );
  }
}
