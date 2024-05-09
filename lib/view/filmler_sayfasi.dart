import 'package:flutter/material.dart';
import 'package:veritabani_uygulamasi/models/model_filmler.dart';
import 'package:veritabani_uygulamasi/my_extensions.dart';
import 'package:veritabani_uygulamasi/veritabani_yardimcisi.dart';

class FilmlerSayfasi extends StatefulWidget {
  const FilmlerSayfasi({super.key});

  @override
  State<FilmlerSayfasi> createState() => _FilmlerSayfasiState();
}

class _FilmlerSayfasiState extends State<FilmlerSayfasi> {
  VeritabaniYardimcisi db = VeritabaniYardimcisi();
  List<ModelFilmler> _tumFilmler = [];

  Future<void> filmleriDoldur() async {
    _tumFilmler = await db.readTumFilmler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmler'),
      ),
      body: _buildBODY(),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBODY() {
    return FutureBuilder(
      future: filmleriDoldur(),
      builder: (context, snapshot) {
        if (_tumFilmler.isNotEmpty) {
          return ListView.builder(
            itemCount: _tumFilmler.length,
            itemBuilder: (context, index) {
              ModelFilmler film = _tumFilmler[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(film.film_imdb.toString()),
                  ),
                  title: Text(film.film_adi),
                  subtitle: Text(film.film_konusu),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        List<String>? bilgiler = await _buildShowDialog();
        if (bilgiler != null) {
          String adi = bilgiler[0];
          String konu = bilgiler[1];
          ModelFilmler film = ModelFilmler(
            adi,
            konu,
            "Korku",
            2023,
            7,
          );
          await db.createFilm(film);

          setState(() {});
        } else {
          print("Bilgi yok");
        }
      },
    );
  }

  Future<List<String>?> _buildShowDialog() async {
    String? adi, konusu;
    List<String>? bilgiler;
    return await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Merhaba"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  adi = value;
                  print("adi $adi");
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Filmin Adı",
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                onChanged: (value) {
                  konusu = value;
                  print("konusu $konusu");
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Filmin Konusu",
                ),
              ),
            ],
          ),
          actions: [
            "IPTAL".elevatedButton.onPressed(() {
              Navigator.pop(context);
            }).make(context),
            "EKLE".elevatedButton.onPressed(() {
              if (adi != null && konusu != null) {
                bilgiler = [];
                bilgiler!.add(adi!);
                bilgiler!.add(konusu!);
              }
              Navigator.pop(context, bilgiler);
            }).make(context),
          ],
        );
      },
    );
  }
}
