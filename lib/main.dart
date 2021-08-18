import 'package:flutter/material.dart';

import 'circular_bottom_bar.dart';

void main() => runApp(
      MaterialApp(
        title: 'Flutter Palette Generator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CircularBottomBar(),
      ),
    );
