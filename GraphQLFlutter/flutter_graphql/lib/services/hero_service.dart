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
  Future<List<SuperHero>> getHeroesForDropdown() async {
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

  Future<SuperHero?> addHero(SuperHero hero) async {
    String document = 
    """
      mutation(\$hero: SuperheroInput!){
        addSuperhero(superhero: \$hero) {
          id
          name
          superpowers{
            superPower
          }
        }
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "hero":{
                "name":  hero.name,
                "description": hero.description,
                "height": hero.height
              }
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['addSuperhero'];
      if(res == null || res.isEmpty){
        return null;
      }
      return SuperHero.fromMap(map: res);
    } catch (e) {
      throw Exception(e);
    }
  }

    Future<SuperHero?> updateHero(SuperHero hero) async {
    String document = 
    """
      mutation(\$hero: SuperheroInput!){
        updateSuperhero(superhero: \$hero) {
          id
          name
          superpowers{
            superPower
          }
        }
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "hero":{
              "id": hero.id,
              "name":  hero.name,
              "description": hero.description,
              "height": hero.height
            }
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['updateSuperhero'];
      if(res == null || res.isEmpty){
        return null;
      }
      return SuperHero.fromMap(map: res);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteHero(String? uuid) async {
    String document = 
    """
      mutation(\$uuid: UUID!){
        deleteSuperhero(id: \$uuid)
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "uuid": uuid
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['deleteSuperhero'];
      if(res == null || res.isEmpty){
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

 }