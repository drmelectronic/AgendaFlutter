import 'package:agenda_flutter/components/unidad_list.dart';
import 'package:agenda_flutter/services/login_service.dart';
import 'package:flutter/material.dart';


class AgendaScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {

  UnidadListWidget unidades = UnidadListWidget(const []);



  @override
  initState() {
    super.initState();
    onUpdate();
  }

  onUpdate() {
    var apiService = APIService();
    apiService.loadUnidades().then((value) {
      print(value);
      setState(() {
        unidades = UnidadListWidget(value);
      });
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Agenda TCONTUR')
      ),
      body: unidades,
    );
  }
}