import 'package:flutter/material.dart';
import 'main.dart';

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
    final tiles = saved.map(
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