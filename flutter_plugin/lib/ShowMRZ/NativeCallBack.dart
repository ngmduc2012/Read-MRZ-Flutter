import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/ReadMRZ/ReadMRZcode.dart';
import 'ShowMRZ.dart';
import 'dart:developer' as developer;
import 'package:permission_handler/permission_handler.dart';

class NativeCallBack with ChangeNotifier {
  String codeMRZ = 'No MRZ';
  bool stopCallBack = true;

  Future<String> nativeMethodCallHandler(MethodCall methodCall) async {
    if (methodCall.method == "callBack" && stopCallBack) {
      codeMRZ = methodCall.arguments;
      // developer.log("+++++++${methodCall.arguments}", name: 'ok');
      notifyListeners();
    }
    return codeMRZ;
  }

  void notifyText(String text, BuildContext buildContext) async {
    codeMRZ = """
    
    documentNumber          : ${readMRZ().documentNumber(text)}
    expiryDate              : ${readMRZ().expiryDate(text)}
    birthDate               : ${readMRZ().birthDate(text)}
    
    documentType            : ${readMRZ().documentType(text)}
    countryCode             : ${readMRZ().countryCode(text)}
    documentNumberCheckDigit: ${readMRZ().documentNumberCheckDigit(text)}
    optionalData            : ${readMRZ().optionalData(text)}
    Birth Day               : ${readMRZ().showBirthDate(text)}
    birthDateCheckDigit     : ${readMRZ().birthDateCheckDigit(text)}
    sex                     : ${readMRZ().sex(text)}
    Date of Expiry          : ${readMRZ().showExpiryDate(text)}
    expiryDateCheckDigit    : ${readMRZ().expiryDateCheckDigit(text)}
    nationality             : ${readMRZ().nationality(text)}
    optionalData2           : ${readMRZ().optionalData2(text)}
    finalCheckDigit         : ${readMRZ().finalCheckDigit(text)}
    names                   : ${readMRZ().names(text)}
    """;
    stopCallBack = await Navigator.push(buildContext,
        MaterialPageRoute(builder: (context) => ShowMRZ(codeMRZ: codeMRZ)));
  }

  bool hasflashlight = false;
  bool isturnon = false;
  IconData flashicon = Icons.flash_off;
  static const platform = const MethodChannel('FlashLight');

  Future<void> btnFlashlight() async {
    try {
      isturnon = !await platform.invokeMethod('btnFlashLight');
      // isturnon = !isturnon;
      if (isturnon) {
        flashicon = Icons.flash_on;
      } else {
        flashicon = Icons.flash_off;
      }
      notifyListeners();
    } on PlatformException catch (e) {}
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    developer.log("$status +++++ ",name: "ok");
    print(status);
    _permissionStatus = status;
    print(_permissionStatus);
    notifyListeners();
  }
}
