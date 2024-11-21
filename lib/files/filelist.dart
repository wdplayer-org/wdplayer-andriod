import 'package:flutter/material.dart';
import 'package:wdplayer/files/childpage.dart';
import 'package:wdplayer/utils/funcs.dart';
import 'package:wdplayer/utils/store.dart';

class FielList extends StatefulWidget {
  const FielList({
    super.key,
    this.location,
    required this.conf,
  });

  final String? location;

  final WDConf conf;

  @override
  State<FielList> createState() => _FielListState();
}

class _FielListState extends State<FielList> {
  late Future<List<WDFile>> _futureFiles;

  @override
  void initState() {
    super.initState();
    _futureFiles = _fetchFiles();
  }

  _fetchFiles() {
    return widget.conf.fetchFiles(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureFiles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final files = snapshot.data!;
          if (files.isEmpty) {
            return const _EmptyList();
          }
          return _List(
            files: files,
            conf: widget.conf,
          );
        }
        if (snapshot.hasError) {
          return _ConnectError(
            errorMsg: snapshot.error.toString(),
            reTry: () {
              setState(() {
                _futureFiles = _fetchFiles();
              });
            },
          );
        }
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.files,
    required this.conf,
  });

  final List<WDFile> files;
  final WDConf conf;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: files.length,
      prototypeItem: ListTile(
        title: Text(files.first.name),
      ),
      itemBuilder: (context, index) {
        final file = files[index];
        late IconData icon;
        bool canCheck = true;
        bool isFolder = file.isDir;
        String fileName = file.name;
        if (isFolder) {
          icon = Icons.folder;
        } else if (isVideoFile(fileName)) {
          icon = Icons.video_file;
        } else {
          canCheck = false;
          icon = Icons.insert_drive_file;
        }
        return ListenableBuilder(
          listenable: file,
          builder: (context, child) {
            return ListTile(
              leading: Icon(icon),
              title: Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: canCheck
                  ? Checkbox(
                      tristate: true,
                      value: file.checked,
                      onChanged: (value) => file.setChecked(value ?? false),
                    )
                  : null,
              onTap: isFolder
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FileChildPage(
                              conf: conf,
                              location: file.path,
                            );
                          },
                        ),
                      );
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}

class _ConnectError extends StatelessWidget {
  const _ConnectError({
    required this.errorMsg,
    required this.reTry,
  });

  final String errorMsg;
  final VoidCallback reTry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 96,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(
            height: 16,
          ),
          Text('连接异常，请检查WebDAV配置和网络连接。'),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () {
                  showAlertDialog(
                    context,
                    title: '异常详情',
                    text: errorMsg,
                  );
                },
                child: Text('详情'),
              ),
              SizedBox(
                width: 16,
              ),
              FilledButton(
                onPressed: () {
                  reTry();
                },
                child: Text('重试'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 96,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(
            height: 16,
          ),
          Text('目录为空'),
        ],
      ),
    );
  }
}
