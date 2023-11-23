// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:p_colas_prioridad/models/pcb.dart';
import 'package:path_provider/path_provider.dart';

class PlanificarColas {
  List<List<PCB>> colas;
  int qxcola;
  int qxproc;

  PlanificarColas(this.qxcola, this.qxproc)
      : colas = List.generate(qxcola, (index) => []);

  PlanificarColas.empty()
      : colas = [],
        qxcola = 0,
        qxproc = 0;

  void agregarAcola(PCB pcb) {
    colas[pcb.prioridad].add(pcb);
  }

  void copiarDesde(PlanificarColas otra) {
    qxcola = otra.qxcola;
    qxproc = otra.qxproc;

    ajustarColas(qxcola);

    for (var i = 0; i <= otra.colas.length; i++) {
      colas[i] = List.from(otra.colas[i]);
    }
  }

  void ajustarColas(int nuevasColas) {
    while (colas.length < nuevasColas) {
      colas.add([]);
    }
  }

//------------------------------------

  Future<void> savePlanificadorFromList(List<PCB> pcbs, String filePath) async {
    try {
      final File file = File(filePath);
      final List<Map<String, dynamic>> pcbsAsMap =
          pcbs.map((pcb) => pcb.toMap()).toList();
      final String pcbsAsJson = json.encode(pcbsAsMap);

      await file.writeAsString(pcbsAsJson);
      print('PCBs guardados en $filePath');
    } catch (e) {
      print('Error al guardar PCBs: $e');
      rethrow;
    }
  }

  Future<String> readFile(String filePath) async {
    try {
      File file = File(filePath);
      String fileContent = await file.readAsString();
      return fileContent;
    } catch (e) {
      print('Error al leer el archivo: $e');
      return '';
    }
  }

  Future<bool> cargarDesdeArchivo(String filePath) async {
    try {
      String fileContent = await readFile(filePath);
      List<dynamic> pcbsAsList = json.decode(fileContent);
      List<Map<String, dynamic>> pcbsAsMapList =
          List<Map<String, dynamic>>.from(pcbsAsList);

      cargarDesdeLista(pcbsAsMapList);
      if (pcbsAsMapList.isNotEmpty && pcbsAsMapList[0]['prioridad'] != null) {
        int nuevaColaActual = pcbsAsMapList[0]['prioridad'];
        colaActual = nuevaColaActual;
      }

      print('Datos cargados desde el archivo correctamente.');
      return true; // Carga exitosa
    } catch (e) {
      print('Error al cargar datos desde el archivo: $e');
      return false;
    }
  }

  void cargarDesdeLista(List<Map<String, dynamic>> lista) {
    // colas.forEach((cola) => cola.clear()); // limipia
    colas = [];
    List<PCB> pcbs = lista.map((data) => PCB.fromMap(data)).toList();

    pcbs.forEach((pcb) {
      int prioridad = pcb.prioridad;

      while (prioridad >= colas.length) {
        colas.add([]);
      }

      colas[prioridad].add(pcb);
    });

    print('Datos cargados desde la lista correctamente.');
  }

//-----------------------------------------------------------------------
  PCB? procesoEnEjecucion;
  int quantumActual = 0;
  int colaActual = 0;

