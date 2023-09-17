import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/power.dart';
import 'package:flutter_graphql/services/power_service.dart';

class PowerListPage extends StatefulWidget {
  const PowerListPage({ super.key });

  @override
  State<PowerListPage> createState() => _PowerListPage();
}

class _PowerListPage extends State<PowerListPage>{
  List<Power>? _powerList;
  PowerService _powerService = PowerService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _powerList = await _powerService.getPowerList();
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