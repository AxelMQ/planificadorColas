// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import '../../services/planificadorColas.dart';

class SavePlanificador extends StatelessWidget {
  const SavePlanificador({
    Key? key,
    required this.pColas,
  }) : super(key: key);

  final PlanificarColas pColas;

  Future<void> _saveFile(BuildContext context) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      print('Directorio de documentos: ${directory.path}');

      String? fileName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text('Guardar archivo'),
            content: TextField(
              controller: controller,
              decoration:
                  const InputDecoration(labelText: 'Nombre del archivo'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
                child: const Text('Guardar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );

      if (fileName != null && fileName.isNotEmpty) {
        String filePath = '${directory.path}/$fileName.json';

        await pColas.savePlanificadorFromList(
            pColas.colas.expand((cola) => cola).toList(), filePath);

        File file = File(filePath);
        if (await file.exists()) {
          print('CREADO $filePath');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Archivo guardado exitosamente.'),
              backgroundColor: Color.fromARGB(255, 143, 122, 76),
            ),
          );
        } else {
          print('Error: El archivo no se creó correctamente.');
        }
      }
    } catch (e) {
      print('Error al guardar el archivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await _saveFile(context);
      },
      icon: const Icon(
        Icons.save,
        color: Colors.black87,
      ),
    );
  }
}
