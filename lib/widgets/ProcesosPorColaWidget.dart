import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/pcb.dart';
import '../services/planificadorColas.dart';

class ProcesosPorColaWidget extends StatelessWidget {
  const ProcesosPorColaWidget({
    Key? key,
    required this.pColas,
    required this.colaIndex,
    required this.actualizarUI,
  }) : super(key: key);

  final PlanificarColas pColas;
  final int colaIndex;
  final VoidCallback actualizarUI;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String nombre = 'PX';
        int cantq = 1;
        int prioridad = colaIndex;
        int nuevoQxCola = 1;
        // print('TAP COLA');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                'COLA SELECCIONADA: Q[${colaIndex + 1}] ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              children: [
                ListTile(
                  title: const Text(
                    'Agregar Nuevo Proceso',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    agregarNuevoProceso(context, nombre, cantq, prioridad);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Cambiar Quantum x Cola',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // mostrarDialogCambiarCola(cantq, prioridad);
                    cambiarQporCola(
                        context, nuevoQxCola, nombre, cantq, prioridad);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.grey[300],
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q[${colaIndex + 1}]',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 90),
                child: Column(
                  children: List.generate(
                    pColas.colas[colaIndex].length,
                    (innerIndex) {
                      PCB proceso = pColas.colas[colaIndex][innerIndex];
                      return GestureDetector(
                        onTap: () {
                          print('PROCESO SELECCIONADO: ${proceso.nombre}');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text(
                                  'PROCESO SELECCIONADO: ${proceso.nombre}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                children: [
                                  ListTile(
                                    title: const Text(
                                      'Terminar Proceso - KILL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      confirmarKILL(context, proceso);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Opciones del Proceso',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      mostrarDetallesProceso(context, proceso);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(proceso.nombre),
                            subtitle: Text(
                                'P: ${proceso.prioridad.toString()} - QC: ${proceso.qxcola} - QP: ${proceso.cantq}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mostrarDetallesProceso(BuildContext context, PCB proceso) async {
    TextEditingController nombreController =
        TextEditingController(text: proceso.nombre);
    TextEditingController cantqController =
        TextEditingController(text: proceso.cantq.toString());
    TextEditingController qxFinalizarController =
        TextEditingController(text: proceso.qxFinalizar?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'DETALLES DEL PROCESO - ${proceso.nombre}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: cantqController,
                  decoration: const InputDecoration(labelText: 'QxProceso'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: qxFinalizarController,
                  decoration: const InputDecoration(labelText: 'QxFinalizar'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                String nuevoNombre = nombreController.text;
                int nuevoCantq = int.tryParse(cantqController.text) ?? 1;
                int? nuevoQxFinalizar =
                    int.tryParse(qxFinalizarController.text);
                pColas.actualizarDatosProceso(
                  proceso,
                  nuevoNombre,
                  nuevoCantq,
                  nuevoQxFinalizar,
                );
                actualizarUI();
                Fluttertoast.showToast(
                  msg: ' Proceso Editado: ${proceso.nombre}',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> confirmarKILL(BuildContext context, PCB proceso) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'CONFIRMAR KILL - ${proceso.nombre}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
              '¿Estás seguro de que deseas KILL el PROCESO ${proceso.nombre}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                print('KILL proceso');
                pColas.killProceso(proceso);
                actualizarUI();
                Fluttertoast.showToast(
                  msg: ' KILL --> ${proceso.nombre}',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.pop(context); // Cerrar el cuadro de diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> cambiarQporCola(
    BuildContext context,
    int nuevoQxCola,
    String nombre,
    int cantq,
    int prioridad,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 170,
          child: AlertDialog(
            title: const Text(
              'CAMBIAR Q X COLA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text('Cola Seleccionada: Q[${colaIndex + 1}]'),
                  TextField(
                    onChanged: (value) {
                      int? parsedValue = int.tryParse(value);

                      if (parsedValue != null && parsedValue >= 0) {
                        nuevoQxCola = parsedValue;
                      } else {
                        nuevoQxCola = 1;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nuevo QxCola',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cambiar QxCola aquí
                  pColas.cambiarQxCola(colaIndex, nuevoQxCola);
                  Navigator.pop(context);
                  actualizarUI();
                  Fluttertoast.showToast(
                    msg: 'Nuevo QxCola asignado',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> agregarNuevoProceso(
      BuildContext context, String nombre, int cantq, int prioridad) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 170,
          child: AlertDialog(
            title: const Text(
              'AGREGAR NUEVO PROCESO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              height: 190,
              child: Column(
                children: [
                  Text('Cola Seleccionada: Q[${colaIndex + 1}]'),
                  TextField(
                    onChanged: (value) {
                      nombre = value;
                    },
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const Text(
                    'Nombre por Defecto: PX',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  TextField(
                    onChanged: (value) {
                      cantq = int.tryParse(value) ?? 1;
                    },
                    decoration: const InputDecoration(labelText: 'q x Proceso'),
                    keyboardType: TextInputType.number,
                  ),
                  const Text(
                    'quantum x proceso: 1 (por defecto)',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  pColas.agregarNuevoProceso(pColas, nombre, cantq, prioridad);
                  Navigator.pop(context);
                  actualizarUI();
                  Fluttertoast.showToast(
                    msg: 'Proceso agregado correctamente',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
