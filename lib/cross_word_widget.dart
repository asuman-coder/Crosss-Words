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

  void onDragEnd(PointerUpEvent event) {
    print("PointerUpEvent");
    // check if drag line object got value or not.. if no no need to clear
    // ignore: unnecessary_null_comparison
    if (currentDragObj!.value.currentDragLine == null) return;

    currentDragObj!.value.currentDragLine.clear();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentDragObj!.notifyListeners();
  }

  void onDragUpdate(PointerMoveEvent event) {
    // generate ondragLine so we know to highlight path later & clear if condition dont meet .. :D
    generateLineOnDrag(event);

    // get index on drag

    int indexFound = answerList!.value.indexWhere((answer) {
      return answer.answerLines!.join("-") ==
          currentDragObj!.value.currentDragLine.join("-");
    });

    print(currentDragObj!.value.currentDragLine.join("-"));
    if (indexFound >= 0) {
      answerList!.value[indexFound].done = true;
      // save answerList which complete
      charsDone!.value
          .addAll(answerList!.value[indexFound].answerLines as Iterable<int>);
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      charsDone!.notifyListeners();
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      answerList!.notifyListeners();
      // onDragEnd();

      onDragEnd;
    }
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    // get size max per box
    double maxSizeBox =
        ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      // ignore: curly_braces_in_flow_control_structures
      return -1;

    int x = 0, y = 0;
    double yAxis = 0, xAxis = 0;
    double yAxisStart = 0, xAxisStart = 0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxisStart = xAxis;
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxisStart = yAxis;
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

      if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    // if current drag line is null, dlcare new list for we can save value
    if (currentDragObj!.value.currentDragLine == null)
      // currentDragObj!.value.currentDragLine =  List<int>();
      // ignore: curly_braces_in_flow_control_structures
      currentDragObj!.value.currentDragLine = <int>[];

    // we need calculate index array base local position on drag
    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      // check drag line already pass 2 box
      if (currentDragObj!.value.currentDragLine.length >= 2) {
        // check drag line is straight line
        WSOrientation? wsOrientation;

        if (currentDragObj!.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj!.value.currentDragLine[1] % numBoxPerRow)
          // ignore: curly_braces_in_flow_control_structures
          wsOrientation =
              WSOrientation.vertical; // this should vertical.. my mistake.. :)
        else if (currentDragObj!.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj!.value.currentDragLine[1] ~/ numBoxPerRow)
          // ignore: curly_braces_in_flow_control_structures
          wsOrientation = WSOrientation.horizontal;

        if (wsOrientation == WSOrientation.horizontal) {
          if (indexBase ~/ numBoxPerRow !=
              currentDragObj!.value.currentDragLine[1] ~/ numBoxPerRow)
            // onDragEnd(null);
            // ignore: curly_braces_in_flow_control_structures
            onDragEnd;
        } else if (wsOrientation == WSOrientation.vertical) {
          if (indexBase % numBoxPerRow !=
              currentDragObj!.value.currentDragLine[1] % numBoxPerRow)
            // onDragEnd(null);
            // ignore: curly_braces_in_flow_control_structures
            onDragEnd;
        } else
          // onDragEnd(null);
          onDragEnd;
      }

      if (!currentDragObj!.value.currentDragLine.contains(indexBase))
        currentDragObj!.value.currentDragLine.add(indexBase);
      else if (currentDragObj!.value.currentDragLine.length >=
          2) if (currentDragObj!.value.currentDragLine[
              currentDragObj!.value.currentDragLine.length - 2] ==
          // indexBase) onDragEnd(null);
          indexBase) onDragEnd;
    }
    // before mistake , should in here
    currentDragObj!.notifyListeners();
  }

  void onDragStart(int indexArray) {
    try {
      List<CrosswordAnswer> indexSelecteds = answerList!.value
          .where((answer) => answer.indexArray == indexArray)
          .toList();

      // check indexSelecteds got any match , if 0 no proceed!
      if (indexSelecteds.length == 0) return;
      // nice triggered
      currentDragObj!.value.indexArrayOnTouch = indexArray;
      currentDragObj!.notifyListeners();
    } catch (e) {}
  }

  // nice one

  Widget drawCrosswordBox() {
    // add listener tp catch drag, push down & up
    return Listener(
      onPointerUp: (event) async {
        onDragEnd(event);

        final player = AudioPlayer();
        player.play(
          // AssetSource('note1.wav'),
          ('note1.wav') as Source,
        );
      },
      onPointerMove: (event) async {
        onDragUpdate(event);

        final player = AudioPlayer();
        player.play(
          // AssetSource('note1.wav'),
          ('note1.wav') as Source,
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: numBoxPerRow,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
            ),
            itemCount: numBoxPerRow * numBoxPerRow,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              // we need expand because to merge 2d array to become 1..
              // example [["x","x"],["x","x"]] become ["x","x","x","x"]
              String char = listChars!.value.expand((e) => e).toList()[index];

              // yeayy.. now we got crossword box.. easy right!!
              // later i will show how to display current word on crossword
              // next show color path on box when drag, we will using Valuelistener
              // done .. yeayy.. this is simple crossword system
              return Listener(
                onPointerDown: (event) async {
                  onDragStart(index);

                  try {
                    final player = AudioPlayer();

                    await player.play(
                      // AssetSource('note1.wav'),
                      ('note1.wav') as Source,
                    );
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable:
                      currentDragObj as ValueListenable<CurrentDragObj>,
                  builder: (context, CurrentDragObj value, child) {
                    Color color = Colors.white;

                    if (value.currentDragLine.contains(index))
                      color = Colors
                          .blue; // change color when path line is contain index
                    // else if (charsDone!.value.contains(index))
                    //   color =
                    //       Colors.red; // change color box already path correct

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        char.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void generateRandomWord() {
    // this words we want put on crossword game
    final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];

    // setup configuration to generate crossword

    // Create the puzzle sessting object
    final WSSettings ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.horizontalBack,
        WSOrientation.vertical,
        WSOrientation.verticalUp,
        // WSOrientation.diagonal,
        // WSOrientation.diagonalUp,
      ]),
    );

    // Create new instance of the WordSearch class
    // final WordSearch wordSearch = WordSearch();
    final WordSearchSafety wordSearch = WordSearchSafety();

    // Create a new puzzle
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

    /// Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors!.isEmpty) {
      // if no error.. proceed

      // List<List<String>> charsArray = newPuzzle.puzzle;
      listChars!.value = newPuzzle.puzzle!;
      // done pass..ez

      // Solve puzzle for given word list
      final WSSolved solved =
          wordSearch.solvePuzzle(newPuzzle.puzzle as List<List<String>>, wl);

      answerList!.value = solved.found!
          .map((solve) => CrosswordAnswer(solve, numPerRow: numBoxPerRow))
          .toList();
    }
  }

  drawAnswerList() {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: answerList as ValueListenable<List<CrosswordAnswer>>,
        builder: (context, List<CrosswordAnswer> value, child) {
          // lets make custom widget using Column & Row

          // how many row child we want show per row?
          int perColTotal = 3;

          // generate using list.generate
          List<Widget> list = List.generate(
              (value.length ~/ perColTotal) +
                  ((value.length % perColTotal) > 0 ? 1 : 0), (int index) {
            int maxColumn = (index + 1) * perColTotal;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                // generate child row per row
                // all close on each other.. let make row child distance equally
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    maxColumn > value.length
                        ? maxColumn - value.length
                        : perColTotal, ((indexChild) {
                  // forgot to declare array for access answerList
                  int indexArray = (index) * perColTotal + indexChild;

                  return Text(
                    // make text more clearly to read
                    // ignore: unnecessary_string_interpolations
                    "${value[indexArray].wsLocation.word}",
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          value[indexArray].done ? Colors.green : Colors.black,
                      decoration: value[indexArray].done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  );
                })).toList(),
              ),
            );
          }).toList();

          return Container(
            child: Column(
              children: list,
            ),
          );
        },
      ),
    );
  }
}

