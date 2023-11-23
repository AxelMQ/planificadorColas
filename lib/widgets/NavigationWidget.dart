import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({
    Key? key,
    required this.iniciarReiniciarPlanificador,
    required this.planificadorColas,
  }) : super(key: key);

  final VoidCallback iniciarReiniciarPlanificador;
  final VoidCallback planificadorColas;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int i = 0;

  set setIndex(int index) {
    i = index;
    setState(() {});
  }

  get getIndex => i;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        print(value);
        setIndex = value;
        if (value == 0) {
          widget.iniciarReiniciarPlanificador();
        }
        if (value == 1) {
          widget.planificadorColas();
        }
      },
      currentIndex: getIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.star_half),
            label: 'Iniciar/Reiniciar'),
        BottomNavigationBarItem(
            icon: Icon(Icons.skip_next_outlined), label: 'Next Quantum'),
      ],
    );
  }
}
