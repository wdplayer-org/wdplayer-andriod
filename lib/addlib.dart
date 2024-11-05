import 'package:flutter/material.dart';
import 'package:wdplayer/utils/store.dart';
import 'package:wdplayer/utils/widgets.dart';

class AddLibPage extends StatefulWidget {
  const AddLibPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddLibState();
}

class _AddLibState extends State<AddLibPage> {
  final _formKey = GlobalKey<FormState>();

  final _conf = WDConf();

  String _defPort = '80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加WebDAV'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Wrap(
            runSpacing: 20,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '名称',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '不能为空';
                  }
                  return null;
                },
                onSaved: (value) {
                  _conf.name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '地址',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '不能为空';
                  }
                  return null;
                },
                onSaved: (value) {
                  _conf.host = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownMenu<Proto>(
                      initialSelection: Proto.http,
                      expandedInsets: EdgeInsets.zero,
                      requestFocusOnTap: false,
                      label: Text('协议'),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: Proto.http,
                          label: Proto.http.name,
                        ),
                        DropdownMenuEntry(
                          value: Proto.https,
                          label: Proto.https.name,
                        ),
                      ],
                      onSelected: (value) {
                        _conf.proto = value!;
                        if (value == Proto.http) {
                          setState(() {
                            _defPort = '80';
                          });
                        } else {
                          setState(() {
                            _defPort = '443';
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '端口',
                        hintText: _defPort,
                      ),
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          _conf.port = int.parse(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '账号',
                ),
                onSaved: (value) {
                  _conf.username = value;
                },
              ),
              PasswordField(
                labelText: '密码',
                onSaved: (value) {
                  _conf.password = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '路径',
                  hintText: '如：/dav',
                ),
                onSaved: (value) {
                  _conf.path = value;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            // var client = newClient(
            //   _conf.getUrl(),
            //   user: _conf.username,
            //   password: _conf.password,
            // );
            // try {
            //   await client.ping();
            // } catch (e) {
            //   if (!context.mounted) {
            //     return;
            //   }
            //   showAlertDialog(
            //     context: context,
            //     title: '无法连接到WebDAV',
            //     text: e.toString(),
            //   );
            //   return;
            // }
            final isar = await getIsar();
            await isar.writeTxn(() async {
              await isar.wDConfs.put(_conf);
            });
            if (!context.mounted) {
              return;
            }
            Navigator.pop(context);
          },
          child: Text('确定'),
        ),
      ),
    );
  }
}
