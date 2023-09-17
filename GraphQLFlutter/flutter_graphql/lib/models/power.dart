import 'package:flutter_graphql/models/hero.dart';

class Power{
  final String? id;
  final String? superPower;
  final String? description;
  final String? superHeroId;
  final SuperHero? superHero;
  Power({
    this.id,
    this.superPower,
    this.description,
    this.superHeroId,
    this.superHero,
  });
  static Power fromMap({required Map<String, dynamic> map}) => Power(
    id: map['id'],
    superPower: map['superPower'],
    description: map['description'],
    superHeroId: map['superHeroId'],
    superHero: map['superHero'],
  );
}