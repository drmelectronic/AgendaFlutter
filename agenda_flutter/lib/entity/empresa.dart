import 'package:floor/floor.dart';

@entity
class Empresa {
  @primaryKey
  final int id;
  final String codigo;
  final String nombre;

  Empresa(this.id, this.codigo, this.nombre);
  Empresa.fromJson(e) : this(e['id'], e['codigo'], e['nombre']);

}