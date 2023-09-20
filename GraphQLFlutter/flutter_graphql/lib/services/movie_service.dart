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

  Future<Movie?> addMovie(Movie movie) async {
    String document = 
    """
      mutation(\$movie: MovieInput!){
        addMovie(movie: \$movie){
          id
          title
          releaseDate
        }
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "movie":{
                  "superheroId":  movie.superHeroId,
                  "description": movie.description,
                  "title": movie.title,
                  "instructor": movie.instructor,
                  "releaseDate": movie.releaseDate
                }
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['addMovie'];
      if(res == null || res.isEmpty){
        return null;
      }
      return Movie.fromMap(map: res);
    } catch (e) {
      throw Exception(e);
    }
  }

    Future<Movie?> updateMovie(Movie movie) async {
    String document = 
    """
      mutation(\$movie: MovieInput!){
        updateMovie(movie: \$movie){
          id
          title
          releaseDate
        }
      }
    """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(document),
          variables: {
            "movie":{
                  "id": movie.id,
                  "superheroId":  movie.superHeroId,
                  "description": movie.description,
                  "title": movie.title,
                  "instructor": movie.instructor,
                  "releaseDate": movie.releaseDate
                }
          }
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      var res = result.data?['updateMovie'];
      if(res == null || res.isEmpty){
        return null;
      }
      return Movie.fromMap(map: res);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteMovie(String? uuid) async {
    String document = 
    """
      mutation(\$uuid: UUID!){
        deleteMovie(id: \$uuid)
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
      var res = result.data?['deleteMovie'];
      if(res == null || res.isEmpty){
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

}