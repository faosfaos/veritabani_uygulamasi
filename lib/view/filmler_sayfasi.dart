import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
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
    //Veritabanindan tüm filmler getirliyor
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
        //_tumFilmler listesi bos degilse
        if (_tumFilmler.isNotEmpty) {
          return ListView.builder(
            itemCount: _tumFilmler.length,
            itemBuilder: (context, index) {
              ModelFilmler film = _tumFilmler[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(film.id.toString()),
                  ),
                  title: Text(film.film_adi),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(film.film_konusu),
                      Text("IMDB: ${film.film_imdb}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          List<String>? bilgiler = await _buildShowDialog(
                              "Güncelle",
                              gelenAd: _tumFilmler[index].film_adi,
                              gelenKonu: _tumFilmler[index].film_konusu);
                          if (bilgiler != null) {
                            String ad = bilgiler[0];
                            String konu = bilgiler[1];
                            ModelFilmler film = _tumFilmler[index];
                            film.film_adi = ad;
                            film.film_konusu = konu;
                            db.updateFilm(film);
                            setState(() {});
                          } else {
                            print("Güncelleme yapılmadı");
                          }
                        },
                        icon: const Icon(
                          Icons.edit_document,
                          color: Colors.purple,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _buildshowModalBottomSheet(
                              _tumFilmler[index].film_adi,
                              _tumFilmler[index].id!);
                          /*  db.deleteFilm(_tumFilmler[index].id!);
                          setState(() {}); */
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.pink[400],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            //_tumFilmler listesi bos ise
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
        List<String>? bilgiler = await _buildShowDialog("Ekle");
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

  Future<List<String>?> _buildShowDialog(
    String title, {
    String? gelenAd,
    String? gelenKonu,
  }) async {
    List<String>? bilgiler;

    TextEditingController tfAd = TextEditingController(text: gelenAd);
    TextEditingController tfKonu = TextEditingController(text: gelenKonu);
    return await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                //FilmAdı
                controller: tfAd,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Filmin Adı",
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                //FilmKonusu
                controller: tfKonu,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Filmin Konusu",
                ),
              ),
            ],
          ),
          actions: [
            "IPTAL".elevatedButton.backgroundColor(Colors.green).onPressed(() {
              Navigator.pop(context);
            }).make(context),
            title.elevatedButton.backgroundColor(Colors.red).onPressed(() {
              if (tfAd.text.isNotEmptyAndNotNull &&
                  tfKonu.text.isNotEmptyAndNotNull) {
                bilgiler = [];
                bilgiler!.add(tfAd.text);
                bilgiler!.add(tfKonu.text);
              }
              Navigator.pop(context, bilgiler);
            }).make(context),
          ],
        );
      },
    );
  }

  void _buildshowModalBottomSheet(String filmIsim, int id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* filmIsim.text.xl3.bold.white
                .makeCentered()
                .box
                .color(Colors.purple)
                .width(context.screenWidth)
                .make(), */
            [
              ('"$filmIsim" silinecek,\nOnaylıyor musunuz?')
                  .text
                  .bold
                  .xl2
                  .make(),
              "SİL"
                  .elevatedButton
                  .border(
                    strokeAlign: 3,
                    color: Colors.red[300]!,
                    width: 2,
                  )
                  .backgroundColor(Colors.red)
                  .onPressed(() async {
                db.deleteFilm(id);
                Navigator.pop(context);
                setState(() {});
              }).make(context),
            ].hStack(alignment: MainAxisAlignment.spaceAround).p(20)
          ],
        );
      },
    );
  }
}
