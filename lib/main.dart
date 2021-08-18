import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(MaterialApp(
      title: 'Flutter Palette Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    ));
