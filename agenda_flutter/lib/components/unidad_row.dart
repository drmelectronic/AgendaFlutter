import 'package:agenda_flutter/models/unidad.dart';
import 'package:flutter/material.dart';

class UnidadRowWidget extends StatelessWidget {
  final Unidad unidad;

  UnidadRowWidget(this.unidad);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.phone),
      title: Text(unidad.padron.toString()),
      subtitle: Text(unidad.placa),
      trailing: Text(unidad.celular),
    );
  }
}