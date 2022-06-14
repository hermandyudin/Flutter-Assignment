
import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
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
