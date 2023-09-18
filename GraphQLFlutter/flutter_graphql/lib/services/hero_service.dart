import 'package:flutter_graphql/graphql_config.dart';
import 'package:flutter_graphql/models/hero.dart';
import 'package:flutter_graphql/models/power.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HeroService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<SuperHero>> getHeroList() async {
    String document = 
    """
      query{
        superheroes{
          id
          name
          superpowers{
            superPower
          }
        }
      }
    """;
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document)
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      List? res = result.data?['superheroes'];
      if(res == null || res.isEmpty){
        return [];
      }
      List<SuperHero> heros = res.map((hero) => SuperHero.fromMap(map: hero)).toList();
      return heros;
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<List<SuperHero>> getHerosForDropdown() async {
    String document = 
    """
      query{
        superheroes{
          id
          name
        }
      }
    """;
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document)
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      List? res = result.data?['superheroes'];
      if(res == null || res.isEmpty){
        return [];
      }
      List<SuperHero> heros = res.map((hero) => SuperHero.fromMap(map: hero)).toList();
      return heros;
    } catch (e) {
      throw Exception(e);
    }
  }
 }