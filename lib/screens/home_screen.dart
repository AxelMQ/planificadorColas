// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p_colas_prioridad/widgets/Archivo/OpenPlanificador.dart';
import '../models/pcb.dart';
import '../services/planificadorColas.dart';
import '../widgets/AgregarColaDialog.dart';
import '../widgets/Archivo/SavePlanificador.dart';
import '../widgets/Body/BodyColasProcesos.dart';
import '../widgets/ContadoresWidget.dart';
import '../widgets/NavigationWidget.dart';
import '../widgets/PCBwidget.dart';
import '../widgets/ProcesoPRUN.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PlanificarColas newpColas;
  late PlanificarColas pColas = PlanificarColas.empty();
  PCB? procesoSacado;
  int colaActual = 0;
  bool sacarProceso = true;
  int cqxCola = 0;
  int cantqProceso = 0;
  int cqxProceso = 0;
  int colaInicio = 3;
  int procesos = 3;

  @override
  void initState() {
    super.initState();
    cqxCola = 0;
    colaActual = 0;
  }

  void actualizarUI() {
    setState(() {});
  }

  void reiniciarPlanificador() {
    pColas.iniciarPlanificador();
    pColas.obtenerColasActuales();
  }

  void reiniciarValores() {
    pColas = PlanificarColas(colaInicio, procesos);
    procesoSacado = null;
    colaActual = 0;
    sacarProceso = true;
    cqxCola = 0;
  }

  void vaciar() {
    pColas = PlanificarColas(0, 0);
    procesoSacado = null;
    colaActual = 0;
    sacarProceso = true;
    cqxCola = 0;
  }

  void planificadorColas() {
    if (sacarProceso) {
      if (!pColas.colaVacia(colaActual)) {
        procesoSacado = pColas.sacarProcesoDeCola(colaActual);
        Fluttertoast.showToast(
          msg: 'Sacamos Proceso',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 30.0,
        );
        if (procesoSacado != null) {
          pColas.procesarProceso(procesoSacado!);
          cantqProceso = 0;
          cqxCola++;
          if (pColas.getQxCola(procesoSacado!) <= cqxCola) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('QxCola CUMPLIDO!!! --> NEXT COLA '),
                backgroundColor: Color.fromARGB(255, 71, 160, 86),
              ),
            );

            colaActual = pColas.nextCola(colaActual);
            cqxCola = 0;
          }
        }
      }
    } else {
      if (procesoSacado != null) {
        cantqProceso++;

        if (procesoSacado!.qxFinalizar != null) {
          procesoSacado!.qxFinalizar = (procesoSacado!.qxFinalizar! - 1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QxFinalizar : ${procesoSacado!.qxFinalizar}'),
              backgroundColor: const Color.fromARGB(255, 226, 160, 17),
            ),
          );
        }

        if (procesoSacado!.qxFinalizar == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('FINALIZO PROCESO : ${procesoSacado!.qxFinalizar}'),
              backgroundColor: Colors.red,
            ),
          );
          cantqProceso = 0;
          if (pColas.getQxCola(procesoSacado!) <= cqxCola) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('QxCola CUMPLIDO!!! --> NEXT COLA '),
                backgroundColor: Color.fromARGB(255, 71, 160, 86),
              ),
            );
            colaActual = pColas.nextCola(colaActual);
            cqxCola = 0;
          }
          pColas.killProceso(procesoSacado!);
          procesoSacado = null;
          sacarProceso = !sacarProceso;
          actualizarUI();
          return;
        }

        if (cantqProceso < procesoSacado!.cantq) {
          Fluttertoast.showToast(
            msg: 'Aun Tiene Q x Proceso ...',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 30.0,
          );
          cqxCola++;
          actualizarUI();
          return;
        }
        Fluttertoast.showToast(
          msg: 'Cumplio Q x Proceso ... Devolver ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 30.0,
        );
        cantqProceso = 0;
        if (pColas.getQxCola(procesoSacado!) <= cqxCola) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('QxCola CUMPLIDO!!! --> NEXT COLA '),
              backgroundColor: Color.fromARGB(255, 71, 160, 86),
            ),
          );
          colaActual = pColas.nextCola(colaActual);
          cqxCola = 0;
        }
        pColas.devolverProcesoCola(procesoSacado!);
        procesoSacado = null;
        sacarProceso = !sacarProceso;
        actualizarUI();
        return;
      }
      int maxIteraciones = pColas.cantidadColas() + 1;
      int iteracionActual = 0;

      while (iteracionActual < maxIteraciones &&
          (procesoSacado == null || !pColas.hayProcesosEnColas())) {
        colaActual = pColas.nextCola(colaActual);
        iteracionActual++;

        // Muestra un mensaje al usuario
        Fluttertoast.showToast(
          msg: 'Buscando en la cola $colaActual...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    sacarProceso = !sacarProceso;
    actualizarUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SO1 - SIMULADOR',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          SavePlanificador(pColas: pColas),
          OpenPlanificador(
            pColas: pColas,
            actualizarUI: () {
              actualizarUI();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'PLANIFICADOR CON COLAS DE PRIORIDAD',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ProcesoPRUN(procesoSacado: procesoSacado),
            ContadoresWidget(
                colaActual: colaActual,
                cqxCola: cqxCola,
                cantqProceso: cantqProceso),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BodyColasProcesos(
                    pColas: pColas, actualizarUI: actualizarUI),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: addCola(),
      bottomNavigationBar: NavigationWidget(
        iniciarReiniciarPlanificador: iniciarReiniciarPlanificador,
        planificadorColas: planificadorColas,
      ),
    );
  }

  FloatingActionButton addCola() {
    return FloatingActionButton(
      onPressed: () async {
        int? cantidadProcesos = await showDialog<int>(
          context: context,
          builder: (context) {
            return AgregarColaDialog(onColaAgregada: (cantidad) {
              Navigator.pop(context, cantidad);
            });
          },
        );
        if (cantidadProcesos != null && cantidadProcesos > 0) {
          pColas.agregarNuevaCola(cantidadProcesos);
          pColas.obtenerColasActuales();
          actualizarUI();
        }
      },
      child: const Icon(Icons.add),
    );
  }

  void iniciarReiniciarPlanificador() {
    reiniciarValores();
    reiniciarPlanificador();
    actualizarUI();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Iniciar/Reiniciar Planificador'),
        backgroundColor: Color.fromARGB(255, 83, 167, 27),
      ),
    );
  }
}
