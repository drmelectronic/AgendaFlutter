import 'package:agenda_flutter/components/unidad_row.dart';
import 'package:agenda_flutter/entity/unidad.dart';
import 'package:flutter/material.dart';

class UnidadListWidget extends StatelessWidget {

  List<Unidad> unidades = [];

  UnidadListWidget(List<Unidad> unidades) : super();


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (Unidad u in unidades) UnidadRowWidget(u)
      ]
    );
  }

}