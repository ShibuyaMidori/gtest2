import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ful_app/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/statics.dart';

void main() async {
  // runApp前に多言語対応（mainをasyncにする）
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  runApp(EasyLocalization(
    child: const MainScreen(),
    supportedLocales: const [Locale('ja', 'JP'), Locale('en', 'US')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en', 'US'), // default lang
  ));
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/settings': (context) => const SettingsPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  var _belief = Statics.defaultBelief;

  Future<void> _getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _belief =
          prefs.getString(Statics.belief) ?? Statics.defaultBelief;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getShared();
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(Statics.appName)),
      ),
      body: Center(
        child: Text(
          _belief,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 設定画面へ遷移する
          Navigator.pushNamed(context, '/settings');
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
