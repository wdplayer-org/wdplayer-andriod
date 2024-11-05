import 'package:flutter/material.dart';
import 'package:wdplayer/files/filelist.dart';

class FileFirstPage extends StatefulWidget {
  const FileFirstPage({super.key});

  @override
  State<FileFirstPage> createState() => _FileFirstPageState();
}

class _FileFirstPageState extends State<FileFirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择文件夹'),
      ),
      body: FielList(),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
          onPressed: () {/** */},
          child: Text('确定'),
        ),
      ),
    );
  }
}
