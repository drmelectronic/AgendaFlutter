import 'package:agenda_flutter/components/unidad_list.dart';
import 'package:agenda_flutter/components/unidad_row.dart';
import 'package:agenda_flutter/entity/unidad.dart';
import 'package:agenda_flutter/services/api_service.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database.dart';
import 'login_screen.dart';



class AgendaScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UnidadListWidget unidades = UnidadListWidget(const []);

  reloadUnidades() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('source', 'server');
    _getUnidades();
  }

  Future<List<Unidad>> _getUnidades() async {
    SharedPreferences prefs = await _prefs;
    String? source = prefs.getString('source');
    List<Unidad> unidades;
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final unidadDao = database.unidadDao;
    if (source == 'db') {
      unidades = await unidadDao.findAllUnidades();
    } else {
      var apiService = APIService();
      await apiService.loadServer();
      unidades = (await apiService.loadUnidades());
      unidadDao.deleteAllUnidades();
      unidadDao.insertUnidades(unidades);
      prefs.setString('source', 'db');
    }
    return unidades;
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        preguntarSalir();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agenda TCONTUR'),
          automaticallyImplyLeading: false
        ),
        body: FutureBuilder(
          future: _getUnidades(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text('Cargando...')
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UnidadRowWidget(snapshot.data[index]);
                  }
              );
            }
          }
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Salir',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.refresh),
                label: 'Actualizar'),
          ],
          onTap: onTapNavigation,
        )
      ),
    );
  }

  void preguntarSalir() async {
    bool salir = await confirm(
        context,
        title: Text('Desea salir?'),
        content: Text('Realmente desea cerrar su sesi??n'),
        textOK: Text('S??'),
        textCancel: Text('No')
    );
    if (salir) {
      SharedPreferences prefs = await _prefs;
      prefs.setString('token', '');
      prefs.setString('source', 'server');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  onTapNavigation(int index) {
    if (index == 0) {
      preguntarSalir();
    } else {
      reloadUnidades();
    }
  }
}