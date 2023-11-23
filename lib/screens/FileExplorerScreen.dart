import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileExplorerScreen extends StatefulWidget {
  final Function(String) onFileSelected;

  const FileExplorerScreen({Key? key, required this.onFileSelected})
      : super(key: key);

  @override
  _FileExplorerScreenState createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends State<FileExplorerScreen> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> fileList = directory.listSync();
      setState(() {
        files = fileList;
      });
    } catch (e) {
      print('Error al cargar archivos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorador de Archivos'),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(files[index].uri.pathSegments.last),
            onTap: () {
              // widget.onFileSelected(files[index].uri.path);
              Navigator.pop(context, files[index].uri.path);
              print('VOLVER');
            },
          );
        },
      ),
    );
  }
}
