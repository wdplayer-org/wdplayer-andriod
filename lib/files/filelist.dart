import 'package:flutter/material.dart';

class FielList extends StatefulWidget {
  const FielList({
    super.key,
    this.location,
    this.onCheck,
    this.onTap,
  });

  final String? location;

  final void Function(bool value)? onCheck;

  final VoidCallback? onTap;

  @override
  State<FielList> createState() => _FielListState();
}

class _FielListState extends State<FielList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('文件名'),
                trailing: Checkbox(
                  value: false,
                  onChanged: (value) => widget.onCheck?.call(value!),
                ),
                onTap: widget.onTap,
              );
            },
          );
        }
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
