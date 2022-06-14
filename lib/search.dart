import 'dart:convert';
import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'Joke.dart';

Future<List<Joke>> search(String toSearch) async {
  final response = await http.get(
      Uri.parse('https://api.chucknorris.io/jokes/search?query=$toSearch'));
  var data = jsonDecode(response.body);
  var rest = data["result"] as List;
  var list = rest.map<Joke>((json) => Joke.fromJson(json)).toList();
  return list;
}

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

late Future<List<Joke>> jokes;
late Future<bool> connected;

class ResultsBody extends StatelessWidget {
  const ResultsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Center(
                child: Text("Results", textAlign: TextAlign.center)),
            backgroundColor: Colors.black,
          ),
          body: FutureBuilder<bool>(
              future: connected,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return FutureBuilder<List<Joke>>(
                        future: jokes,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final tiles = snapshot.data!.map(
                              (pair) {
                                return ListTile(
                                  title: Text(pair.value),
                                );
                              },
                            );
                            final divided = tiles.isNotEmpty
                                ? ListTile.divideTiles(
                                    context: context,
                                    tiles: tiles,
                                  ).toList()
                                : <Widget>[];
                            return ListView(
                              children: divided,
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  } else {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(125, 300, 0, 0),
                      child: Text("There is no connection. \nTry again.",
                          textAlign: TextAlign.center),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  SearchBodyState createState() => SearchBodyState();
}

class SearchBodyState extends State<SearchBody> {
  String searchString = "";

  @override
  void initState() {
    super.initState();
  }

  void searchJokes() {
    jokes = search(searchString);
    connected = checkConnection();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultsBody()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                    onPressed: () => searchJokes(),
                    icon: const Icon(Icons.search)),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
