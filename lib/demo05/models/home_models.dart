class Person {
  String name;
  String avatarUrl;

  Person.fromMap(Map<String, dynamic> map)
    : name = map['name'],
      avatarUrl = map['avatarUrl'];
}

class Actor extends Person {
  Actor.fromMap(super.map) : super.fromMap();
}

class Director extends Person {
  Director.fromMap(super.map) : super.fromMap();
}

int counter = 1;

class MovieItem {
  late int rank;
  late String imageURL;
  late String title;
  late String playDate;
  late double rating;
  late List<String> genres;
  late List<String> casts;
  late Director director;
  late String originalTitle;

  MovieItem.fromMap(Map<String, dynamic> map) {
    rank = counter++;
    imageURL = map['imageURL'];
    title = map['title'];
    playDate = map['playDate'];
    rating = map['rating'];
    casts = List<String>.from(map['casts'].map((item) => item["name"]));
    genres = map['genres'];
    director = Director.fromMap(map['director']);
    originalTitle = map['originalTitle'];
  }
}
