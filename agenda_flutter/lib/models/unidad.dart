class Unidad {
  final int _padron;
  final String _placa;
  final int _celular;

  Unidad(this._padron, this._placa, this._celular);
  Unidad.fromJson(e) : this(e['padron'], e['placa'], e['chip']);

  int get padron => _padron;
  String get placa => _placa;
  int get celular => _celular;

}
