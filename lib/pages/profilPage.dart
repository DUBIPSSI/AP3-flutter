import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilPage(),
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String _nom = '';
  String _prenom = '';
  String _naissance = '';
  String _mail = '';
  String _avatar = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('flutter.token');

    if (token != null) {
      final url =
          Uri.parse('http://localhost:3000/get/utilisateur?token=$token');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          _nom = userData['nom'] ?? '';
          _prenom = userData['prenom'] ?? '';
          _naissance = userData['date_de_naissance'] ?? '';
          _mail = userData['mail'] ?? '';
          _avatar = 'assets/' + (userData['avatar'] ?? '');
        });

        prefs.setString('nom', _nom);
        prefs.setString('prenom', _prenom);
        prefs.setString('date_de_naissance', _naissance);
        prefs.setString('mail', _mail);
        prefs.setString('avatar', _avatar);
      } else {
        print('Erreur lors de la requête: ${response.statusCode}');
      }
    } else {
      print('Token de connexion non trouvé');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nom: $_nom'),
            Text('Prénom: $_prenom'),
            Text('Date de naissance: $_naissance'),
            Text('Mail: $_mail'),
            Image.network(_avatar),
            ElevatedButton(
              onPressed: () {
                // Action lorsque le bouton est pressé
              },
              child: Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
