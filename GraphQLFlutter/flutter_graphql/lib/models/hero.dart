import 'package:flutter_graphql/models/movie.dart';
import 'package:flutter_graphql/models/power.dart';

class SuperHero{
  final String? id;
  final String? name;
  final String? description;
  final double? height;
  final List<Power>? superpowers;
  final List<Movie>? movies;
  SuperHero({
    this.id,
    this.name,
    this.description,
    this.height,
    this.superpowers,
    this.movies,
  });
  static SuperHero fromMap({required Map<String, dynamic> map}) => SuperHero(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    height: map['height'],
    superpowers: _convertDynamicToPowerList(map['superpowers']?.map((e) => Power.fromMap(map: e)).toList()),
    movies: map['movie']?.map((e) => Movie.fromMap(map: e)).toList(),
  );
  static List<Power>? _convertDynamicToPowerList(List? dynemicList){
    if(dynemicList != null){
      List<Power>? powers = [];
      dynemicList.forEach((element) {
        powers.add(element as Power);
      });
      return powers;
    }
    return null;
  }
  static List<Movie>? _convertDynamicToMovieList(List? dynemicList){
    if(dynemicList != null){
      List<Movie>? movies = [];
      dynemicList.forEach((element) {
        movies.add(element as Movie);
      });
      return movies;
    }
    return null;
  }
}