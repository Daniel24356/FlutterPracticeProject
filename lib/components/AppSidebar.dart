import 'package:flutter/material.dart';
import 'package:projects/AdoptionListingsPage.dart';
import 'package:projects/PetDashboardApp.dart';
import 'package:projects/ShelterDashboard.dart';
import '../PetCareTipsPage.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  void _openRoute(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) {
          return FadeTransition(opacity: anim, child: page);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // ✅ remove corner radius
      ),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('images/avatar.jpeg'),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Evelyn Parker',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const Divider(thickness: 1, height: 30),

            // ✅ Sidebar Links
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 👉 Group 1: Pet Management
                  _sectionHeading("Pet Management"),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                    child:_drawerItem(
                      context,
                      Icons.person_add,
                      'Add Pet',
                          () => _openRoute(context, const ShelterDashboard()),
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                      child:_drawerItem(
                        context,
                        Icons.pets,
                        'My Pets',
                            () => _openRoute(context, const PetProfileListPage()),
                        color: Colors.blue,
                      ),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                    child:_drawerItem(
                      context,
                      Icons.volunteer_activism,
                      'Adopt a Pet',
                          () => _openRoute(context, const AdoptionListingsPage()),
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 30,),
                  // const Divider(thickness: 1, height: 30),

                  // 👉 Group 2: Info & Support
                  _sectionHeading("Info & Support"),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                    child: _drawerItem(
                      context,
                      Icons.lightbulb,
                      'Blog & Tips',
                          () => _openRoute(context, const PetCareTipsPage()),
                      color: Colors.green,
                    ),
                  ),

                  SizedBox(height: 3),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                    child: _drawerItem(
                      context,
                      Icons.phone_iphone,
                      'Contact',
                          () => _openRoute(context, const ContactPage()),
                      color: Colors.purple,
                    ),
                  ),

                  SizedBox(height: 30,),
                  // const Divider(thickness: 1, height: 30),

                  // 👉 Group 3: Account
                  _sectionHeading("Account"),
                  Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                    child: _drawerItem(

                      context,
                      Icons.settings,
                      'Settings',
                          () {}, // hook your logout logic here
                      color: Colors.teal,
                    ),
                  ),

                  SizedBox(height: 3),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
                    child: _drawerItem(
                      context,
                      Icons.logout,
                      'Log Out',
                          () {}, // hook your logout logic here
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context,
      IconData icon,
      String text,
      VoidCallback onTap, {
        required Color color,
      }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 12,
      dense: true,
    );
  }

  // ✅ Section heading widget
  Widget _sectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
