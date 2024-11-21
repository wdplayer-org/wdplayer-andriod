import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart';
import 'package:path/path.dart' as p;

part 'store.g.dart';

@collection
class WDConf {
  Id? id;
  String? name;
  String? host;
  @enumerated
  Proto proto = Proto.http;
  int? port;
  String? username;
  String? password;
  String? path;

  List<String> get checkedFiles {
    return _rootFile.getAllChecked().map((file) => file.path).toList();
  }

  set checkedFiles(List<String> v) {
    _checkedFiles = v;
  }

  List<String> _checkedFiles = [];

  final WDFile _rootFile = WDFile(File(
    path: '/',
    isDir: true,
  ));

  final Map<String, WDFile> _filesMap = {};

  Client? _client;

  String _getUrl() {
    return '${proto.name}://$host${port != null ? ':$port' : ''}$path';
  }

  Future<void> ping() async {
    await _getClient().ping();
  }

  Client _getClient() {
    if (_client == null) {
      _client = newClient(
        _getUrl(),
        user: username ?? '',
        password: password ?? '',
      );
      _client!.setConnectTimeout(8000);
    }
    return _client!;
  }

  Future<List<WDFile>> fetchFiles(String? parent) async {
    if (parent == null || parent == '/') {
      if (_rootFile.children == null) {
        await _fetchOriginFile(_rootFile);
      }
      return _rootFile.children!;
    }
    WDFile? parentFile = _filesMap[parent];
    if (parentFile == null) {
      // 上级文件不存在，需要先请求。
      parent = p.dirname(parent);
      await fetchFiles(parent);
    }
    parentFile = _filesMap[parent]!;
    if (parentFile.children == null) {
      await _fetchOriginFile(parentFile);
    }
    return parentFile.children!;
  }

  Future<void> _fetchOriginFile(WDFile parent) async {
    final files = await _getClient().readDir(parent.path);
    final wdFiles = files.map((file) {
      final wdFile = WDFile(file);
      wdFile.parent = parent;
      final path = wdFile.path;
      _filesMap[path] = wdFile;
      if (parent.checked != null) {
        wdFile.checked = parent.checked;
      } else {
        if (_checkedFiles.contains(path)) {
          wdFile.checked = true;
        } else if (_checkedFiles.any((checked) => p.isWithin(path, checked))) {
          // 选中的是当前文件的下级，则当前文件部分选中。
          wdFile.checked = null;
        } else {
          wdFile.checked = false;
        }
      }
      return wdFile;
    }).toList();
    parent.children = wdFiles;
  }
}

class WDFile extends ChangeNotifier {
  WDFile(this._file);

  final File _file;

  String get name {
    return _file.name ?? '';
  }

  String get path {
    return _file.path!;
  }

  bool get isDir {
    return _file.isDir ?? false;
  }

  /// 部分选中时为null
  bool? checked;

  List<WDFile>? children;

  WDFile? parent;

  /// 获取所有勾选的文件，包括下级。
  /// 如果上级已经勾选或者未勾选，则不需要遍历下级，只有上级部分勾选时才需要遍历下级
  List<WDFile> getAllChecked() {
    final List<WDFile> checkedFiles = [];
    if (checked != null) {
      if (checked!) {
        checkedFiles.add(this);
      }
      return checkedFiles;
    }
    if (children == null) {
      return checkedFiles;
    }
    for (var child in children!) {
      checkedFiles.addAll(child.getAllChecked());
    }
    return checkedFiles;
  }

  void setChecked(bool? checked) {
    if (this.checked == checked) {
      return;
    }
    this.checked = checked;
    notifyListeners();
    if (checked == null) {
      // 当前节点部分勾选，则上级也部分勾选
      parent?.setChecked(checked);
      return;
    }
    // 勾选或者取消勾选，所有下级都需要同步
    if (children != null) {
      for (var child in children!) {
        child.setChecked(checked);
      }
    }
    if (parent == null) {
      return;
    }
    // 根据同级节点的状态，更新上级节点
    final siblings = parent!.children!;
    if (!checked) {
      // 取消勾选时，同级节点都未勾选，则上级也未勾选，否则上级部分勾选，
      if (siblings.every((s) => s.checked == false)) {
        parent!.setChecked(false);
      } else {
        parent!.setChecked(null);
      }
    } else {
      // 勾选时，同级节点都勾选，则上级也勾选，否则上级部分勾选。
      if (siblings.every((s) => s.checked == true)) {
        parent!.setChecked(true);
      } else {
        parent!.setChecked(null);
      }
    }
  }
}

enum Proto { http, https }

Isar? isar;
Future<Isar> getIsar() async {
  if (isar != null) {
    return isar!;
  }
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [WDConfSchema],
    directory: dir.path,
  );
  return isar!;
}
