import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/hero.dart';
import 'package:flutter_graphql/models/power.dart';
import 'package:flutter_graphql/services/hero_service.dart';

class HeroListPage extends StatefulWidget {
  const HeroListPage({ super.key });

  @override
  State<HeroListPage> createState() => _HeroListPage();
}

class _HeroListPage extends State<HeroListPage>{
  List<SuperHero>? _heroList;
  HeroService _heroService = HeroService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _heroList = await _heroService.getHeroList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_heroList == null || _heroList!.isEmpty) ? 
        const Center(child: Text('Heros not found'),) : 
        ListView.builder(
          itemCount: _heroList!.length,
          itemBuilder: (context, index) => ListTile(
            title: Text('${_heroList![index].name}'),
            subtitle: Text('can ${_separateListPowerAsString(_heroList![index].superpowers)}'),
            onTap: () => {
              print('${_heroList![index].name}')
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
  String _separateListPowerAsString(List<Power>? powers){
    String value = "";
    if(powers != null){
      powers.forEach((element) {
        value += '${element.superPower}, ';
      });
    }
    return value;
  }
}