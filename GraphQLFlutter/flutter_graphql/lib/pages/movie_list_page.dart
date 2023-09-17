import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/movie.dart';
import 'package:flutter_graphql/services/movie_service.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({ super.key });

  @override
  State<MovieListPage> createState() => _MovieListPage();
}

class _MovieListPage extends State<MovieListPage>{
  List<Movie>? _movieList;
  MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _movieList = await _movieService.getMovieList();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_movieList == null || _movieList!.isEmpty) ? 
        const Center(child: Text('Movie not found'),) : 
        ListView.builder(
          itemCount: _movieList!.length,
          itemBuilder: (context, index) => ListTile(
            title: Text('${_movieList![index].title}'),
            subtitle: Text(('${_movieList![index].releaseDate}')),
            onTap: () => {
              print('${_movieList![index].title}')
            },
            trailing: IconButton(
              onPressed: () {
                //_graphQLService.deleteBook(id: _books![index].id!);
                _load();
              },
              icon: const Icon(Icons.delete, color: Colors.red,)
            ),
          ),
        )
    );
  }

}