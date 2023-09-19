import 'package:flutter_graphql/graphql_config.dart';
import 'package:flutter_graphql/models/power.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PowerService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<Power>> getPowerList() async {
    String document = 
    """
      query{
        superpowers{
          id
          superPower
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
      List? res = result.data?['superpowers'];
      if(res == null || res.isEmpty){
        return [];
      }
      List<Power> powers = res.map((power) => Power.fromMap(map: power)).toList();
      return powers;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Power?> addPower(Power power) async {
    String document = 
    """
      mutation(\$power: SuperpowerInput!){
        addSuperpower(superpower: \$power){
          id
          superPower
        }
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "power":{
                  "superheroId":  power.superHeroId,
                  "description": power.description,
                  "superPower": power.superPower
                }
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['addSuperpower'];
      if(res == null || res.isEmpty){
        return null;
      }
      return Power.fromMap(map: res);
    } catch (e) {
      throw Exception(e);
    }
  }

    Future<Power?> updatePower(Power power) async {
    String document = 
    """
      mutation(\$power: SuperpowerInput!){
        updateSuperpower(superpower: \$power){
          id
          superPower
        }
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "power":{
                  "id": power.id,
                  "superheroId":  power.superHeroId,
                  "description": power.description,
                  "superPower": power.superPower
                }
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['updateSuperpower'];
      if(res == null || res.isEmpty){
        return null;
      }
      return Power.fromMap(map: res);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deletePower(String? uuid) async {
    String document = 
    """
      mutation(\$uuid: UUID!){
        deleteSuperpower(id: \$uuid)
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
      var res = result.data?['deleteSuperpower'];
      if(res == null || res.isEmpty){
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }


}