import 'dart:convert';

import 'package:agenda/entity/empresa.dart';
import 'package:agenda/models/login.dart';
import 'package:agenda/entity/unidad.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String server = '';

  setServer(String? empresa) {
    empresa ??= 'urbanito';
    server = 'https://$empresa-23lnu3rcea-uc.a.run.app';
  }

  Future<bool> setEmpresa (String newValue) async {
    var prefs = await _prefs;
    prefs.setString('empresa', newValue);
    setServer(newValue);
    return true;
  }

  Future<bool> loadServer () async {
    var prefs = await _prefs;
    var empresa = prefs.getString('empresa');
    setServer(empresa);
    return true;
  }

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = Uri.parse("$server/api/token-auth");
    EasyLoading.show(status: 'loading...');
    final response = await http.post(url, body: requestModel.toJson());
    EasyLoading.dismiss();
    if (response.statusCode == 200 || response.statusCode == 400) {
      var decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded.containsKey('error')) {
        throw Exception(decoded['message']);
      }
      String token = 'Token ' + decoded['token'];
      final SharedPreferences prefs = await _prefs;
      prefs.setString('token', token);
      prefs.setString('username', requestModel.username);
      prefs.setString('password', requestModel.password);
      return LoginResponseModel.fromJson(decoded);
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<List<Unidad>> loadUnidades() async {
    Uri url = Uri.parse("$server/api/unidades/celulares");
    EasyLoading.show(status: 'cargando...');
    SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Is Not Logged');
    }
    final response = await http.get(url, headers: {'Authorization': token});
    if(response.statusCode == 200 || response.statusCode == 400) {
      Iterable decoded = json.decode(utf8.decode(response.bodyBytes));
      decoded = decoded.where((u) => u.containsKey('padron') && u.containsKey('placa') && u.containsKey('chip')).toList();
      decoded = decoded.where((u) => u['padron'] != null && u['placa'] != null && u['chip'] != null).toList();
      var lista = List<Unidad>.from(decoded.map((e) => Unidad.fromJson(e)));
      EasyLoading.dismiss();
      return lista;
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load data');
    }
  }
  Future<List<Empresa>> loadEmpresas() async {
    Uri url = Uri.parse("https://urbanito-23lnu3rcea-uc.a.run.app/tracker/empresas");
    final response = await http.get(url);
    if(response.statusCode == 200 || response.statusCode == 400) {
      Iterable decoded = json.decode(utf8.decode(response.bodyBytes));
      var lista = List<Empresa>.from(decoded.map((e) => Empresa.fromJson(e)));
      return lista;
    } else {
      throw Exception('Failed to load data');
    }
  }
}