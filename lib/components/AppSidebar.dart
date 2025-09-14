import 'package:flutter/material.dart';

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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Profile header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('images/avatar.jpeg'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Evelyn Parker',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _drawerItem(
                    context,
                    Icons.person_add,
                    'Add Pet',
                        () => _openRoute(context, const Placeholder()),
                  ),
                  _drawerItem(
                    context,
                    Icons.pets,
                    'My Pets',
                        () => _openRoute(context, const Placeholder()),
                  ),
                  _drawerItem(
                    context,
                    Icons.store,
                    'Pet Store',
                        () => _openRoute(context, const Placeholder()),
                  ),
                  _drawerItem(
                    context,
                    Icons.volunteer_activism,
                    'Adopt a Pet',
                        () => _openRoute(context, const Placeholder()),
                  ),
                  const Divider(),
                  _drawerItem(
                    context,
                    Icons.lightbulb,
                    'Care Tips',
                        () => _openRoute(context, const Placeholder()),
                  ),
                  _drawerItem(
                    context,
                    Icons.phone_iphone,
                    'Contact',
                        () => _openRoute(context, const Placeholder()),
                  ),
                  _drawerItem(
                    context,
                    Icons.logout,
                    'Log Out',
                        () {},
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
      BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
    );
  }
}
