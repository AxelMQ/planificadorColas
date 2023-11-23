// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../services/planificadorColas.dart';
import '../ProcesosPorColaWidget.dart';

class BodyColasProcesos extends StatelessWidget {
  const BodyColasProcesos({
    super.key,
    required this.pColas,
    required this.actualizarUI,
  });

  final PlanificarColas pColas;
  final VoidCallback actualizarUI;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        pColas.colas.length,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ProcesosPorColaWidget(
            pColas: pColas,
            colaIndex: index,
            actualizarUI: actualizarUI,
          ),
        ),
      ),
    );
  }
}
