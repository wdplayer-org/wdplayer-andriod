import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

showAlertDialog(
  BuildContext context, {
  String title = '',
  String text = '',
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(text),
        ),
        actions: [
          TextButton(
            child: const Text('关闭'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showConfirmDialog(
  BuildContext context, {
  String title = '',
  String text = '',
  VoidCallback? onOK,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(text),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              onOK?.call();
              Navigator.of(context).pop();
            },
            child: Text('确定'),
          ),
        ],
      );
    },
  );
}

showSnackBar(
  BuildContext context, {
  required String text,
  SnackBarAction? action,
}) {
  final snackBar = SnackBar(
    content: Text(text),
    action: action,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isVideoFile(String fileName) {
  String? mime = lookupMimeType(fileName);
  if (mime == null) {
    return false;
  }
  if (mime.startsWith('video/')) {
    return true;
  }
  return false;
}
