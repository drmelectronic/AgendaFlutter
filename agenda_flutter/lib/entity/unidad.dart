import 'package:floor/floor.dart';

@entity
class Unidad {
  @primaryKey
  final int id;
  final int padron;
  final String placa;
  final int celular;

  Unidad(this.id, this.padron, this.placa, this.celular);
  Unidad.fromJson(e) : this(e['id'], e['padron'], e['placa'], e['chip']);

}