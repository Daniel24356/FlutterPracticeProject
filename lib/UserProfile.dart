import 'package:flutter/material.dart';
import 'EditProfilePage.dart';
import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});


  Widget _buildMenuItem(
      {required IconData icon,
        required Color bgColor,
        required String title,
        VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: bgColor.withOpacity(0.2),
              radius: 20,
              child: Icon(icon, color: bgColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Profile",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Avatar
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/avatar.jpeg"), // your image
            ),
            const SizedBox(height: 12),
            const Text(
              "Evelyn Parker",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Text(
              "evelynparker17@gmail.com",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Menu Items
            _buildMenuItem(
              icon: Icons.person,
              bgColor: Colors.green,
              title: "My Account",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            _buildMenuItem(
                icon: Icons.lock,
                bgColor: Colors.red,
                title: "Password Manager"),
            // _buildMenuItem(
            //     icon: Icons.location_on,
            //     bgColor: Colors.red,
            //     title: "Manage Address"),
            // _buildMenuItem(
            //     icon: Icons.account_balance_wallet,
            //     bgColor: Colors.purple,
            //     title: "My Wallet"),
            _buildMenuItem(
                icon: Icons.settings,
                bgColor: Colors.orange,
                title: "Settings"),
            _buildMenuItem(
                icon: Icons.help,
                bgColor: Colors.purple,
                title: "Help Center"),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
