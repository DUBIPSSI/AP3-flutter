import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _events = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    // Widget builder
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/sports.jpg',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                _events[index]['nom'] ?? 'No title available',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Date: ${_events[index]['date'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Category: ${_events[index]['categorie'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Price: ${_events[index]['prix'] != null ? '${_events[index]['prix']} \$' : 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Capacity: ${_events[index]['capacite'] != null ? _events[index]['capacite'] : 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Location: ${_events[index]['lieu'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/get/evenement'));

    if (response.statusCode == 200) {
      setState(() {
        _events = jsonDecode(response.body);
      });
    } else {
      setState(() {
        _events = [];
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(
                'Erreur ${response.statusCode} - ${response.reasonPhrase}'),
            actions: <Widget>[
              TextButton(
                child: Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
