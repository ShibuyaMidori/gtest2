import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ful_app/settings.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _message = tr('conviction_label');

  void _incrementCounter() {
    setState(() {
      _counter++;
      _message = 'change';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('app_name')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _message,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
