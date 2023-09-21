import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/hero.dart';
import 'package:flutter_graphql/models/movie.dart';
import 'package:flutter_graphql/services/hero_service.dart';
import 'package:flutter_graphql/services/movie_service.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({ super.key });

  @override
  State<MovieListPage> createState() => _MovieListPage();
}

class _MovieListPage extends State<MovieListPage>{
  List<Movie>? _movieList;
  final MovieService _movieService = MovieService();
  final HeroService _heroService = HeroService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _titleFieldKey = GlobalKey();
  final GlobalKey<FormFieldState> _descriptionFieldKey = GlobalKey();
  final GlobalKey<FormFieldState> _instructorFieldKey = GlobalKey();
  DateTime _releasedDate = DateTime.now();
  late List<SuperHero>? _powerHeros;
  late SuperHero? _heroDropdownValue;
  

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _movieList = await _movieService.getMovieList();
    _powerHeros = await _heroService.getHeroesForDropdown();
    _heroDropdownValue = _powerHeros?.first;
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
              print('Hooop')
            },
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: (context), 
                      builder: (content) {
                        return AlertDialog(
                          title: const Text('Update Movie'),
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  key: _titleFieldKey,
                                  maxLength: 50,
                                  decoration: const InputDecoration(labelText: 'Title'),
                                  validator: (val) {
                                    return (val == null || val.isEmpty) ? 'Please enter the title' : null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  key: _descriptionFieldKey,
                                  maxLength: 50,
                                  decoration: const InputDecoration(labelText: 'Description'),
                                  validator: (val) {
                                    return (val == null || val.isEmpty) ? 'Please enter the description' : null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  key: _instructorFieldKey,
                                  maxLength: 50,
                                  decoration: const InputDecoration(labelText: 'Instructor'),
                                  validator: (val) {
                                    return (val == null || val.isEmpty) ? 'Please enter the instructor' : null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text('Release Date'),
                                ElevatedButton(
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context, 
                                      initialDate: _releasedDate,
                                      firstDate: DateTime(1900), 
                                      lastDate: DateTime(2100)
                                    );
                                    if(newDate == null) return;
                                    setState(() {
                                        _releasedDate = newDate;
                                    });
                                  }, 
                                  child: Text('${_releasedDate}'),
                                ),
                                const SizedBox(height: 20),
                                const Text('Hero'),
                                DropdownButtonFormField<SuperHero>(
                                  value: _heroDropdownValue,
                                  items: _powerHeros?.map((SuperHero items){
                                    return DropdownMenuItem<SuperHero>(
                                      value: items,
                                      child: Text(items.name.toString())
                                    );
                                  }).toList(), 
                                  onChanged: (SuperHero? newValue) { 
                                    setState(() {
                                      _heroDropdownValue = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    if(_formKey.currentState!.validate()){
                                      _formKey.currentState?.save();
                                      var updated = await _movieService.updateMovie(
                                        Movie(
                                          id: _movieList![index].id,
                                          title: _titleFieldKey.currentState?.value,
                                          description: _descriptionFieldKey.currentState?.value,
                                          instructor: _instructorFieldKey.currentState?.value,
                                          superHeroId: _heroDropdownValue?.id,
                                          releaseDate: _releasedDate.toIso8601String()
                                        )
                                      );
                                      if(updated != null){
                                        setState(() {
                                          _movieList![index] = updated;
                                        });
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue,)
                ),
                IconButton(
                  onPressed: () async {
                    var isDeleted = await _movieService.deleteMovie(_movieList![index].id);
                    if(isDeleted){
                      setState(() {
                        _movieList?.remove(_movieList![index]);
                      });
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red,)
                ),
              ],
            ),
            
          ),
        ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
            showDialog(
              context: (context), 
              builder: (content) {
                return AlertDialog(
                  title: const Text('Add New Movie'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       TextFormField(
                          key: _titleFieldKey,
                          maxLength: 50,
                          decoration: const InputDecoration(labelText: 'Title'),
                          validator: (val) {
                            return (val == null || val.isEmpty) ? 'Please enter the power' : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: _descriptionFieldKey,
                          maxLength: 50,
                          decoration: const InputDecoration(labelText: 'Description'),
                          validator: (val) {
                            return (val == null || val.isEmpty) ? 'Please enter the description' : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: _instructorFieldKey,
                          maxLength: 50,
                          decoration: const InputDecoration(labelText: 'Instructor'),
                          validator: (val) {
                            return (val == null || val.isEmpty) ? 'Please enter the instructor' : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context, 
                              initialDate: _releasedDate,
                              firstDate: DateTime(1900), 
                              lastDate: DateTime(2100)
                            );
                            if(newDate == null) return;
                            setState(() {
                                _releasedDate = newDate;
                            });
                          }, 
                          child: Text('${_releasedDate}'),
                        ),
                        const SizedBox(height: 20),
                        const Text('Hero'),
                        DropdownButtonFormField<SuperHero>(
                          value: _heroDropdownValue,
                          items: _powerHeros?.map((SuperHero items){
                            return DropdownMenuItem<SuperHero>(
                              value: items,
                              child: Text(items.name.toString())
                            );
                          }).toList(), 
                          onChanged: (SuperHero? newValue) { 
                            setState(() {
                              _heroDropdownValue = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Release Date'),
                        ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState?.save();
                              var newPower = await _movieService.addMovie(
                                Movie(
                                  title: _titleFieldKey.currentState?.value,
                                  description: _descriptionFieldKey.currentState?.value,
                                  instructor: _instructorFieldKey.currentState?.value,
                                  superHeroId: _heroDropdownValue?.id,
                                  releaseDate: _releasedDate.toIso8601String()
                                )
                              );
                              if(newPower != null){
                                setState(() {
                                  _movieList?.add(newPower);
                                });
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text('Add'),
                        )
                      ],
                    ),
                  ),
                );
              }
            )
          },
        ),
    );
  }

}