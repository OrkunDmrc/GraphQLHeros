import 'dart:io';
import 'package:flutter_graphql/book_model.dart';
import 'package:flutter_graphql/graphql_service.dart';
import 'package:flutter_graphql/models/hero.dart';
import 'package:flutter_graphql/models/power.dart';
import 'package:flutter_graphql/pages/hero_list_page.dart';
import 'package:flutter_graphql/pages/movie_list_page.dart';
import 'package:flutter_graphql/pages/power_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graphql/services/hero_service.dart';
import 'package:flutter_graphql/services/power_service.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraphQL',
      theme:ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const MyHomePage (title: 'Hero Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
 
  final String title;

  

  @override
  State<StatefulWidget> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  void clear(){

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GraphQL Heros'),
          centerTitle: true,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Powers', icon: Icon(Icons.list)),
              Tab(text: 'Heros', icon:Icon(Icons.people_alt_sharp)),
              Tab(text: 'Movies', icon: Icon(Icons.movie))
            ],
            controller: _tabController
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            PowerListPage(),
            HeroListPage(),
            MovieListPage(),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
            showDialog(
              context: (context), 
              builder: (content) {
                if(_tabController.index == 0){
                  return AlertDialog(
                    title: Text('Add New Power'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            key: _powerPowerFieldKey,
                            decoration: const InputDecoration(labelText: 'Power'),
                            validator: (val) {
                              return (val == null || val.isEmpty) ? 'Please enter the power' : null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            key: _powerDescriptionFieldKey,
                            decoration: const InputDecoration(labelText: 'Description'),
                            validator: (val) {
                              return (val == null || val.isEmpty) ? 'Please enter the description' : null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text('Hero'),
                          DropdownButtonFormField<SuperHero>(
                            value: _powerHeroDropdownValue,
                            items: _powerHeros?.map((SuperHero items){
                              return DropdownMenuItem<SuperHero>(
                                value: items,
                                child: Text(items.name.toString())
                              );
                            }).toList(), 
                            onChanged: (SuperHero? newValue) { 
                              setState(() {
                                _powerHeroDropdownValue = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                _formKey.currentState?.save();
                                _powerService.addPower(
                                  Power(
                                    superPower: _powerPowerFieldKey.currentState?.value,
                                    description: _powerDescriptionFieldKey.currentState?.value,
                                    superHeroId: _powerHeroDropdownValue?.id
                                  )
                                );

                              }
                            },
                            child: const Text('Add'),
                          )
                        ],
                      ),
                    ),
                  );
                }else if(_tabController.index == 1){
                  return AlertDialog(
                    title: Text('asdf'),
                    content: Column(
                      children: [
                        TextFormField(
                          key: _powerPowerFieldKey,
                          decoration: const InputDecoration(labelText: 'Power'),
                          validator: (val) {
                            return (val == null || val.isEmpty) ? 'Please enter the power' : null;
                          },
                        ),
                      ]
                    ),
                  );
                }else{
                  return Text('asdf');
                }
              }
            )
          },
        ),*/
      ),
    );
  }
}

/*
Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: _books == null ? const Center(child: CircularProgressIndicator()) :
        Column(
          children: [
            Expanded(
              child: _books!.isEmpty ? const Center(child: Text("no books")) :
              ListView.builder(
                itemCount: _books!.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.book),
                  title: Text('${_books![index].title} by ${_books![index].author}'),
                  subtitle: Text('Released ${_books![index].year}'),
                  trailing: IconButton(
                    onPressed: () {
                      _graphQLService.deleteBook(id: _books![index].id!);
                      _load();
                    },
                    icon: Icon(Icons.delete, color: Colors.red,)
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(hintText: 'Title'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _authorController,
                          decoration: InputDecoration(hintText: 'Auhor'),
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _yearController,
                          decoration: InputDecoration(hintText: 'Year'),
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  await _graphQLService.createBook(title: _titleController.text, author: _authorController.text, year: int.parse(_yearController.text));
                  _load();
                }
              ),
            ])
          ],
        ) 
      ),
    );
*/