  bool hayProcesosEnColas() {
    for (var cola in colas) {
      if (cola.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool colaVacia(int colaIndex) {
    try {
      if (colaIndex >= 0) {
        return colas[colaIndex].isEmpty;
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  PCB obtenerSiguienteProceso() {
    if (quantumActual < colas[colaActual].length) {
      return colas[colaActual][quantumActual++];
    } else {
      colaActual = (colaActual + 1) % qxcola;
      quantumActual = 0;
      return obtenerSiguienteProceso();
    }
  }

  PCB? sacarProcesoDeCola(int colaIndex) {
    try {
      if (colaIndex >= 0 && colas[colaIndex].isNotEmpty) {
        return colas[colaIndex].removeAt(0);
      } else {
        throw Exception('Índice de cola no válido o cola vacía.');
      }
    } catch (e) {
      print('Error al sacar proceso de la cola: $e');
      return null; // o algún otro valor especial según tu lógica
    }
  }

  void devolverProcesoCola(PCB proceso) {
    int acPrioridad = proceso.prioridad;
    agregarProcesoACola(proceso, acPrioridad);
  }

  void procesarProceso(PCB proceso) {
    print('Procesando proceso --> ${proceso.nombre} (PID: ${proceso.pid}) ...');

    SnackBar(
      content: Text(
          'Procesando proceso --> ${proceso.nombre} (PID: ${proceso.pid}) ...'),
      backgroundColor: Colors.red,
    );
  }

  int nextCola(int k) {
    int next = (k + 1) % colas.length;
    return next == 0 ? 0 : next;
  }

  int getQxCola(PCB proceso) {
    return proceso.qxcola;
  }

  int getCantQ(PCB proceso) {
    return proceso.cantq;
  }

  int cantidadColas() {
    return colas.length;
  }

//-----------------------------------------------------------------------

  void iniciarPlanificador() {
    colas.forEach((cola) => cola.clear());

    for (int i = 1; i <= qxcola; i++) {
      for (int j = 0; j < qxproc; j++) {
        String nombreProceso =
            String.fromCharCode(65 + (i - 1)) + (j + 1).toString();

        PCB nuevoProceso = PCB.create(
          nombre: nombreProceso,
          cantq: 1,
          prioridad: i - 1,
          qxcola: i,
        );

        agregarAcola(nuevoProceso);
      }
    }
  }

  List<List<PCB>> obtenerColasActuales() {
    return List<List<PCB>>.from(colas);
  }

  void agregarNuevaCola(int cantidadProcesos) {
    colas.add(List<PCB>.generate(cantidadProcesos, (index) {
      String nombreProceso =
          String.fromCharCode(65 + colas.length) + (index + 1).toString();
      return PCB.create(
        nombre: nombreProceso,
        cantq: 1,
        prioridad: colas.length,
        qxcola: colas.length + 1,
      );
    }));
  }

  void agregarNuevoProceso(
      PlanificarColas pColas, String nombre, int cantq, int prioridad) {
    PCB nuevoProceso = PCB.create(
      nombre: nombre,
      cantq: cantq,
      prioridad: prioridad,
      qxcola: prioridad + 1,
    );

    pColas.agregarProcesoACola(nuevoProceso, prioridad);
  }

  void agregarProcesoACola(PCB proceso, int prioridad) {
    if (prioridad >= 0) {
      colas[prioridad].add(proceso);
    } else {
      print('Índice de cola no válido.');
    }
  }

  void cambiarQxCola(int colaIndex, int nuevoQxCola) {
    if (colaIndex >= 0) {
      colas[colaIndex].forEach((proceso) {
        proceso.qxcola = nuevoQxCola;
      });
    } else {
      print('Índice de cola no válido: $colaIndex');
    }
  }

  void killProceso(PCB proceso) {
    for (var cola in colas) {
      final index = cola.indexWhere((p) => p.pid == proceso.pid);

      if (index != -1) {
        cola.removeAt(index);
        print('Proceso ${proceso.nombre} eliminado exitosamente.');
        return;
      }
    }
    print('Proceso ${proceso.nombre} no encontrado en ninguna cola.');
  }

  void actualizarDatosProceso(
      PCB proceso, String nuevoNombre, int nuevoCantq, int? nuevoQxFinalizar) {
    for (var cola in colas) {
      final index = cola.indexWhere((p) => p.pid == proceso.pid);

      if (index != -1) {
        proceso.nombre = nuevoNombre;
        proceso.cantq = nuevoCantq;
        if (nuevoQxFinalizar != null) {
          proceso.qxFinalizar = nuevoQxFinalizar;
        }
        print('Proceso ${proceso.nombre} editado exitosamente.');
        return;
      }
    }
    print('Proceso ${proceso.nombre} no encontrado en ninguna cola.');
  }

  void loadPlanificadorFromFile(String filePath) {}
}
