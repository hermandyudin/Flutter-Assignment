import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'Joke.dart';
import 'main.dart';
// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  HomeBodyState createState() => HomeBodyState();
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

class HomeBodyState extends State<HomeBody> {
  late Future<Joke> futureJoke;
  late Future<bool> connected;
  String currentJoke = imageUrls[0];
  int next = Random().nextInt(imageUrls.length);

  @override
  void initState() {
    super.initState();
    connected = checkConnection();
    futureJoke = fetchJoke();
    currentJoke = imageUrls[next];
    next = Random().nextInt(imageUrls.length);
  }

  void _updateJoke() {
    setState(() {
      connected = checkConnection();
      futureJoke = fetchJoke();
      currentJoke = imageUrls[next];
      next = Random().nextInt(imageUrls.length);
    });
  }

  void _updatePage() {
    setState(() {
      connected = checkConnection();
      futureJoke = fetchJoke();
      currentJoke = imageUrls[next];
      next = Random().nextInt(imageUrls.length);
    });
  }

  void _addToFavourites() async {
    Joke jk = await futureJoke;
    setState(() {
      saved.add(jk.value);
      connected = checkConnection();
      futureJoke = fetchJoke();
      currentJoke = imageUrls[next];
      next += 1;
      next %= imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chuck Norris jokes',
      theme: ThemeData.dark(),
      home: Scaffold(
          body: FutureBuilder<bool>(
              future: connected,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                        child: FutureBuilder<Joke>(
                          future: futureJoke,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(children: [
                                Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      color: Colors.deepPurple,
                                    ),
                                    child: ClipRRect(
                                      child: Image.network(currentJoke,
                                          fit: BoxFit.fill),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    child: Text(snapshot.data!.value,
                                        textAlign: TextAlign.center)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(30.0),
                                          child: IconButton(
                                              onPressed: () =>
                                                  _addToFavourites(),
                                              icon: const Icon(
                                                Icons.save,
                                                color: Colors.blue,
                                              ))),
                                      Container(
                                          padding: const EdgeInsets.all(30.0),
                                          child: IconButton(
                                              onPressed: () => _updateJoke(),
                                              icon: const Icon(
                                                Icons.thumb_up,
                                                color: Colors.blue,
                                              )))
                                    ])
                              ]);
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ));
                  } else {
                    return Padding(padding: const EdgeInsets.fromLTRB(125, 300, 0, 0), child: Column(
                        children: [
                          const Text("There is no connection. \nTry again.", textAlign: TextAlign.center),
                          IconButton(
                              onPressed: _updatePage,
                              icon: const Icon(Icons.refresh, color: Colors.blue,))
                        ]));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
