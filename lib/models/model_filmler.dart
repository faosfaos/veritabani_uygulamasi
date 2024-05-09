class ModelFilmler {
  int? id;
  String film_adi;
  String film_konusu;
  String film_kategori;
  int film_yili;
  int film_imdb;

  ModelFilmler(
    this.film_adi,
    this.film_konusu,
    this.film_kategori,
    this.film_yili,
    this.film_imdb,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "film_adi": film_adi,
      "film_konusu": film_konusu,
      "film_kategori": film_kategori,
      "film_yili": film_yili,
      "film_imdb": film_imdb,
    };
  }

  ModelFilmler.toFilm(Map<String, dynamic> map)
      : id = map["id"],
        film_adi = map["film_adi"],
        film_konusu = map["film_konusu"],
        film_kategori = map["film_kategori"],
        film_yili = map["film_yili"],
        film_imdb = map["film_imdb"];
}
