import 'package:agenda/components/unidad_row.dart';
import 'package:agenda/entity/unidad.dart';
import 'package:flutter/material.dart';

class UnidadListWidget extends StatefulWidget {


  const UnidadListWidget(List<Unidad> unidades, {super.key});

  @override
  State<UnidadListWidget> createState() => _UnidadListWidgetState();
}

class _UnidadListWidgetState extends State<UnidadListWidget> {
  List<Unidad> unidades = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (Unidad u in unidades) UnidadRowWidget(u)
      ]
    );
  }
}