class CurrentDragObj {
  Offset? currentDragPos;
  Offset? currentTouch;
  int? indexArrayOnTouch;
  List<int> currentDragLine = <int>[];

  CurrentDragObj({
    this.indexArrayOnTouch,
    this.currentTouch,
  });
}

class CrosswordAnswer {
  bool done = false;
  int? indexArray;
  WSLocation wsLocation;
  List<int>? answerLines;

  CrosswordAnswer(this.wsLocation, {int? numPerRow}) {
    // ignore: unnecessary_this
    this.indexArray = this.wsLocation.y * numPerRow! + this.wsLocation.x;
    generateAnswerLine(numPerRow);
  }

  // get answer index for each character word
  void generateAnswerLine(int numPerRow) {
    // declare new list<int>
    answerLines = <int>[];

    // push all index based base word array
    // ignore: unnecessary_this
    this.answerLines!.addAll(List<int>.generate(
        wsLocation.overlap,
        // ignore: unnecessary_this
        (index) => generateIndexBaseOnAxis(this.wsLocation, index, numPerRow)));
  }

// calculate index base axis x & y
  generateIndexBaseOnAxis(WSLocation wsLocation, int i, int numPerRow) {
    int x = wsLocation.x, y = wsLocation.y;

    if (wsLocation.orientation == WSOrientation.horizontal ||
        wsLocation.orientation == WSOrientation.horizontalBack)
      // ignore: curly_braces_in_flow_control_structures
      x = (wsLocation.orientation == WSOrientation.horizontal) ? x + i : x - i;
    else
      // ignore: curly_braces_in_flow_control_structures
      y = (wsLocation.orientation == WSOrientation.vertical) ? y + i : y - i;

    return x + y * numPerRow;
  }

  // void playSound(note) {
  //   final player = AudioPlayer();
  //   player.play(AssetSource('audio/note1.wav'));
  // }
}
