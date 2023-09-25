// ignore_for_file: unnecessary_null_comparison, duplicate_ignore, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, avoid_unnecessary_containers, curly_braces_in_flow_control_structures, prefer_is_empty, empty_catches, avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:word_search_safety/word_search_safety.dart';
// import 'package:just_audio/just_audio.dart';

class CrosswordWidget extends StatefulWidget {
  const CrosswordWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CrosswordWidgetState createState() => _CrosswordWidgetState();
}

class _CrosswordWidgetState extends State<CrosswordWidget> {
  // generate crossword char array
  // example like this : [["x","x"],["x","x"]]

  // sorry. hhahaa
  int numBoxPerRow = 6;
  double padding = 5;
  // sory .. not assign this yet.. :(
  Size sizeBox = Size.zero;

  ValueNotifier<List<List<String>>>? listChars;
  // save all answers on generate crossword data
  ValueNotifier<List<CrosswordAnswer>>? answerList;
  ValueNotifier<CurrentDragObj>? currentDragObj;
  ValueNotifier<List<int>>? charsDone;

  @override
  void initState() {
    super.initState();
    listChars = ValueNotifier<List<List<String>>>([]);
    answerList = ValueNotifier<List<CrosswordAnswer>>([]);
    currentDragObj = ValueNotifier<CurrentDragObj>(CurrentDragObj());
    // charsDone =  ValueNotifier<List<int>>( List<int>());
    charsDone = ValueNotifier<List<int>>(<int>[]);
    // generate char array crossword
    generateRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    // ok.. need build 2 widget.. 1 box 1 list

    // get size width
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              // color: Colors.blue,
              alignment: Alignment.center,
              width: double.maxFinite,
              height: size.width - padding * 2,
              padding: EdgeInsets.all(padding),
              margin: EdgeInsets.all(padding),
              child: drawCrosswordBox(),
            ),
            Container(
              alignment: Alignment.center,
              // lets show list word we need solve
              // child: drawAnswerList(),
              child: const Text(
                "Game",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
 - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      // ignore: curly_braces_in_flow_control_structures
      return -1;

    
