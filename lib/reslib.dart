import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:wdplayer/editlib.dart';
import 'package:wdplayer/libcard.dart';
import 'package:wdplayer/utils/store.dart';

class ResLibPage extends StatefulWidget {
  const ResLibPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResLibPageState();
}

Future<List<WDConf>> _fetchConfs() async {
  final isar = await getIsar();
  return isar.wDConfs.where().findAll();
}

class _ResLibPageState extends State<ResLibPage> {
  late Future<List<WDConf>> _futureConfs;

  @override
  void initState() {
    super.initState();
    _futureConfs = _fetchConfs();
  }

  @override
  Widget build(BuildContext context) {
    getIsar().then((isar) {
      Stream<void> changed = isar.wDConfs.watchLazy();
      changed.listen((e) {
        setState(() {
          _futureConfs = _fetchConfs();
        });
      });
    });
    final theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder(
        future: _futureConfs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final confs = snapshot.data!;
            return Column(
              children: confs.map((conf) {
                return LibCard(conf: conf);
              }).toList(),
            );
          }
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
      floatingActionButton: OpenContainer(
        tappable: false,
        closedBuilder: (BuildContext context, callback) {
          return FloatingActionButton(
            elevation: 0,
            onPressed: callback,
            shape: Border(),
            child: Icon(Icons.add),
          );
        },
        closedElevation: theme.floatingActionButtonTheme.elevation ?? 6,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        closedColor: theme.floatingActionButtonTheme.backgroundColor ??
            theme.colorScheme.primaryContainer,
        openBuilder: (BuildContext context, callback) {
          return const EditLibPage();
        },
      ),
    );
  }
}
