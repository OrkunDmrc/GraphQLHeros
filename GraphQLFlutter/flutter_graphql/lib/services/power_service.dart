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

}