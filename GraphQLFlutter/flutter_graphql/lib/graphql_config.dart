import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig{
  //static HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");
  static HttpLink httpLink = HttpLink("http://localhost:5103/graphql/");
  GraphQLClient clientToQuery() => GraphQLClient(link: httpLink, cache: GraphQLCache());
}