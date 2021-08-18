import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureToImage extends StatefulWidget {
  @override
  _SignatureToImageState createState() => _SignatureToImageState();
}

class _SignatureToImageState extends State<SignatureToImage> {
  //we create Global key that is SfSignaturePadState type so that we can use this
  //global key to access function of signature pad like ioImage,toClear etc.
  //so to access the state of signature pad we need to have global key.
  //we pass this key to ui SfSignaturePad
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  //we want to call request permission method to call first when we open the app
  //we put requestPermission method in initState()
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

//this method need for request permission from user to save images
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

//the clear method is define in state of signaturePad so we use signatureGlobalKey
//to clear the SignaturePad
  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState.clear();
  }

  void _handleSaveButtonPressed() async {
    //to access only SignaturePad area we use RenderSignaturePad Boundary
    RenderSignaturePad boundary = signatureGlobalKey.currentContext
        .findRenderObject() as RenderSignaturePad;
    //it convert it to image
    ui.Image image = await boundary.toImage();
    //we convert it to byte Code Data type .png
    ByteData byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final time = DateTime.now().millisecond;
      final name = "signature_$time";
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: name);
      print(result);
      _toastInfo(result.toString());

      final isSuccess = result['isSuccess'];
      signatureGlobalKey.currentState.clear();
      if (isSuccess) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Container(
                    color: Colors.grey[300],
                    child: Image.memory(byteData.buffer.asUint8List()),
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

//to Show a Toast
  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(info),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: SfSignaturePad(
                key: signatureGlobalKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.red,
                minimumStrokeWidth: 4.0,
                maximumStrokeWidth: 8.0,
              ),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              TextButton(
                onPressed: _handleSaveButtonPressed,
                child: Text(
                  "Save as Image",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _handleClearButtonPressed,
                child: Text(
                  "Clear",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
    );
  }
}

/** Syncfusion Flutter SignaturePad =>
 * This library is used to capture a signature through drawing gestures. You
 * can use your finger, pen, or mouse on a tablet, touchscreen, etc., to draw
 * your own signature in this SignaturePad widget. The widget also allows you
 * to save a signature as an image, which can be further synchronized with your
 * documents that need the signature.*/

/**Permission Handler =>
 * On most operating systems, permissions aren't just granted to apps at install
 * time. Rather, developers have to ask the user for permissions while the app
 * is running.

    This plugin provides a cross-platform (iOS, Android) API to request
    permissions and check their status. You can also open the device's
    app settings so users can grant a permission.
    On Android, you can show a rationale for requesting a permission.*/

/** Image Picker
 * We use the image_picker plugin to select images from the Android and iOS
 * image library, but it can't save images to the gallery. This plugin can
 * provide this feature.

    To use this plugin, add image_gallery_saver as a dependency in your pubspec.yaml file*/

/** Global keys =>
 * A key that is unique across the entire app.
    Global keys uniquely identify elements. Global keys provide access to other
    objects that are associated with those elements, such as BuildContext. For
    StatefulWidgets, global keys also provide access to State.

    Widgets that have global keys reparent their subtrees when they are moved
    from one location in the tree to another location in the tree. In order to
    reparent its subtree, a widget must arrive at its new location in the tree
    in the same animation frame in which it was removed from its old location
    in the tree.*/
