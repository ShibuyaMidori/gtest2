import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/statics.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 言語情報取得
    final _lang = EasyLocalization.of(context)!;

    return MaterialApp(
      // 多言語対応
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        _lang.delegate,
      ],
      supportedLocales: _lang.supportedLocales,
      locale: _lang.locale,
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _belief = Statics.defaultBelief;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _belief = prefs.getString(Statics.belief) ?? Statics.defaultBelief;
    });
  }

  Future<void> _setShared() async {
    if (_controller.text != '') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Statics.belief, _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = tr(Statics.appName);
    var hint = tr(Statics.inputHint);
    _getShared();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 戻るボタンを無効化
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              _belief,
              textAlign: TextAlign.left,
            ),
          ),
          TextFormField(
            maxLines: 4,
            controller: _controller,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: hint,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 設定値を保存する
          _setShared();
          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
