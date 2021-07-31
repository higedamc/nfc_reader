import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(child: NfcScan(key: UniqueKey(),)),
      ),
    );
  }
}

class NfcScan extends StatefulWidget {
  NfcScan({required Key key}) : super(key: key);

  @override
  _NfcScanState createState() => _NfcScanState();
}

class _NfcScanState extends State<NfcScan> {
  TextEditingController writerController = TextEditingController();
  late NFCAvailability available;

  checkNFCAvailability() async {
    available = await FlutterNfcReader.checkNFCAvailability();
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkNFCAvailability();
    });

    writerController.text = 'Flutter NFC Scan';
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      print(onData.content);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    writerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(available.toString()),
        TextField(
          controller: writerController,
        ),
        ElevatedButton(
          onPressed: () {
            FlutterNfcReader.read(instruction: "It's reading");
          },
          child: Text("Read"),
        ),
        ElevatedButton(
          onPressed: () {
            FlutterNfcReader.write(" ", writerController.text).then((value) {
              print(value.content);
            });
          },
          child: Text("Write"),
        )
      ],
    );
  }
}