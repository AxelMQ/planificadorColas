
import 'package:flutter/material.dart';

import '../models/pcb.dart';

class PCBWidget extends StatelessWidget {
  final PCB pcb;

  const PCBWidget({super.key, required this.pcb});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${pcb.nombre}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prioridad: ${pcb.prioridad}'),
            Text('Quantum x Cola: ${pcb.qxcola}'),
            Text('Quantum x Proceso: ${pcb.cantq}'),
          ],
        ),
      ),
    );
  }
}