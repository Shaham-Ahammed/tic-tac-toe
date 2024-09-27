import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool playerWon = false;
  String winnerName = "";
  int player = 0;
  Map<int, String> map = {};
  bool matchTied = false;

  @override
  void initState() {
    mapInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Text(
            "player 1 : X",
            style: TextStyle(
                fontSize: 20,
                color: player % 2 == 0 ? Colors.red : Colors.white),
          ),
          Text(
            "player 2 : O",
            style: TextStyle(
                fontSize: 20,
                color: player % 2 == 1 ? Colors.green : Colors.white),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 300, maxWidth: 300),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (!playerWon) {
                          deciderFunction(index);
                          winnerDecider();
                          didMatchTied();
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(index == 0 ? 18 : 0),
                              topRight: Radius.circular(index == 2 ? 18 : 0),
                              bottomLeft: Radius.circular(index == 6 ? 18 : 0),
                              bottomRight: Radius.circular(index == 8 ? 18 : 0),
                            )),
                        child: Center(
                          child: Text(
                            map[index]!,
                            style: TextStyle(
                                fontSize: 30,
                                color: map[index] == "X"
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 9,
                ),
              ),
            ),
          ),
          Visibility(
            visible: checkForVisible(),
            child: const SizedBox(
              height: 23,
            ),
          ),
          Visibility(
              visible: matchTied,
              child: const Text(
                "match tied",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Visibility(
            visible: playerWon,
            child: Text(
              "$winnerName won the game",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Visibility(
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                  onPressed: () => setState(() {
                        mapInitialization();
                        player = 0;
                        playerWon = false;
                        winnerName = "";
                        matchTied = false;
                      }),
                  child: const Text(
                    "reset",
                    style: TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }

  didMatchTied() {
    if (playerWon == false) {
      bool finished = true;
      List<String> vals = map.values.toList();
      if (vals.contains("")) {
        finished = false;
      }
      if (finished) {
        setState(() {
          matchTied = true;
        });
      }
    }
  }

  bool checkForVisible() {
    if (matchTied || playerWon) {
      return false;
    } else {
      return true;
    }
  }

  mapInitialization() {
    for (var i = 0; i < 9; i++) {
      map.addAll({i: ""});
    }
  }

  winnerDecider() {
    List<List<int>> indexes = [
      [0, 1, 2],
      [0, 4, 8],
      [0, 3, 6],
      [3, 4, 5],
      [6, 4, 2],
      [6, 7, 8],
      [1, 4, 7],
      [2, 5, 8]
    ];
    for (var i = 0; i < indexes.length; i++) {
      winnerDecider2(indexes[i]);
    }
  }

  winnerDecider2(List<int> list) {
    String m1 = map[list[0]]!;
    String m2 = map[list[1]]!;
    String m3 = map[list[2]]!;
    if (m1.isNotEmpty &&
        m2.isNotEmpty &&
        m3.isNotEmpty &&
        m1 == m2 &&
        m2 == m3) {
      setState(() {
        playerWon = true;
        winnerName = m1;
      });
    }
  }

  deciderFunction(int index) {
    if (map[index]!.isEmpty) {
      String let = player % 2 == 0 ? "X" : "O";
      setState(() {
        map[index] = let;
        player++;
      });
    }
  }
}
