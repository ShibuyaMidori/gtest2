import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      title: 'Flutter Demo',
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
  var _conviction = 'Your life is yours.';

  Future<void> _getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _conviction = prefs.getString('conviction') ?? 'Your life is yours.';
    });
  }

  Future<void> _setShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('conviction', 'counter 2');
  }

  @override
  Widget build(BuildContext context) {
    _getShared();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 戻るボタンを無効化
        title: Text(tr('app_name')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            // style: TextStyle(),
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            maxLines: 4,
            controller: TextEditingController(text: _conviction), // 初期値
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "heroSettings",
        onPressed: () {
          // 設定値を保存する
          _setShared();
          // Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
