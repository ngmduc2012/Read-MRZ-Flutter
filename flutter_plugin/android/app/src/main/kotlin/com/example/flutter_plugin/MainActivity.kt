package com.example.flutter_plugin

import com.example.flutter_plugin.camera.NativeViewFactory

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("camera", NativeViewFactory(flutterEngine.dartExecutor.binaryMessenger))

    }
}


