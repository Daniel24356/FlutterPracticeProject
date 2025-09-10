// import 'package:flutter/material.dart';
//
// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});
//
//   final List<Map<String, dynamic>> chats = const [
//     {
//       "name": "Sebastian Rudiger",
//       "message": "Perfect! Will check it 🔥",
//       "time": "09:34 PM",
//       "avatar": "https://i.pravatar.cc/150?img=1",
//       "unread": 0,
//     },
//     {
//       "name": "Caroline Varsaha",
//       "message": "Thanks, Jimmy! Talk later",
//       "time": "08:12 PM",
//       "avatar": "https://i.pravatar.cc/150?img=2",
//       "unread": 2,
//     },
//     {
//       "name": "Darshan Patelchi",
//       "message": "Sound good for me too!",
//       "time": "02:29 PM",
//       "avatar": "https://i.pravatar.cc/150?img=3",
//       "unread": 3,
//     },
//     {
//       "name": "Mohammed Arnold",
//       "message": "No rush, mate! Just let ...",
//       "time": "01:08 PM",
//       "avatar": "https://i.pravatar.cc/150?img=4",
//       "unread": 0,
//     },
//     {
//       "name": "Tamara Schipchinskaya",
//       "message": "Okay. I’ll tell him about it",
//       "time": "11:15 AM",
//       "avatar": "https://i.pravatar.cc/150?img=5",
//       "unread": 0,
//     },
//     {
//       "name": "Ariana Amberline",
//       "message": "Good nite, Honey! 🖤",
//       "time": "Yesterday",
//       "avatar": "https://i.pravatar.cc/150?img=6",
//       "unread": 0,
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildSearchBar(),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 itemCount: chats.length,
//                 itemBuilder: (context, index) {
//                   final chat = chats[index];
//                   return _buildChatItem(context, chat);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNav(context),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: TextField(
//         decoration: InputDecoration(
//           prefixIcon: const Icon(Icons.search),
//           hintText: "Search message...",
//           filled: true,
//           fillColor: Colors.white,
//           suffixIcon: const Icon(Icons.edit),
//           contentPadding: const EdgeInsets.symmetric(vertical: 0),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatItem(BuildContext context, Map<String, dynamic> chat) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, '/chatPages');
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: ListTile(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//           leading: CircleAvatar(
//             backgroundImage: AssetImage('images/profile1.jpg'),
//             radius: 24,
//           ),
//           title: Text(
//             chat['name'],
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           subtitle: Text(
//             chat['message'],
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 chat['time'],
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//               if (chat['unread'] > 0)
//                 Container(
//                   margin: const EdgeInsets.only(top: 6),
//                   padding: const EdgeInsets.all(6),
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF7A3FFF),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Text(
//                     "${chat['unread']}",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNav(BuildContext context) {
//     return Container(
//       height: 80,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Positioned(
//             top: 10,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pushNamed(context, '/chatPages');
//               },
//               child: Container(
//                 height: 60,
//                 width: 60,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF7A3FFF),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: const [
//               Icon(Icons.public, color: Colors.grey),
//               Icon(Icons.notifications_none, color: Color(0xFF7A3FFF)),
//               SizedBox(width: 60),
//               Icon(Icons.call, color: Colors.grey),
//               Icon(Icons.settings, color: Colors.grey),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
