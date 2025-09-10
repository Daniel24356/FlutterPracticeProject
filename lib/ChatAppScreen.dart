// import 'package:flutter/material.dart';
//
// void main() => runApp(ChatApp());
//
// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ChatPage(),
//     );
//   }
// }
//
// class ChatPage extends StatelessWidget {
//   final Color senderColor = Color(0xFF7A3FFF);
//   final Color receiverColor = Colors.white;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF6F6F6),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: Icon(Icons.arrow_back, color: Colors.black),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage('images/profile.jpg'), // replace with actual image
//               radius: 18,
//             ),
//             SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Sebastian Rudiger',
//                     style: TextStyle(fontSize: 16, color: Colors.black)),
//                 Text('Online',
//                     style: TextStyle(fontSize: 12, color: Colors.green)),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           Icon(Icons.call, color: Colors.black),
//           SizedBox(width: 10),
//           Icon(Icons.videocam, color: Colors.black),
//           SizedBox(width: 10),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(16),
//               children: [
//                 _receiverBubble("Hi, Jimmy! Any update today?", "09:32 PM"),
//                 _senderBubble("All good! We have some update ✨", "09:34 PM"),
//                 _senderImageBubble(
//                   imageUrl:
//                   'https://via.placeholder.com/150', // use your image preview
//                   link:
//                   'https://www.figma.com/file/EQJut...', // actual link here
//                   time: "09:34 PM",
//                 ),
//                 _receiverBubble(
//                   'Cool! I have some feedbacks on the “How it work” section. but overall looks good now! 👍',
//                   "10:15 PM",
//                 ),
//                 _senderBubble("Perfect! Will check it 🔥", "09:34 PM"),
//               ],
//             ),
//           ),
//           _chatInput(),
//         ],
//       ),
//     );
//   }
//
//   Widget _receiverBubble(String text, String time) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             margin: EdgeInsets.only(bottom: 4),
//             constraints: BoxConstraints(maxWidth: 280),
//             decoration: BoxDecoration(
//               color: receiverColor,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(text, style: TextStyle(fontSize: 15)),
//           ),
//           Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
//           SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
//
//   Widget _senderBubble(String text, String time) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             margin: EdgeInsets.only(bottom: 4),
//             constraints: BoxConstraints(maxWidth: 280),
//             decoration: BoxDecoration(
//               color: senderColor,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(text,
//                 style: TextStyle(fontSize: 15, color: Colors.white)),
//           ),
//           Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
//           SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
//
//   Widget _senderImageBubble({
//     required String imageUrl,
//     required String link,
//     required String time,
//   }) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             margin: EdgeInsets.only(bottom: 4),
//             width: 280,
//             decoration: BoxDecoration(
//               color: senderColor,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Here’s the new landing page design!\n$link',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
//           SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
//
//   Widget _chatInput() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Icon(Icons.add_circle_outline, color: Colors.grey),
//           SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Type here...",
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Icon(Icons.camera_alt_outlined, color: Colors.grey),
//           SizedBox(width: 8),
//           Icon(Icons.send, color: Colors.deepPurple),
//         ],
//       ),
//     );
//   }
// }
