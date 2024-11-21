import 'package:flutter/material.dart';
import 'package:wdplayer/files/filelist.dart';
import 'package:wdplayer/utils/store.dart';
import 'package:path/path.dart' as p;

class FileChildPage extends StatelessWidget {
  const FileChildPage({
    super.key,
    required this.conf,
    required this.location,
  });

  final WDConf conf;
  final String location;

  @override
  Widget build(BuildContext context) {
    final name = p.basename(location);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('当前位置: $location'),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: FielList(
              conf: conf,
              location: location,
            ),
          ),
        ],
      ),
    );
  }
}
