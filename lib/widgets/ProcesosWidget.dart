import 'package:flutter/material.dart';

import '../models/pcb.dart';
import '../services/planificadorColas.dart';

class ProcesosWidget extends StatelessWidget {
  const ProcesosWidget({
    Key? key,
    required this.pColas,
  }) : super(key: key);

  final PlanificarColas pColas;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Ajusta la altura según sea necesario
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pColas.colas.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cola ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: pColas.colas[index].length,
                    itemBuilder: (context, innerIndex) {
                      PCB proceso = pColas.colas[index][innerIndex];
                      return Card(
                        child: ListTile(
                          title: Text('PID: ${proceso.pid} - ${proceso.nombre}'),
                          subtitle: Text('Prioridad: ${proceso.prioridad}, CantQ: ${proceso.cantq}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
