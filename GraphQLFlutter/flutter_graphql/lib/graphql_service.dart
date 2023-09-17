import 'package:flutter_graphql/book_model.dart';
import 'package:flutter_graphql/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService{
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<BookModel>> getBooks({required int limit}) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          /*document: gql(
            """
              query Query(\$limit: Int){
                getBooks(limit: \$limit){
                  _id
                  author
                  title
                  year
                }
              }
            """),*/
            /*document: gql("""
              query GetContinent{
                        continents{
                        name
                        countries{
                            name
                            code
                        }
                        }
                    }

            """)*/
            document: gql("""
                query {
                  superheroes {
                    id
                    name
                  }
                }
            """)
            /*variables:{
              "limit": limit
            }*/
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }
      List? res = result.data?['getBooks'];
      if(res == null || res.isEmpty){
        return [];
      }

      List<BookModel> books = res.map((book) => BookModel.fromMap(map: book)).toList();
      return books;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteBook({required String id}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              muttion Mutation(\$id: ID!){
                deleteBook(ID: \$id)
              }
            """),
            variables:{
              "id": id
            } 
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }else{
        return true;
      }
    
    } catch (e) {
      return false;
    }
  }

  Future<bool> createBook({required String title, required String author, required int year}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              muttion Mutation(\$bookInput: BookInput){
                createBook(bookInput: \$bookInput)
              }
            """),
            variables:{
              "bookInput": {
                "author": author,
                "title": title,
                "year": year
              }
            } 
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }else{
        return true;
      }
    
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBook({required String id, required String title, required String author, required int year}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              muttion Mutation(\$id: ID! ,\$bookInput: BookInput){
                updateBook(ID: \$id, bookInput: \$bookInput)
              }
            """),
            variables:{
              "id": id,
              "bookInput": {
                "author": author,
                "title": title,
                "year": year
              }
            } 
        )
      );
      if(result.hasException){
        throw Exception(result.exception);
      }else{
        return true;
      }
    
    } catch (e) {
      return false;
    }
  }


}