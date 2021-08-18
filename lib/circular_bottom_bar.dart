import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';

class CircularBottomBar extends StatefulWidget {
  const CircularBottomBar({Key key}) : super(key: key);

  @override
  _CircularBottomBarState createState() => _CircularBottomBarState();
}

class _CircularBottomBarState extends State<CircularBottomBar> {
  //variable to store tab position
  int tabButtonPosition = 0;
  double bottomNavBarHeight = 60;

  //create a list of tab items
  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.blue,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    TabItem(Icons.search, "Search", Colors.orange,
        labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    TabItem(Icons.layers, "Reports", Colors.red),
    TabItem(Icons.notifications, "Notifications", Colors.cyan),
  ]);

  //create  controller that will give index number of tabs
  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //start nav controller with  zero position
    _navigationController =
        CircularBottomNavigationController(tabButtonPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*Creates a stack layout widget.
      By default, the non-positioned children of the stack are aligned by their
       top left corners.*/
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color selectedColor = tabItems[tabButtonPosition].circleColor;
    String slogan;
    switch (tabButtonPosition) {
      case 0:
        slogan = "Familly, Happiness, Food";
        break;
      case 1:
        slogan = "Find, Check, Use";
        break;
      case 2:
        slogan = "Receive, Review, Rip";
        break;
      case 3:
        slogan = "Noise, Panic, Ignore";
        break;
    }

    return Container(
      color: selectedColor,
      child: Center(
        child: Text(
          slogan,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.tabButtonPosition = selectedPos;
          print(_navigationController.value);
        });
      },
    );
  }
}
