import 'package:flutter/material.dart';
import 'package:wdplayer/files/filelist.dart';
import 'package:wdplayer/utils/store.dart';

class FileFirstPage extends StatelessWidget {
  const FileFirstPage({
    super.key,
    required this.conf,
  });

  final WDConf conf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conf.name!),
      ),
      body: FielList(
        conf: conf,
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
          onPressed: () async {
            final isar = await getIsar();
            await isar.writeTxn(() async {
              await isar.wDConfs.put(conf);
            });
            if (!context.mounted) {
              return;
            }
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          },
          child: Text('确定'),
        ),
      ),
    );
  }
}
