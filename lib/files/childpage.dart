import 'package:flutter/material.dart';
import 'package:wdplayer/files/filelist.dart';

class FileChildPage extends StatefulWidget {
  const FileChildPage({
    super.key,
    required this.location,
  });

  final String location;

  @override
  State<FileChildPage> createState() => _FileChildPageState();
}

class _FileChildPageState extends State<FileChildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择文件夹'),
      ),
      body: Column(
        children: [
          Text('当前位置: ${widget.location}'),
          FielList(),
        ],
      ),
    );
  }
}
