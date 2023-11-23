class PCB {
  static int _nextPid = 1;
  int pid;
  String nombre;
  int cantq;
  int prioridad;
  int qxcola;
  int? qxFinalizar;

  PCB({
    required this.pid,
    required this.nombre,
    required this.cantq,
    required this.prioridad,
    required this.qxcola,
    this.qxFinalizar,
  });

  factory PCB.create({
    required String nombre,
    required int cantq,
    required int prioridad,
    required int qxcola,
    int? qxFinalizar,
  }) {
    final nuevoPid = _nextPid;
    _nextPid++;
    return PCB(
      pid: nuevoPid,
      nombre: nombre,
      cantq: cantq,
      prioridad: prioridad,
      qxcola: qxcola,
      qxFinalizar: qxFinalizar,
    );
  }

//------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'nombre': nombre,
      'cantq': cantq,
      'prioridad': prioridad,
      'qxcola': qxcola,
      'qxFinalizar': qxFinalizar,
    };
  }

  factory PCB.fromMap(Map<String, dynamic> map) {
    return PCB(
      pid: map['pid'],
      nombre: map['nombre'],
      cantq: map['cantq'],
      prioridad: map['prioridad'],
      qxcola: map['qxcola'],
      qxFinalizar: map['qxFinalizar'],
    );
  }
}
