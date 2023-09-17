import 'package:flutter_graphql/graphql_config.dart';
import 'package:flutter_graphql/models/movie.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MovieService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<Movie>> getMovieList() async {
    String document = 
    """
      query {
        movies{
          id
          title
          releaseDate
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
      List? res = result.data?['movies'];
      if(res == null || res.isEmpty){
        return [];
      }
      List<Movie> movies = res.map((movie) => Movie.fromMap(map: movie)).toList();
      return movies;
    } catch (e) {
      throw Exception(e);
    }
  }

}