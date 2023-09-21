import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final HeroService _heroService = HeroService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _nameFieldKey = GlobalKey();
  final GlobalKey<FormFieldState> _descriptionFieldKey = GlobalKey();
  final GlobalKey<FormFieldState> _heightFieldKey = GlobalKey();


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
            trailing:  Wrap(
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
                                  key: _nameFieldKey,
                                  maxLength: 50,
                                  decoration: const InputDecoration(labelText: 'Name'),
                                  validator: (val) {
                                    return (val == null || val.isEmpty) ? 'Please enter the name' : null;
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
                                  key: _heightFieldKey,
                                  maxLength: 3,
                                  inputFormatters: <TextInputFormatter>
                                  [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                                  validator: (val) {
                                    return (val == null || val.isEmpty) ? 'Please enteer the height' : null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    if(_formKey.currentState!.validate()){
                                      _formKey.currentState?.save();
                                      var updated = await _heroService.updateHero(
                                        SuperHero(
                                          id: _heroList![index].id,
                                          name: _nameFieldKey.currentState?.value,
                                          description: _descriptionFieldKey.currentState?.value,
                                          height: double.parse(_heightFieldKey.currentState?.value)
                                        )
                                      );
                                      if(updated != null){
                                        setState(() {
                                          _heroList![index] = updated;
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
                    var isDeleted = await _heroService.deleteHero(_heroList![index].id);
                    if(isDeleted){
                      setState(() {
                        _heroList?.remove(_heroList![index]);
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
                  title: const Text('Add New Hero'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: _nameFieldKey,
                          maxLength: 50,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (val) {
                            return (val == null || val.isEmpty) ? 'Please enter the name' : null;
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
                          key: _heightFieldKey,
                          maxLength: 3,
                          inputFormatters: <TextInputFormatter>
                          [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(labelText: 'Height (cm)'),
                          validator: (val) {
                            return (val == null || val.isEmpty) ? 'Please enteer the height' : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState?.save();
                              var newPower = await _heroService.addHero(
                                SuperHero(
                                  name: _nameFieldKey.currentState?.value,
                                  description: _descriptionFieldKey.currentState?.value,
                                  height: double.parse(_heightFieldKey.currentState?.value) 
                                )
                              );
                              if(newPower != null){
                                setState(() {
                                  _heroList?.add(newPower);
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