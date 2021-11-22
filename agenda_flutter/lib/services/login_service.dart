import 'dart:convert';

import 'package:agenda_flutter/models/login.dart';
import 'package:agenda_flutter/models/unidad.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  String BASE_URL = 'https://urbanito-23lnu3rcea-uc.a.run.app';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = Uri.parse(BASE_URL + "/api/token-auth");

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response.body);
      var decoded = json.decode(response.body);
      String token = 'Token ' + decoded['token'];
      final SharedPreferences prefs = await _prefs;
      prefs.setString('token', token);
      return LoginResponseModel.fromJson(decoded);
    } else {
        throw Exception('Failed to load Data');
    }
  }

  Future<List<Unidad>> loadUnidades() async {
    Uri url = Uri.parse(BASE_URL + "/api/celulares");
    SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Is Not Logged');
    }
    final response = await http.get(url, headers: {token: token});
    if(response.statusCode == 200 || response.statusCode == 400) {
      Iterable decoded = json.decode(response.body);
      return List<Unidad>.from(decoded.map((e) => Unidad.fromJson(e)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}