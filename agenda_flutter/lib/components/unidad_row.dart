import 'package:agenda/entity/unidad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class UnidadRowWidget extends StatelessWidget {
  final Unidad unidad;

  const UnidadRowWidget(this.unidad, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.phone),
      title: Text(unidad.padron.toString()),
      subtitle: Text(unidad.placa),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          textStyle: const TextStyle(fontSize: 20)
        ),
        child: const Text('Llamar'),
        onPressed: () async {
          await FlutterPhoneDirectCaller.callNumber(unidad.celular.toString());
        },
      ),
    );
  }
}