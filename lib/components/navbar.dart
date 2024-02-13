// import 'package:flutter/material.dart';
// import 'package:mylist/pages/contact.dart';
// import 'package:mylist/pages/profil.dart';
// import 'package:mylist/main.dart';

// class BottomNavBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.blue,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           IconButton(
//             icon: Image.asset('assets/images/list.png'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MyApp()),
//               );
//             },
//           ),
//           IconButton(
//             icon: Image.asset('assets/images/contact.png'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ContactPage()),
//               );
//             },
//           ),
//           IconButton(
//             icon: Image.asset('assets/images/avatar.png'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfilPage()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
