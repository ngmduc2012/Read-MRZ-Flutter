import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camera_kit_controller.dart';
import 'camera_kit_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final cameraKitController = CameraKitController();
  GlobalKey _cameraViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
        create: (context) => MyModel(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              AspectRatio(
                key: _cameraViewKey,
                aspectRatio: 4 / 6,
                child: CameraKitView(
                  hasFaceDetection: true,
                  cameraKitController: cameraKitController,
                  cameraPosition: CameraPosition.front,
                ),
              ),
              Consumer<MyModel>(builder: (context, mymodel, child) {
                return ElevatedButton(
                  child: Text('Get MRZ'),
                  onPressed: (){
                      mymodel.getMRZ();
                  }
                );
              }),
              Consumer<MyModel>(builder: (context, mymodel, child) {
                return Text(mymodel._codeMRZ);
              }),
            ],
          ),
        ));
  }
}

class MyModel with ChangeNotifier {
  static const platform = const MethodChannel('codeMRZ');
  String _codeMRZ = 'No MRZ';

  Future<String> getMRZ() async {
    String codeMRZ;
    try {
      final String result = await platform.invokeMethod('getMRZ');
      codeMRZ = 'MRZ: $result';
    } on PlatformException catch (e) {
      codeMRZ = "Không lấy được MRZ: '${e.message}'.";
    }
    _codeMRZ = codeMRZ;
    notifyListeners();
    return _codeMRZ;
  }
  notifyListeners();
}
