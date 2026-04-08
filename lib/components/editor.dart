import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;
  final TextInputType? teclado;
  final List<TextInputFormatter>? formatadores;

  Editor({
    this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
    this.formatadores,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: teclado ?? TextInputType.text,
        inputFormatters: formatadores,
      ),
    );
  }
}
