import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _nfcData = '';
  bool _nfcReading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    print('init state method');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await FlutterNfcReader.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    print('mounted: $mounted');
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> startNFC() async {

    print('from startNFC() method');

    String response;
    bool reading = true;

    try {
      print('try...');

      response = await FlutterNfcReader.read;

      reading = false;
    } on PlatformException {
      response = '';
      reading = false;
    }
    setState(() {
      _nfcReading = reading;
      _nfcData = response;
    });
  }

  Future<void> stopNFC() async {

    print('from stopNFC() method');

    bool response;
    try {
      final bool result = await FlutterNfcReader.stop;
      response = result;
    } on PlatformException {
      response = false;
    }
    setState(() {
      _nfcReading = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Redsys NFC Crossplatform reader'),
          ),
          body: new SafeArea(
            top: true,
            bottom: true,
            child: new Center(
              child: ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 10.0,
                  ),
                  new Text(
                    'Running on: $_platformVersion\n',
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    'NFC is Reading: $_nfcReading\n',
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    'NFC Data: $_nfcData\n',
                    textAlign: TextAlign.center,
                  ),
                  new RaisedButton(
                    child: Text('Start NFC'),
                    onPressed: () {
                      startNFC();
                    },
                  ),
                  new RaisedButton(
                    child: Text('Stop NFC'),
                    onPressed: () {
                      stopNFC();
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
