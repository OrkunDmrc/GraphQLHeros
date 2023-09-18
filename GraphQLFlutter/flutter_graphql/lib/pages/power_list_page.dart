import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/hero.dart';
import 'package:flutter_graphql/models/power.dart';
import 'package:flutter_graphql/services/hero_service.dart';
import 'package:flutter_graphql/services/power_service.dart';

class PowerListPage extends StatefulWidget {
  const PowerListPage({ super.key });

  @override
  State<PowerListPage> createState() => _PowerListPage();
}

class _PowerListPage extends State<PowerListPage>{
  List<Power>? _powerList;
  final PowerService _powerService = PowerService();
  final HeroService _heroService = HeroService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _powerPowerFieldKey = GlobalKey();
  final GlobalKey<FormFieldState> _powerDescriptionFieldKey = GlobalKey();
  late List<SuperHero>? _powerHeros;
  late SuperHero? _powerHeroDropdownValue;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _powerList = await _powerService.getPowerList();
    _powerHeros = await _heroService.getHerosForDropdown();
    _powerHeroDropdownValue = _powerHeros?.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_powerList == null || _powerList!.isEmpty) ? 
        const Center(child: Text('Powers not found'),) : 
        ListView.builder(
          itemCount: _powerList!.length,
          itemBuilder: (context, index) => ListTile(
            title: Text('${_powerList![index].superPower}'),
            onTap: () => {
              print('${_powerList![index].superPower}')
            },
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: (context), 
                      builder: (content) {
                        return AlertDialog(
                          title: const Text('Update Power'),
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
                                  onPressed: () async {
                                    if(_formKey.currentState!.validate()){
                                      _formKey.currentState?.save();
                                      await _powerService.updatePower(
                                        Power(
                                          id: _powerList![index].id,
                                          superPower: _powerPowerFieldKey.currentState?.value,
                                          description: _powerDescriptionFieldKey.currentState?.value,
                                          superHeroId: _powerHeroDropdownValue?.id
                                        )
                                      );
                                      _load();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Update'),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                    _load();
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue,)
                ),
                IconButton(
                  onPressed: () async {
                    await _powerService.deletePower(_powerList![index].id);
                    _load();
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
                  title: const Text('Add New Power'),
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
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState?.save();
                              await _powerService.addPower(
                                Power(
                                  superPower: _powerPowerFieldKey.currentState?.value,
                                  description: _powerDescriptionFieldKey.currentState?.value,
                                  superHeroId: _powerHeroDropdownValue?.id
                                )
                              );
                              _load();
                              Navigator.pop(context);
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