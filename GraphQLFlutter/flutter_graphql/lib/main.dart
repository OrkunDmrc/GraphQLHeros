import 'dart:io';

import 'package:flutter_graphql/book_model.dart';
import 'package:flutter_graphql/graphql_service.dart';
import 'package:flutter_graphql/pages/hero_list_page.dart';
import 'package:flutter_graphql/pages/movie_list_page.dart';
import 'package:flutter_graphql/pages/power_list_page.dart';

import 'blog_row.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
  List<BookModel>? _books;
  final GraphQLService _graphQLService = GraphQLService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
    _load();
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  void _load() async {
    //_books = await _graphQLService.getBooks(limit: 5);
    setState(() {});
  }

  void clear(){
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
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
          children: [
            PowerListPage(),
            HeroListPage(),
            MovieListPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
            if(_tabController.index == 0){

            }else if(_tabController.index == 1){

            }else{

            }
          },
        ),
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