
import 'package:flutter/material.dart';

class ContadoresWidget extends StatelessWidget {
  const ContadoresWidget({
    super.key,
    required this.colaActual,
    required this.cqxCola,
    required this.cantqProceso,
  });

  final int colaActual;
  final int cqxCola;
  final int cantqProceso;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 1.5,
          color: Color.fromARGB(255, 51, 41, 41),
          indent: 55,
          endIndent: 60,
        ),
        const SizedBox(
            height:
                5),
        Text(
          'Cola Actual: ${colaActual + 1}',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          'C. Q x Cola: $cqxCola',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.normal),
        ),
        Text(
          'C. Q x Proceso: ${cantqProceso + 1}',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.normal),
        ),
        const SizedBox(
            height: 10), 
        
      ],
    );
  }
}
