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
  List<dynamic> _comments = [];
  TextEditingController _commentController = TextEditingController();
  int? _selectedEventId;

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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              SizedBox(height: 5),
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
                              TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Ajouter un commentaire',
                                ),
                              ),
                              SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  sendComment(_commentController.text,
                                      _events[index]['id']);
                                },
                                child: Text('Envoyer'),
                              ),
                              SizedBox(height: 10),
                              FutureBuilder(
                                future: fetchComments(_events[index]['id']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Erreur: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    List<dynamic>? comments =
                                        snapshot.data as List<dynamic>?;
                                    if (comments != null &&
                                        comments.isNotEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Commentaires:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Column(
                                            children: comments.map((comment) {
                                              return Text(
                                                  comment['description']);
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Text(
                                          'Aucun commentaire disponible');
                                    }
                                  } else {
                                    return Text('Aucune donnée disponible');
                                  }
                                },
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

  Future<List<dynamic>> fetchComments(int eventId) async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/get/Commentaire?idEvents=$eventId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> sendComment(String description, int eventId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/post/addComment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'description': description,
          'idEvent':eventId ,
          'token':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Imp1YW5zbm93QGdtYWlsLmNvbSIsInJvbGUiOjAsImlkIjo2LCJpYXQiOjE3MTE3MTA0ODJ9.Ou0o0QMA-eVhEHDkhCKTNIawSOrWH3oe20Ixy5WPor4",
        }),
      );

      if (response.statusCode == 200) {
        print('Commentaire envoyé avec succès');
        setState(() {
          _commentController.text = '';
        });
      } else {
        print('Erreur lors de l\'envoi du commentaire: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
    }
  }
}
