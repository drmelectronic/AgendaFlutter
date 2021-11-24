import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/unidad_dao.dart';
import 'entity/unidad.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Unidad])
abstract class AppDatabase extends FloorDatabase {
  UnidadDao get unidadDao;
}
