import 'package:flutter/material.dart';
import 'package:flutter_basic_views/signature_to_image.dart';

void main() => runApp(MaterialApp(
      title: 'Flutter Palette Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignatureToImage(),
    ));
