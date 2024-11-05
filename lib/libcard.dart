import 'package:flutter/material.dart';
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
            leading: Icon(Icons.album),
            title: Text(widget.conf.name),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text('编辑'),
                onPressed: () {/* ... */},
              ),
              SizedBox(width: 8),
              TextButton(
                child: Text('删除'),
                onPressed: () {/* ... */},
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
