class ModelFilmler {
  //Veritabanindaki filmler tablosunun alanlarinin aynisi olusturuyoruz
  int? id;
  String film_adi;
  String film_konusu;
  String film_kategori;
  int film_yili;
  int film_imdb;

  //constructor (Yapici metod) u tanimliyoruz
  ModelFilmler(
    this.film_adi,
    this.film_konusu,
    this.film_kategori,
    this.film_yili,
    this.film_imdb,
  );
  //ModelFilmler i map a ceviriyoruz
  //Veritabanina kayededilirken kullanilacak
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

  //Parametre ile verilen map i ModelFilm e ceviriyoruz
  //Veritabanindan alinan verilerin ModelFilmler e cevrilmesinde kullanilacak
  ModelFilmler.toFilm(Map<String, dynamic> map)
      : id = map["id"],
        film_adi = map["film_adi"],
        film_konusu = map["film_konusu"],
        film_kategori = map["film_kategori"],
        film_yili = map["film_yili"],
        film_imdb = map["film_imdb"];
}
