import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ful_app/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // runApp前に多言語対応（mainをasyncにする）
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  runApp(EasyLocalization(
    child: const MainScreen(),
    supportedLocales: const [Locale('ja', 'JP'), Locale('en', 'US')],
    path: 'assets/translations',
    fallbackLocale: const Locale('ja', 'JP'), // default lang
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  var _conviction = 'Your life is yours.';
  // int _counter = 0;
  // var _message = tr('conviction_label');

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //     _message = 'change';
  //   });
  // }

  Future<void> _getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _conviction = prefs.getString('conviction') ?? 'Your life is yours.';
    });
  }

  @override
  Widget build(BuildContext context) {
    _getShared();
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('app_name')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _conviction,
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "heroMain",
        // onPressed: _incrementCounter,
        onPressed: () {
          // 設定画面へ遷移する
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
