import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Joke> fetchJoke() async {
  final response =
  await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));

  return Joke.fromJson(jsonDecode(response.body));
}

class Joke {
  final String value;

  const Joke({
    required this.value,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      value: json['value'],
    );
  }
}

void main() => runApp(const MyApp());

final _saved = <String>{};
final _imageUrls = <String>[
  'https://m.media-amazon.com/images/I/51LK4ZBSGqL.jpg',
  'https://imgix.ranker.com/user_node_img/50016/1000312150/original/chuck-s-email-photo-u1?auto=format&q=60&fit=crop&fm=pjpg&dpr=2&w=375',
  'https://static3.srcdn.com/wordpress/wp-content/uploads/2020/03/Chuck-Norris-Force.jpg?q=50&fit=crop&w=450&h=389&dpr=1.5'
      'https://www.boredpanda.com/blog/wp-content/uploads/2022/04/chuck-norris-jokes-cover_800.png',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYqmosc-DxcBtCGVW3jqHkrK_fxLK7V0lQng&usqp=CAU',
  'https://i.pinimg.com/originals/8c/c5/a0/8cc5a0cbc6d85dc95f526cdce9873e1a.jpg',
  'https://i.pinimg.com/474x/d3/85/f0/d385f0a3255455705371a0bc0881177b.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTufgqmekuKtvM84jZyF-I8eQVoze0vZ591VQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReoHzaPUKf0zMZFi_tAkta8prT9PCdryf8DA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWPJ7XPfyRU1BbkhWzDWH-pUk-ymm1nLIfDA&usqp=CAU',
  'https://images.berliner-zeitung.de/2021/1/13/6e99838f-d089-4268-a9c5-34c56fcea38e.jpeg?rect=116%2C0%2C2133%2C1604&w=1024&auto=format',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDM41PpfKd2pYNsMmItpYvrWinTGaZ4yvPGw&usqp=CAU',
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class BottomMenu extends StatelessWidget {
  final int page;
  final ValueChanged<int>? onChanged;

  const BottomMenu({
    Key? key,
    required this.page,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: page,
      onTap: onChanged,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: Colors.blue,
            ),
            label: 'Jokes'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.red), label: 'Favourite'),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Storage _storage = Storage();
  var _page = 0;

  @override
  void initState() {
    super.initState();
    _page = _storage.loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text("Chuck Norris Jokes", textAlign: TextAlign.center)),
        backgroundColor: Colors.black,
      ),
      body: _bodyPage(_page),
      bottomNavigationBar: BottomMenu(
        page: _page,
        onChanged: onChanged,
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          child: const Icon(Icons.info),
          onPressed: () {
            showBottomSheet(context);
          },
        );
      }),
    );
  }

  void onChanged(int index) => setState(() => _page = index);

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                child: Text(
                  "You can contact me at:",
                  textScaleFactor: 2,
                )),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const Icon(Icons.telegram)),
                Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const Text("@Dudukk"))
              ],
            ),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const Icon(Icons.email)),
                Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const Text("dyudin.german@mail.ru"))
              ],
            )
          ],
        ));
  }

  Widget _bodyPage(int page) {
    switch (page) {
      case 0:
        return const HomeBody();
      case 1:
        return const FavouriteBody();
    }
    throw Exception('Unknown page');
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  HomeBodyState createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  late Future<Joke> futureJoke;
  String currentJoke = _imageUrls[0];
  int next = Random().nextInt(_imageUrls.length);

  @override
  void initState() {
    super.initState();
    futureJoke = fetchJoke();
    currentJoke = _imageUrls[next];
    next = Random().nextInt(_imageUrls.length);
  }

  void _updateJoke() {
    setState(() {
      futureJoke = fetchJoke();
      currentJoke = _imageUrls[next];
      next = Random().nextInt(_imageUrls.length);
    });
  }

  void _addToFavourites() async {
    Joke jk = await futureJoke;
    setState(() {
      _saved.add(jk.value);
      futureJoke = fetchJoke();
      currentJoke = _imageUrls[next];
      next += 1;
      next %= _imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chuck Norris jokes',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: ClipRRect(
                    child: Image.network(currentJoke, fit: BoxFit.fill),
                  )),
              FutureBuilder<Joke>(
                future: futureJoke,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Text(snapshot.data!.value,
                            textAlign: TextAlign.center));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(30.0),
                        child: IconButton(
                            onPressed: () => _addToFavourites(),
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
            ]),
      ),
    );
  }
}

class FavouriteBody extends StatefulWidget {
  const FavouriteBody({Key? key}) : super(key: key);

  @override
  FavouriteBodyState createState() => FavouriteBodyState();
}

class FavouriteBodyState extends State<FavouriteBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _saved.map(
          (pair) {
        return ListTile(
          title: Text(pair),
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList()
        : <Widget>[];

    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: ListView(
            children: divided,
          )),
    );
  }
}

class Storage {
  int loadPage() => 0;
}
