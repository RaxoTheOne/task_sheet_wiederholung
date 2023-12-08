import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NameAgeBloc {
  final _nameController = StreamController<String>();
  final _ageController = StreamController<int>();
  final String apiUrl = 'https://api.agify.io?name=';

  // Input Sink
  Function(String) get setName => _nameController.sink.add;

  // Output Stream
  Stream<int> get age => _ageController.stream;

  // Constructor
  NameAgeBloc() {
    _nameController.stream.listen((name) async {
      if (name.isNotEmpty) {
        int age = await _getAge(name);
        _ageController.add(age);
      }
    });
  }

  Future<int> _getAge(String name) async {
    final response = await http.get(Uri.parse(apiUrl + name));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['age'] ?? 0;
    } else {
      return 0;
    }
  }

  void dispose() {
    _nameController.close();
    _ageController.close();
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Age Estimation',
      home: NameAgeScreen(),
    );
  }
}

class NameAgeScreen extends StatefulWidget {
  @override
  _NameAgeScreenState createState() => _NameAgeScreenState();
}

class _NameAgeScreenState extends State<NameAgeScreen> {
  final _bloc = NameAgeBloc();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Name Age Estimation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  _bloc.setName(_nameController.text);
                } else {
                  // Hier kannst du optional eine Meldung oder Aktion hinzufügen, wenn der Name leer ist.
                }
              },
              child: Text('Estimate Age'),
            ),
            SizedBox(height: 20),
            StreamBuilder<int>(
              stream: _bloc.age,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Estimated Age: ${snapshot.data}');
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _bloc.setName('');
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
