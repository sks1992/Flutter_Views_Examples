import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteGeneratorPage extends StatefulWidget {
  @override
  _PaletteGeneratorPageState createState() => _PaletteGeneratorPageState();
}

class _PaletteGeneratorPageState extends State<PaletteGeneratorPage> {
  //create a list of images
  final List<String> images = [
    'assets/sk1.jpg',
    'assets/sk2.jpg',
    'assets/sk5.jpg'
  ];
  //create a list for Palette Colors that will store extract  colors from images
  List<PaletteColor> extractColors;
  //create a index that store state of index of images .
  int _index;

  @override
  void initState() {
    /**initState -> Called when this object is inserted into the tree.
The framework will call this method exactly once for each State object it creates.*/
    super.initState();
    extractColors = [];
    _index = 0;
    addColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Palette Generator Example'),
        elevation: 0,
        backgroundColor: extractColors.isEmpty
            ? Theme.of(context).primaryColor
            : extractColors[_index].color,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            color: extractColors.isEmpty ? Colors.white : extractColors[_index].color,
             child: PageView(
              onPageChanged: (int index) {
                setState(() {
                  _index = index;
                });
              },
              children: images
                  .map((image) => Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                              image: AssetImage(image), fit: BoxFit.cover),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: extractColors.isEmpty ? Colors.white : extractColors[_index].color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Our Amazing World",
                    style: TextStyle(
                        color: extractColors.isEmpty
                            ? Colors.black
                            : extractColors[_index].titleTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit. "
                      " Lorem ipsum dolor sit amet consectetur adipisicing elit."
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit."
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit. "
                      " Lorem ipsum dolor sit amet consectetur adipisicing elit."
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: extractColors.isEmpty
                              ? Colors.black
                              : extractColors[_index].bodyTextColor,
                          fontSize: 22.0))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void addColor() async {
    for (String image in images) {
      final PaletteGenerator pg = await PaletteGenerator.fromImageProvider(
        AssetImage(image),
        size: Size(200, 200),
      );
      extractColors.add(pg.lightVibrantColor == null
          ? PaletteColor(Colors.white, 2)
          : pg.lightVibrantColor);
    }
  }
}
/** PageView => Creates a scrollable list that works page by page from an
 * explicit List of widgets.
 * This constructor is appropriate for page views with a small number of
 * children because constructing the List requires doing work for every child
 * that could possibly be displayed in the page view, instead of just those
 * children that are actually visible.*/
