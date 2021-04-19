import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'Camera/camera_kit_controller.dart';
import 'Camera/camera_kit_view.dart';
import 'dart:developer' as developer;
import 'ReadMRZ/ReadMRZcode.dart';

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
  NativeCallBack controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NativeCallBack>(
        create: (context) => NativeCallBack(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              AspectRatio(
                key: _cameraViewKey,
                aspectRatio: 5 / 6,
                child: Consumer<NativeCallBack>(
                  builder: (context, mymodel, child) {
                    return CameraKitView(
                        hasFaceDetection: true,
                        cameraKitController: cameraKitController,
                        cameraPosition: CameraPosition.front,
                        showTextResult: (String text) {
                          mymodel._codeMRZ = text;
                          mymodel.notifyText(text);
                          // developer.log("+++++++${text}", name: 'ok');
                        });
                  },
                ),
              ),
              // Consumer<NativeCallBack>(builder: (context, mymodel, child) {
              //   return ElevatedButton(
              //       child: Text('Get MRZ'),
              //       onPressed: () {
              //         mymodel.getMRZ();
              //       });
              // }),
              Consumer<NativeCallBack>(builder: (context, mymodel, child) {
                return Text(mymodel._codeMRZ);
              }),
            ],
          ),
        ));
  }
}

class NativeCallBack with ChangeNotifier {
  String _codeMRZ = 'No MRZ';

  Future<String> nativeMethodCallHandler(MethodCall methodCall) async {
    // channelCallBack.setMethodCallHandler(nativeMethodCallHandler);
    if (methodCall.method == "callBack") {
      _codeMRZ = methodCall.arguments;
      // developer.log("+++++++${methodCall.arguments}", name: 'ok');
      notifyListeners();
    }
    return _codeMRZ;
  }

  void notifyText(String text) {
    _codeMRZ = """
    documentType            : ${readMRZ().documentType(text)}
    countryCode             : ${readMRZ().countryCode(text)}
    documentNumber          : ${readMRZ().documentNumber(text)}
    documentNumberCheckDigit: ${readMRZ().documentNumberCheckDigit(text)}
    optionalData            : ${readMRZ().optionalData(text)}
    birthDate               : ${readMRZ().birthDate(text)}
    birthDateCheckDigit     : ${readMRZ().birthDateCheckDigit(text)}
    sex                     : ${readMRZ().sex(text)}
    expiryDate              : ${readMRZ().expiryDate(text)}
    expiryDateCheckDigit    : ${readMRZ().expiryDateCheckDigit(text)}
    nationality             : ${readMRZ().nationality(text)}
    optionalData2           : ${readMRZ().optionalData2(text)}
    finalCheckDigit         : ${readMRZ().finalCheckDigit(text)}
    names                   : ${readMRZ().names(text)}
    """;
    notifyListeners();
  }

  notifyListeners();
}
