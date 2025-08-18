// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: InstagramHome(),
//     );
//   }
// }
//
// class InstagramHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Instagram',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Billabong',
//                 fontSize: 30,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.favorite, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.send, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//
//           Container(
//             height: 100,
//             color: Colors.black,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.grey,
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: AssetImage('images/profile1.jpg'),
//                         ),
//                       ),
//                       Text('Your story', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.blue,
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: AssetImage('images/profile.jpg'),
//                         ),
//                       ),
//                       Text('mrbeast', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.blue,
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: AssetImage('images/profile1.jpg'),
//                         ),
//                       ),
//                       Text('shankcomics', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.blue,
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: AssetImage('images/profile.jpg'),
//                         ),
//                       ),
//                       Text('theboijayy', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.blue,
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: AssetImage('images/profile1.jpg'),
//                         ),
//                       ),
//                       Text('Daniel', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.blue,
//                         child: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: AssetImage('images/profile.jpg'),
//                         ),
//                       ),
//                       Text('sochima', style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Post Section
//           Container(
//             color: Colors.black,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage('images/profile1.jpg'),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('ashmusy', style: TextStyle(color: Colors.white)),
//                         Text('Original audio', style: TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   width: double.infinity,
//                   height: 450,
//                   child: Image.asset(
//                     'images/eren.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Join us to go out in a cab with no driver!!!! 😭🇺🇸',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//
//             ),
//           ),
//           Container(
//             color: Colors.black,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage('images/profile.jpg'),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('ashmusy', style: TextStyle(color: Colors.white)),
//                         Text('Original audio', style: TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   width: double.infinity,
//                   height: 450,
//                   child: Image.asset(
//                     'images/tokyo.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Join us to go out in a cab with no driver!!!! 😭🇺🇸',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }