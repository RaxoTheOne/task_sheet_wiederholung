import 'dart:async';
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
      print('HTTP Response: ${response.body}');
      return data['age'] ?? 0;
    } else {
      print('HTTP Error: ${response.statusCode}');
      return 0;
    }
  }
  
  void dispose() {
    _nameController.close();
    _ageController.close();
  }
}