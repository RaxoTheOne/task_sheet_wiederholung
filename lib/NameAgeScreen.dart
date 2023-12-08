import 'package:flutter/material.dart';
import 'package:task_sheet_wiederholung/NameAgeBloC.dart';

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
