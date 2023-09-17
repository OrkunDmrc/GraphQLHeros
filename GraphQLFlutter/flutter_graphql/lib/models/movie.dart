import 'package:flutter_graphql/models/hero.dart';

class Movie{
  final String? id;
  final String? title;
  final String? description;
  final String? instructor;
  final String? releaseDate;
  final String? superHeroId;
  final SuperHero? superHero;
  Movie({
    this.id,
    this.title,
    this.description,
    this.instructor,
    this.releaseDate,
    this.superHeroId,
    this.superHero,
  });
  static Movie fromMap({required Map map}) => Movie(
    id: map['id'],
    title:map['title'],
    description:map['description'],
    instructor:map['instructor'],
    releaseDate:map['releaseDate'],
    superHeroId:map['supoerHeroId'],
    superHero:map['hero'],
  );
}