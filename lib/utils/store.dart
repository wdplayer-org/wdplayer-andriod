import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'store.g.dart';

@collection
class WDConf {
  Id? id;
  late String name;
  late String host;
  @enumerated
  Proto proto = Proto.http;
  int? port;
  String? username;
  String? password;
  String? path;
  List<String> dirs = [];

  String getUrl() {
    return '${proto.name}://$host${port != null ? ':$port' : ''}$path';
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
