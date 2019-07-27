import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.green, accentColor: Colors.green),
      home: MyHomePage(title: 'Alphabet Scroll Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final List<String> alphabetList = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _animalList = [];
  ScrollController _animalListController = ScrollController();

  double itemHeight = 24.0;

  double alphabetScrollHeight;
  double scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _getAnimalList().then((value) {
      setState(() {
        _animalList = value.map((v) {
          // Capitalize
          return v[0].toUpperCase() + v.substring(1);
        }).toList();
      });
    });
  }

  Future<List<String>> _getAnimalList() async {
    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/animal_list.json");
    final List<dynamic> jsonResult = jsonDecode(data);
    return jsonResult.cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            alphabetScrollHeight = constraints.biggest.height;
            return Stack(
              children: <Widget>[
                ListView.builder(
                  controller: _animalListController,
                  itemCount: _animalList.length,
                  itemExtent: itemHeight,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(_animalList[index]);
                  },
                ),
                Positioned(
                  right: 0,
                  child: LayoutBuilder(
                    builder: (_, BoxConstraints constraints) {
                      alphabetScrollHeight = constraints.biggest.height;
                      return GestureDetector(
                        onVerticalDragStart:
                            (DragStartDetails dragStartDetails) {
                          print(dragStartDetails.localPosition.dy);
                          _scroll(dragStartDetails.localPosition.dy);
                        },
                        onVerticalDragUpdate:
                            (DragUpdateDetails dragUpdateDetails) {
                          print(dragUpdateDetails.localPosition.dy);
                          _scroll(dragUpdateDetails.localPosition.dy);
                        },
                        child: LayoutBuilder(
                          builder: (_, BoxConstraints constraints) {
                            alphabetScrollHeight = constraints.biggest.height;
                            return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: widget.alphabetList
                                    .map((value) => Container(
                                          height: 16,
                                          child: Text(value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2),
                                        ))
                                    .toList());
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ));
  }

  _scroll(double newPosition) {
    scrollPosition = newPosition;

    // Calculate what letter we are at
    // int alphabetIndex = (alphabetScrollHeight / scrollPosition).floor();
    int alphabetIndex = (scrollPosition / 16).floor();
    String alphabet = widget.alphabetList[alphabetIndex];

    // Get the first item in our list for that alphabet
    int animalIndex = _animalList.indexWhere(
        (value) => value.toLowerCase().startsWith(alphabet.toLowerCase()));

    // Find the position to scroll to based on the height of each list item
    _animalListController.jumpTo(animalIndex * itemHeight);
  }
}
