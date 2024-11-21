import 'package:flutter/material.dart';
import 'package:wdplayer/files/firstpage.dart';
import 'package:wdplayer/utils/store.dart';
import 'package:wdplayer/utils/widgets.dart';

class EditLibPage extends StatefulWidget {
  const EditLibPage({
    super.key,
    this.conf,
  });

  final WDConf? conf;

  @override
  State<StatefulWidget> createState() => _EditLibState();
}

class _EditLibState extends State<EditLibPage> {
  final _formKey = GlobalKey<FormState>();

  late final WDConf _conf;

  late String _defPort;

  @override
  void initState() {
    super.initState();
    _defPort = '80';
    _conf = widget.conf ?? WDConf();
  }

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
                initialValue: _conf.name,
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
                initialValue: _conf.host,
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
                      initialValue: _conf.port?.toString(),
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
                initialValue: _conf.username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '账号',
                ),
                onSaved: (value) {
                  _conf.username = value;
                },
              ),
              PasswordField(
                initialValue: _conf.password,
                labelText: '密码',
                onSaved: (value) {
                  _conf.password = value;
                },
              ),
              TextFormField(
                initialValue: _conf.path,
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
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileFirstPage(conf: _conf),
              ),
            );
          },
          child: Text('确定'),
        ),
      ),
    );
  }
}
