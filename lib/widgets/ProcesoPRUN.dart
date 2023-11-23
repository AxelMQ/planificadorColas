
import 'package:flutter/material.dart';

import '../models/pcb.dart';
import 'PCBwidget.dart';

class ProcesoPRUN extends StatelessWidget {
  const ProcesoPRUN({
    super.key,
    required this.procesoSacado,
  });

  final PCB? procesoSacado;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 250,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 123, 172, 212), // Puedes cambiar el color de fondo según tu diseño
        borderRadius:
            BorderRadius.circular(10), // Añade bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Sombra con opacidad
            spreadRadius: 2,
            blurRadius: 5,
            offset:
                const Offset(0, 3), // Cambia la posición de la sombra
          ),
        ],
      ),
      child: procesoSacado != null
          ? PCBWidget(pcb: procesoSacado!)
          : const SizedBox(),
    );
  }
}