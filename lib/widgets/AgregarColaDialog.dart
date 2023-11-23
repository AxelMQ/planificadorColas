// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AgregarColaDialog extends StatefulWidget {
  final Function(int) onColaAgregada;

  const AgregarColaDialog({Key? key, required this.onColaAgregada})
      : super(key: key);

  @override
  _AgregarColaDialogState createState() => _AgregarColaDialogState();
}

class _AgregarColaDialogState extends State<AgregarColaDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: const [
          Text('AGREGAR NUEVA COLA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text('Valor por defecto: 3 procesos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),),
        ],
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Cantidad de Procesos'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              int cantidadProcesos = int.parse(_controller.text);
              widget.onColaAgregada(cantidadProcesos);
              _mostrarToast('Se agregó la cola con $cantidadProcesos procesos');
            } else {
              widget.onColaAgregada(3);
              _mostrarToast('Se agregó la cola con 3 procesos');
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}


void _mostrarToast(String mensaje) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: const Color.fromARGB(255, 197, 192, 192),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
