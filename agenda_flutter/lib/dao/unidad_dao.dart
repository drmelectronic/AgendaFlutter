import 'package:agenda_flutter/entity/unidad.dart';
import 'package:floor/floor.dart';

@dao
abstract class UnidadDao {
  @Query('SELECT * FROM Unidad')
  Future<List<Unidad>> findAllUnidades();

  @Query('SELECT * FROM Unidad WHERE id= :id')
  Stream<Unidad?> findPersonById(int id);

  @insert
  Future<void> insertUnidad(Unidad unidad);

  @insert
  Future<void> insertUnidades(List<Unidad> unidades);

  @Query('DELETE FROM Unidad')
  Future<void> deleteAllUnidades();
}