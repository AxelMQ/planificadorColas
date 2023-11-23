// ignore: file_names
import 'package:flutter/material.dart';

import '../models/pcb.dart';
import '../services/planificadorColas.dart';

class ColaProcesosWidget extends StatelessWidget {
  const ColaProcesosWidget({
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
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[300],
                child: Text(
                  'Cola ${index + 1}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,),
                ),
                

              ),
              const SizedBox(width: 8),
              
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
