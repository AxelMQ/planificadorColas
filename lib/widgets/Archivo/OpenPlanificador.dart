// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../screens/FileExplorerScreen.dart';
import '../../services/planificadorColas.dart';

class OpenPlanificador extends StatelessWidget {
  const OpenPlanificador({
    Key? key,
    required this.pColas,
    required this.actualizarUI,
  }) : super(key: key);

  final PlanificarColas pColas;
  final VoidCallback actualizarUI;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        String? filePath = await _openFileExplorer(context);
        if (filePath != null) {
          print('AQUI SE EJECUTA');
          bool cargaExitosa = await pColas.cargarDesdeArchivo(filePath);
          if (cargaExitosa) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Planificador cargado desde el archivo.'),
                backgroundColor: Colors.green,
              ),
            );
              actualizarUI();
          }
        }
      },
      icon: const Icon(
        Icons.document_scanner_rounded,
        color: Colors.black87,
      ),
     
    );
  }

  Future<String?> _openFileExplorer(BuildContext context) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileExplorerScreen(
          onFileSelected: (filePath) {},
        ),
      ),
    );
  }
}
