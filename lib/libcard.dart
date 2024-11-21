import 'package:flutter/material.dart';
import 'package:wdplayer/editlib.dart';
import 'package:wdplayer/utils/funcs.dart';
import 'package:wdplayer/utils/store.dart';

class LibCard extends StatefulWidget {
  const LibCard({
    super.key,
    required this.conf,
  });

  final WDConf conf;

  @override
  State<LibCard> createState() => _LibCardState();
}

class _LibCardState extends State<LibCard> {
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text(widget.conf.name!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  /** */
                },
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EditLibPage(
                          conf: widget.conf,
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  showConfirmDialog(
                    context,
                    title: '确认删除？',
                    text: '删除后影片信息也会同步删除',
                    onOK: () async {
                      final isar = await getIsar();
                      await isar.writeTxn(() async {
                        final result =
                            await isar.wDConfs.delete(widget.conf.id!);
                        if (!context.mounted) {
                          return;
                        }
                        showSnackBar(
                          context,
                          text: result ? '删除成功' : '删除失败',
                        );
                      });
                    },
                  );
                },
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
