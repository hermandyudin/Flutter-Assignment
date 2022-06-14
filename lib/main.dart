import 'package:flutter/material.dart';
import 'favourite_body.dart';
import 'home_body.dart';

Future<void> main() async {
  runApp(const MyApp());
}

final saved = <String>{};
final imageUrls = <String>[
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
        builder: (context) =>
            Column(
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

class Storage {
  int loadPage() => 0;
}
