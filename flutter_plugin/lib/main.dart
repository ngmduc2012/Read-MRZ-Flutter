import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'Camera/camera_kit_controller.dart';
import 'Camera/camera_kit_view.dart';
import 'dart:developer' as developer;
import 'ReadMRZ/ReadMRZcode.dart';
import 'ShowMRZ/NativeCallBack.dart';
import 'ShowMRZ/ShowMRZ.dart';
import 'package:permission_handler/permission_handler.dart';

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

class MyHomePage extends StatelessWidget  {
  final cameraKitController = CameraKitController();

  // GlobalKey _cameraViewKey = GlobalKey();
  NativeCallBack controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NativeCallBack>(
        create: (context) => NativeCallBack(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [
            Positioned.fill(
              child:
                  // Column(
                  //   children: [
                  // AspectRatio(
                  //   key: _cameraViewKey,
                  //   aspectRatio: 3 / 6,
                  //   child:
                  Consumer<NativeCallBack>(
                builder: (context, mymodel, child) {

                  return CameraKitView(
                      hasFaceDetection: true,
                      cameraKitController: cameraKitController,
                      cameraPosition: CameraPosition.front,
                      showTextResult: (String text) {
                        // mymodel.codeMRZ = text;
                        if(mymodel.stopCallBack){
                          mymodel.notifyText(text, context);
                          mymodel.stopCallBack = false;
                          // mymodel.stopCallBackNative();
                        }
                        // developer.log("+++(mymodel.stopCallBack)++++${mymodel.stopCallBack}", name: 'ok');
                      });
                },
              ),
              // ),
              // Consumer<NativeCallBack>(builder: (context, mymodel, child) {
              //   return ElevatedButton(
              //       child: Text('Get MRZ'),
              //       onPressed: () {
              //         mymodel.getMRZ();
              //       });
              // }),
              // Consumer<NativeCallBack>(builder: (context, mymodel, child) {
              //   return Text(mymodel._codeMRZ);
              // }),
              //   ],
              // ),
            ),
            _buildCropBox(),
            _buildCropBoxDetail(),
          ]),
        ));
  }

  Widget _buildCropBox() {
    return Positioned.fill(
        child: Container(
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black26.withOpacity(0.5), BlendMode.srcOut),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 450,
                ),
                margin: const EdgeInsets.only(
                    top: 50, left: 20, right: 200, bottom: 20),
                child: AspectRatio(
                  aspectRatio: 0.2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      // borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Positioned _buildCropBoxDetail() {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 450,
              ),
              margin: const EdgeInsets.only(
                  top: 50, left: 20, right: 200, bottom: 20),
              child: AspectRatio(
                aspectRatio: 0.2,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      //
                      // color: Colors.amber
                    ),
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        // constraints:
                        //     const BoxConstraints(maxHeight: 500, maxWidth: 200),
                        decoration: BoxDecoration(
                            // color: Colors.black87,
                            // borderRadius: BorderRadius.circular(20),
                            ),
                        alignment: Alignment.center,
                        child:
                            RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                          "I < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < < <",
                          style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontFamily: "Times New Roman"),
                        ),
                            )
                      ),
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 550,
              ),
              margin: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 20),
              child: AspectRatio(
                aspectRatio: 0.45,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      // borderRadius: BorderRadius.circular(20),
                    ),
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        constraints:
                            const BoxConstraints(maxHeight: 60, maxWidth: 200),
                        decoration: BoxDecoration(
                          // color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        // child: Text(
                        //   "??ang ch???p, vui l??ng c???m ch???c thi???t b??? c???a b???n...",
                        //   style: TextStyle(color: Colors.white),
                        // ),
                      ),
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                margin: const EdgeInsets.only(
                   right: 40, bottom: 40),
                child: Consumer<NativeCallBack>(
                    builder: (context, mymodel, child) {
                  return IconButton(
                    icon: Icon(
                      mymodel.flashicon,
                      color: Colors.white,
                      size: 49,
                    ),
                    onPressed: () {
                      mymodel.btnFlashlight();
                      developer.log("+++++ permission", name: 'ok');
                      mymodel.requestPermission(Permission.storage);
                      mymodel.requestPermission(Permission.camera);
                    },
                  );
                })),
          ),
        ],
      ),
    );
  }
}
