import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web Content',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebContentPlugin webContentPlugin = WebContentPlugin();
  StoragePlugin storagePlugin = StoragePlugin();

  var api =
      'https://raw.githubusercontent.com/pangphannarupp/contents/main/api.json?r=${Random().nextInt(1000)}';
  bool isProduction = false;
  String contentServerPath = '';
  String contentVersion = '108';
  String contentPath = 'Local';

  void startWebContent() async {
    webContentPlugin.start(
      api: api,
      contentLocalPath: 'http://192.168.100.18:8080/',
      contentServerPath: contentServerPath,
      contentVersion: contentVersion,
      isProduction: isProduction,
      contentPath: contentPath,
    );
  }

  void checkServerInformation() async {
    var contentPathFromStorage = await storagePlugin.get(key: 'content_path');
    if (contentPathFromStorage['value'] == 'Local' ||
        (contentPath == 'Local' && contentPathFromStorage['value'] == '')) {
      var response = await webContentPlugin.getServerInformation(api: api);
      if (response != null) {
        var contentVersionFromServer = response['content_version'];
        if (int.parse(contentVersionFromServer) <= int.parse(contentVersion)) {
          storagePlugin.save(key: 'content_version', value: contentVersion);
        }

        setState(() {
          contentServerPath = response['content_server_path'];
          contentVersion = contentVersionFromServer;
        });
      }
    }

    startWebContent();
  }

  @override
  void initState() {
    checkServerInformation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Welcome to',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Integration flutter with web content',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ]),
      ),
    );
  }
}
