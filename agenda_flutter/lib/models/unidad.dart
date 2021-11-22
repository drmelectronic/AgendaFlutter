class Unidad {
  final int _padron;
  final String _placa, _celular;

  Unidad(this._padron, this._placa, this._celular);
  Unidad.fromJson(e) : this(e['padron'], e['placa'], e['celular']);

  int get padron => _padron;
  String get placa => _placa;
  String get celular => _celular;

}
