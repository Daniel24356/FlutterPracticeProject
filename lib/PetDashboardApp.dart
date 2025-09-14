import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projects/services/petService.dart';
import 'package:projects/PetCareTipsPage.dart';
import 'AppointmentPage.dart';
import 'PetStorePage.dart';
import 'UserProfile.dart';
import 'PetStorePage.dart';
import 'HealthRecordsPage.dart';
import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';


void main() {
  runApp(const PetDashboardApp());
}

class PetDashboardApp extends StatelessWidget {
  const PetDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawfectCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        primaryColor: Colors.green,
        useMaterial3: true,
      ),
      home: const DashboardShell(),
    );
  }
}

// Shell that holds bottom navigation + drawer
class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;
  late final AnimationController _fabController;

  final List<Widget> _pages = [
    const IndexPage(),
    const AppointmentListPage(),
    PetStorePage(),
    HealthRecordsPage(),
    const UserProfile(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onNavTap(int idx) {
    setState(() => _selectedIndex = idx);
    _pageController.animateToPage(idx, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    if (idx == 2) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  void _openRoute(Widget page) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, anim, secAnim) {
      return FadeTransition(opacity: anim, child: page);
    }, transitionDuration: const Duration(milliseconds: 300)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),

      body: PageView(controller: _pageController, physics: const BouncingScrollPhysics(), children: _pages, onPageChanged: (i) => setState(() => _selectedIndex = i)),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_information_outlined), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.green,
                // borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/avatar.jpeg'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Evelyn Parker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _drawerItem(context, Icons.person_add, 'Add Pet', () => _openRoute(const AddPetPage())),
                  _drawerItem(context, Icons.pets, 'My Pets', () => _openRoute(const PetProfileListPage())),
                  // _drawerItem(context, Icons.add_circle_outline, 'Book Appointment', () => _openRoute(const BookAppointmentPage())),
                  // _drawerItem(context, Icons.calendar_today, 'Appointments', () => _openRoute(const AppointmentListPage())),
                  // _drawerItem(context, Icons.medical_services, 'Health Records', () => _openRoute(const HealthRecordsPage())),
                  _drawerItem(context, Icons.store, 'Pet Store', () => _openRoute(const PetStorePage())),
                  _drawerItem(context, Icons.pets, 'Adopt a Pet', () => _openRoute(const PetCareTipsPage())),
                  SizedBox(height: 20),
                  _drawerItem(context, Icons.lightbulb, 'Care Tips', () => _openRoute(const PetCareTipsPage())),
                  _drawerItem(context, Icons.contact_mail, 'Contact', () => _openRoute(const ContactPage())),
                  _drawerItem(context, Icons.logout, 'Log Out', () => _openRoute(const ContactPage())),
                  const Divider(),
                  // _drawerItem(context, Icons.login, 'Login', () => _openRoute(const LogOutPage())),
                  // _drawerItem(context, Icons.app_registration, 'Signup', () => _openRoute(const SignupPage())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext c, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}


class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF0DB14C);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "PawfectCare",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('images/avatar.jpeg'), // Replace with your device image path
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Hello Evelyn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
                // IconButton(
                //   icon: const Icon(Icons.notifications_outlined, color: Colors.grey, size: 30),
                //   onPressed: () {},
                // ),
              ],
            ),
            const SizedBox(height: 24),
            // Pets row
            Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align header to the left
                      children: [
                        // First row: Section header
                        const _SectionHeader(
                          title: 'My Pets',
                          actionLabel: 'View all',
                          onPressed: null, // Placeholder; implement navigation
                        ),

                        const SizedBox(height: 8), // Space between header and pets row

                        // Second row: pets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PetAvatar(
                              name: 'Max',
                              image: const AssetImage('images/maltese.png'),
                            ),
                            _PetAvatar(
                              name: 'Luna',
                              image: const AssetImage('images/luna.jpg'),
                            ),
                            _PetAvatar(
                              name: 'Dash',
                              image: const AssetImage('images/dash.jpg'),
                            ),
                            _PetAvatar(
                              name: 'Tom',
                              image: const AssetImage('images/tom.jpg'),
                            ),

                            // Add button aligned with pets
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                  const SizedBox(height: 5),
                                  IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add_circle, size: 36, color: Colors.green),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ],
                    )

                ),

              ],
            ),

            const SizedBox(height: 24),
            // Upcoming Appointments section (replacing providers from image)
            const _SectionHeader(
              title: 'Upcoming Appointments',
              actionLabel: 'View all',
              onPressed: null, // Placeholder; implement navigation as needed
            ),
            const SizedBox(height: 8),
            const _AppointmentCard(
              petName: 'Max',
              type: 'Grooming',
              date: 'Today, 2:00 PM',
              provider: 'Dr. Cameron Williamson',
              icon: Icons.content_cut,
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            const _AppointmentCard(
              petName: 'Luna',
              type: 'Vaccination',
              date: 'Tomorrow, 10:00 AM',
              provider: 'Dr. Leslie Alexander',
              icon: Icons.vaccines,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            const _AppointmentCard(
              petName: 'Dash',
              type: 'Check-up',
              date: 'Sept 15, 3:00 PM',
              provider: 'Cameron Williamson',
              icon: Icons.health_and_safety,
              color: Colors.blue
            ),
            const SizedBox(height: 24),
            // Store Picks section
            const _SectionHeader(
              title: 'Store Picks',
              actionLabel: 'View all',
              onPressed: null, // Placeholder; implement navigation as needed
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => const _ProductCard(),
              ),
            ),
            const SizedBox(height: 24),
            // Today's Care Tips section
            const _SectionHeader(
              title: "Today's Care Tips",
              actionLabel: 'View all',
              onPressed: null, // Placeholder; implement navigation as needed
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) => const _ArticleCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  final String name;
  final ImageProvider image;
  const _PetAvatar({
    required this.name,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: image,
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Tab({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onPressed;
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String petName;
  final String type;
  final String date;
  final String provider;
  final IconData icon;
  final Color color;
  const _AppointmentCard({
    required this.petName,
    required this.type,
    required this.date,
    required this.provider,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //   color: Colors.blue.withOpacity(0.1),
            //   shape: BoxShape.circle,
            // ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 24),
            ),
            // child: Icon(
            //   icon,
            //   color: Colors.blue,
            //   size: 24,
            // ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$petName's $type",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                'images/petFood.jpg', // Replace with your device image path; duplicate for 5 items or vary
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Kibble',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$19.99',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                'images/hygiene.png', // Replace with your device image path; duplicate for 3 items or vary
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Hygiene for Active Pups',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep your furry friend clean with these tips...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Pages placeholders --------------------
class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchTerm = "";

  final List<Map<String, dynamic>> upcomingAppointments = [
    {
      "id": "1",
      "pet": {"name": "Max", "species": "Dog", "image": "maltese.png"},
      "veterinarian": "Dr. Sarah Smith",
      "clinic": "Downtown Pet Clinic",
      "date": "2024-09-15",
      "time": "10:00 AM",
      "type": "General Checkup",
      "status": "confirmed",
      "phone": "+1 (555) 123-4567"
    },
    {
      "id": "2",
      "pet": {"name": "Luna", "species": "Cat", "image": "luna.jpg"},
      "veterinarian": "Dr. Michael Johnson",
      "clinic": "Pet Hospital",
      "date": "2024-09-18",
      "time": "2:30 PM",
      "type": "Vaccination",
      "status": "pending",
      "phone": "+1 (555) 987-6543"
    }
  ];

  final List<Map<String, dynamic>> pastAppointments = [
    {
      "id": "3",
      "pet": {"name": "Dash", "species": "Rabbit", "image": "dash.jpg"},
      "veterinarian": "Dr. Emily Brown",
      "clinic": "Animal Care Center",
      "date": "2024-08-10",
      "time": "11:00 AM",
      "type": "Dental Cleaning",
      "status": "completed"
    },
    {
      "id": "4",
      "pet": {"name": "Tom", "species": "Bird", "image": "tom.jpg"},
      "veterinarian": "Dr. Sarah Smith",
      "clinic": "Downtown Pet Clinic",
      "date": "2024-07-15",
      "time": "9:30 AM",
      "type": "Surgery Follow-up",
      "status": "completed"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Color _statusColor(String status) {
    switch (status) {
      case "confirmed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.grey;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _appointmentCard(Map<String, dynamic> appointment,
      {bool showActions = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Top Row: Pet Info + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Replace emoji with pet image from assets
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "images/${appointment["pet"]["image"]}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment["pet"]["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        appointment["pet"]["species"],
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: _statusColor(appointment["status"]).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20), // pill shape
                ),
                child: Text(
                  appointment["status"].toString().toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(appointment["status"]),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Date + Time Row
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 18, color: Colors.deepPurple),
              const SizedBox(width: 6),
              Text(appointment["date"], style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 18, color: Colors.blue),
              const SizedBox(width: 6),
              Text(appointment["time"], style: const TextStyle(fontSize: 14)),
            ],
          ),

          const SizedBox(height: 10),

          // Clinic Row
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  appointment["clinic"],
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Vet Row
          Row(
            children: [
              const Icon(Icons.person, size: 18, color: Colors.teal),
              const SizedBox(width: 6),
              Text(appointment["veterinarian"],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),

          const SizedBox(height: 6),

          // Type Row
          Row(
            children: [
              const Icon(Icons.pets, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Text("Type: ${appointment["type"]}",
                  style: const TextStyle(fontSize: 14)),
            ],
          ),

          if (appointment["phone"] != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.green),
                const SizedBox(width: 6),
                Text(appointment["phone"],
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],

          // Action Buttons
          if (showActions) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                // ✅ Confirm button (green filled)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // handle confirm logic here
                    },
                    icon: const Icon(Icons.check_circle, size: 18, color: Colors.white),
                    label: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ✅ Reschedule button (outlined style)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RescheduleAppointmentPage(appointment: appointment),
                      ));
                    },
                    icon: const Icon(Icons.edit_calendar, size: 18, color: Colors.green),
                    label: const Text(
                      "Reschedule",
                      style: TextStyle(color: Colors.green),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ]),
      ),
    );
  }

  // Widget _appointmentCard(Map<String, dynamic> appointment,
  //     {bool showActions = false}) {
  //   return Card(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     elevation: 3,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //           Row(children: [
  //             Container(
  //               width: 48,
  //               height: 48,
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade100,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Center(
  //                 child: Text(appointment["pet"]["emoji"],
  //                     style: const TextStyle(fontSize: 24)),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //               Text(appointment["pet"]["name"],
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.bold, fontSize: 16)),
  //               Text(appointment["pet"]["species"],
  //                   style: const TextStyle(color: Colors.grey)),
  //             ]),
  //           ]),
  //           Chip(
  //             label: Text(appointment["status"].toString().toUpperCase()),
  //             backgroundColor: _statusColor(appointment["status"]).withOpacity(0.2),
  //             labelStyle: TextStyle(color: _statusColor(appointment["status"])),
  //           ),
  //         ]),
  //         const SizedBox(height: 12),
  //         Row(children: [
  //           const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(appointment["date"]),
  //           const SizedBox(width: 16),
  //           const Icon(Icons.access_time, size: 16, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(appointment["time"]),
  //         ]),
  //         const SizedBox(height: 8),
  //         Row(children: [
  //           const Icon(Icons.location_on, size: 16, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(appointment["clinic"]),
  //         ]),
  //         const SizedBox(height: 8),
  //         Text("${appointment["veterinarian"]}",
  //             style: const TextStyle(fontWeight: FontWeight.w500)),
  //         Text("Type: ${appointment["type"]}"),
  //         if (appointment["phone"] != null)
  //           Row(children: [
  //             const Icon(Icons.phone, size: 16, color: Colors.grey),
  //             const SizedBox(width: 4),
  //             Text(appointment["phone"]),
  //           ]),
  //         if (showActions) ...[
  //           const Divider(height: 24),
  //           Row(children: [
  //             Expanded(
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (_) => RescheduleAppointmentPage(
  //                           appointment: appointment)));
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.green,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12))),
  //                 child: const Text("Reschedule"),
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: OutlinedButton(
  //                 onPressed: () {},
  //                 style: OutlinedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12))),
  //                 child: const Text("Cancel"),
  //               ),
  //             ),
  //           ]),
  //         ]
  //       ]),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Appointments",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 18, color: Colors.white),
        label: const Text("Book New", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(children: [
          // Header
          // Search box
          SizedBox(height: 20,),
          FractionallySizedBox(
            widthFactor: 0.92, // 90% of parent width
            child: TextField(
              onChanged: (val) => setState(() => searchTerm = val),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Search appointments...",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),



          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),

                ),
                indicatorSize: TabBarIndicatorSize.tab, // makes indicator cover full tab
                dividerColor: Colors.transparent, // removes bottom border (Flutter 3.7+)
                tabs: [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Text('Upcoming (${upcomingAppointments.length})', style: TextStyle(fontSize: 12.5)),

                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Text("Past (${pastAppointments.length})", style: TextStyle(fontSize: 12.5),),
                    ),
                  ),

                ],
                onTap: (idx) => setState(() {}),
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: upcomingAppointments
                      .where((appt) => appt["pet"]["name"]
                      .toLowerCase()
                      .contains(searchTerm.toLowerCase()))
                      .map((appt) =>
                      _appointmentCard(appt, showActions: true))
                      .toList(),
                ),
                // Past
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: pastAppointments
                      .where((appt) => appt["pet"]["name"]
                      .toLowerCase()
                      .contains(searchTerm.toLowerCase()))
                      .map((appt) => _appointmentCard(appt))
                      .toList(),
                ),
              ],
            ),
          ),

        ]),
      ),
    );
  }
}

class RescheduleAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointment;
  const RescheduleAppointmentPage({super.key, required this.appointment});

  @override
  State<RescheduleAppointmentPage> createState() =>
      _RescheduleAppointmentPageState();
}

class _RescheduleAppointmentPageState extends State<RescheduleAppointmentPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? reason;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reschedule Appointment"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Pet & doctor info
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Text(appointment["pet"]["emoji"],
                      style: const TextStyle(fontSize: 28)),
                  title: Text(appointment["pet"]["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Dr. ${appointment["veterinarian"]}"),
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.green),
                title: Text(selectedDate == null
                    ? "Choose new date"
                    : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),
              const Divider(),

              // Time Picker
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.green),
                title: Text(selectedTime == null
                    ? "Choose new time"
                    : selectedTime!.format(context)),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedTime = picked);
                  }
                },
              ),
              const Divider(),

              // Reason dropdown
              DropdownButtonFormField<String>(
                value: reason,
                decoration: InputDecoration(
                  labelText: "Reason for rescheduling",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: [
                  "Scheduling conflict",
                  "Emergency",
                  "Not feeling well",
                  "Other"
                ]
                    .map((r) =>
                    DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) => setState(() => reason = val),
                validator: (val) =>
                val == null ? "Please select a reason" : null,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Additional notes (optional)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reschedule request sent!")),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Confirm Reschedule",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// -------------------- Book Appointment Page --------------------
class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPet;
  String? _appointmentType;
  String? _veterinarian;
  String? _timeSlot;
  String? _urgency;
  DateTime? _selectedDate;
  final TextEditingController _reasonController = TextEditingController();

  final List<Map<String, String>> pets = [
    {"id": "1", "name": "Max", "species": "Dog"},
    {"id": "2", "name": "Luna", "species": "Cat"},
    {"id": "3", "name": "Coco", "species": "Rabbit"},
  ];

  final List<Map<String, String>> veterinarians = [
    {"id": "1", "name": "Dr. Sarah Smith", "specialty": "General Practice"},
    {"id": "2", "name": "Dr. Michael Johnson", "specialty": "Surgery"},
    {"id": "3", "name": "Dr. Emily Brown", "specialty": "Dentistry"},
  ];

  final List<String> appointmentTypes = [
    "General Checkup",
    "Vaccination",
    "Surgery Consultation",
    "Dental Care",
    "Emergency",
    "Grooming",
  ];

  final List<String> timeSlots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
  ];

  final List<String> priorityLevels = ["Routine", "Urgent", "Emergency"];

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _timeSlot != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Appointment booked successfully!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please complete all required fields"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment',
            style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedPet,
                  decoration: const InputDecoration(
                      labelText: "Select Pet *", border: OutlineInputBorder()),
                  items: pets
                      .map((pet) => DropdownMenuItem(
                      value: pet["id"],
                      child: Text("${pet["name"]} (${pet["species"]})")))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedPet = val),
                  validator: (val) =>
                  val == null ? "Please select a pet" : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _appointmentType,
                  decoration: const InputDecoration(
                      labelText: "Appointment Type *",
                      border: OutlineInputBorder()),
                  items: appointmentTypes
                      .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() => _appointmentType = val),
                  validator: (val) =>
                  val == null ? "Please select a type" : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _veterinarian,
                  decoration: const InputDecoration(
                      labelText: "Select Veterinarian *",
                      border: OutlineInputBorder()),
                  items: veterinarians
                      .map((vet) => DropdownMenuItem(
                      value: vet["id"],
                      child: Text("${vet["name"]} • ${vet["specialty"]}")))
                      .toList(),
                  onChanged: (val) => setState(() => _veterinarian = val),
                  validator: (val) =>
                  val == null ? "Please select a veterinarian" : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.green),
                        label: Text(
                          _selectedDate == null
                              ? "Pick Date *"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _timeSlot,
                        decoration: const InputDecoration(
                            labelText: "Select Time *",
                            border: OutlineInputBorder()),
                        items: timeSlots
                            .map((slot) => DropdownMenuItem(
                            value: slot, child: Text(slot)))
                            .toList(),
                        onChanged: (val) => setState(() => _timeSlot = val),
                        validator: (val) =>
                        val == null ? "Please select a time" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _urgency,
                  decoration: const InputDecoration(
                      labelText: "Priority Level",
                      border: OutlineInputBorder()),
                  items: priorityLevels
                      .map((p) =>
                      DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => _urgency = val),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: "Reason for Visit",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text("Book Appointment",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.green)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// class PetStorePage extends StatelessWidget {
//   const PetStorePage({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.storefront, size: 56, color: Colors.green), SizedBox(height: 12), Text('Pet Store', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
// }

// class HealthRecordsPage extends StatelessWidget {
//   const HealthRecordsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.medical_information, size: 56, color: Colors.green), SizedBox(height: 12), Text('Health Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
// }

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> formData = {
    "name": "",
    "email": "",
    "phone": "",
    "subject": "",
    "category": "",
    "message": "",
  };

  // Mock locations
  final List<Map<String, String>> locations = [
    {
      "name": "Downtown Veterinary Clinic",
      "address": "123 Main Street, Downtown, City 12345",
      "phone": "+1 (555) 123-4567",
      "email": "downtown@pawfectcare.com",
      "hours": "Mon-Fri: 8AM-6PM, Sat: 9AM-4PM, Sun: 10AM-2PM"
    },
    {
      "name": "Suburban Pet Hospital",
      "address": "456 Oak Avenue, Suburbs, City 67890",
      "phone": "+1 (555) 987-6543",
      "email": "suburban@pawfectcare.com",
      "hours": "Mon-Fri: 7AM-7PM, Sat-Sun: 9AM-5PM"
    },
    {
      "name": "Emergency Pet Care Center",
      "address": "789 Emergency Blvd, Medical District, City 11111",
      "phone": "+1 (555) 911-PETS",
      "email": "emergency@pawfectcare.com",
      "hours": "24/7 Emergency Services"
    },
  ];

  final List<Map<String, String>> faqs = [
    {
      "question": "How do I schedule an appointment?",
      "answer":
      "You can book appointments through the app, call our clinics directly, or visit our website. Emergency appointments are available 24/7."
    },
    {
      "question": "What should I bring to my pet's first visit?",
      "answer":
      "Please bring any previous medical records, current medications, vaccination records, and a list of questions you may have."
    },
    {
      "question": "Do you offer emergency services?",
      "answer":
      "Yes, our Emergency Pet Care Center provides 24/7 emergency services for urgent medical situations."
    },
    {
      "question": "How can I access my pet's health records?",
      "answer":
      "All health records are available through the PawfectCare app. You can view, download, and share records with other veterinarians as needed."
    },
  ];

  // Random pet store coordinates
  final List<LatLng> petStores = [
    LatLng(37.7749, -122.4194), // San Francisco
    LatLng(40.7128, -74.0060),  // New York
    LatLng(34.0522, -118.2437), // Los Angeles
  ];

  LatLng? selectedStore;

  @override
  void initState() {
    super.initState();
    selectedStore = petStores[Random().nextInt(petStores.length)];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint("Form Submitted: $formData");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message Sent!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact form
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text("Send us a Message",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Full Name *"),
                        onSaved: (val) => formData["name"] = val!,
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Email *"),
                        onSaved: (val) => formData["email"] = val!,
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Phone"),
                        onSaved: (val) => formData["phone"] = val!,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Category *"),
                        items: const [
                          DropdownMenuItem(value: "appointment", child: Text("Appointment")),
                          DropdownMenuItem(value: "medical", child: Text("Medical Question")),
                          DropdownMenuItem(value: "billing", child: Text("Billing")),
                          DropdownMenuItem(value: "emergency", child: Text("Emergency")),
                          DropdownMenuItem(value: "general", child: Text("General Inquiry")),
                          DropdownMenuItem(value: "feedback", child: Text("Feedback")),
                        ],
                        onChanged: (val) => formData["category"] = val!,
                        validator: (val) => val == null ? "Required" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Subject *"),
                        onSaved: (val) => formData["subject"] = val!,
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Message *"),
                        maxLines: 5,
                        onSaved: (val) => formData["message"] = val!,
                        validator: (val) => val!.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text("Send Message"),
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Contact
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text("Phone"),
                subtitle: const Text("+1 (555) 123-PETS"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text("Email"),
                subtitle: const Text("support@pawfectcare.com"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.orange),
                title: const Text("Response Time"),
                subtitle: const Text("Within 24 hours"),
              ),
            ),
            const SizedBox(height: 20),

            // Emergency
            Card(
              color: Colors.red[50],
              child: ListTile(
                leading: const Icon(Icons.emergency, color: Colors.red),
                title: const Text("Emergency Contact", style: TextStyle(color: Colors.red)),
                subtitle: const Text("+1 (555) 911-PETS\n24/7 Emergency Line"),
              ),
            ),
            const SizedBox(height: 20),

            // Locations
            const Text("Our Locations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: locations.map((loc) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text(loc["name"]!),
                    subtitle: Text("${loc["address"]}\n${loc["hours"]}"),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Map (OpenStreetMap)
            const Text("Find a Pet Store",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  center: selectedStore!,
                  zoom: 12.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                    Marker(
                    point: selectedStore!,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // FAQs
            const Text("Frequently Asked Questions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: faqs.map((faq) {
                return ExpansionTile(
                  title: Text(faq["question"]!),
                  children: [Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(faq["answer"]!),
                  )],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String species = "";
  String breed = "";
  String age = "";
  File? photo;

  final ImagePicker _picker = ImagePicker();
  final PetService _petService = PetService();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _petService.addPet(
          name: name,
          species: species,
          breed: breed,
          age: age,
          photo: photo,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pet added successfully ✅")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Pet',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Pet Name *"),
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Species *"),
                items: const [
                  DropdownMenuItem(value: "dog", child: Text("Dog")),
                  DropdownMenuItem(value: "cat", child: Text("Cat")),
                  DropdownMenuItem(value: "rabbit", child: Text("Rabbit")),
                  DropdownMenuItem(value: "bird", child: Text("Bird")),
                  DropdownMenuItem(value: "hamster", child: Text("Hamster")),
                  DropdownMenuItem(value: "other", child: Text("Other")),
                ],
                onChanged: (value) => species = value!,
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Breed"),
                onSaved: (value) => breed = value ?? "",
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration:
                const InputDecoration(labelText: "Age * (e.g., 2)"),
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => age = value!,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: photo == null
                        ? const Text("Tap to upload pet photo")
                        : Image.file(photo!, height: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Add Pet"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PetProfileListPage extends StatelessWidget {
  const PetProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Icon(Icons.pets, size: 56, color: Colors.green),
              SizedBox(height: 12),
              Text(
                'My Pets',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              PetProfile(), // ✅ your widget is placed here
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- PetProfile widget -----------------

class PetProfile extends StatelessWidget {
  const PetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = {
      "name": "Max",
      "species": "Dog",
      "breed": "Golden Retriever",
      "age": "3 years",
      "gender": "Male",
      "weight": "25 kg",
      "color": "Golden",
      "microchipId": "123456789",
      "status": "Healthy",
      "photo": "🐕",
    };

    final vaccinations = [
      {"name": "Rabies", "date": "2024-01-15", "nextDue": "2025-01-15", "status": "Up to date"},
      {"name": "DHPP", "date": "2024-02-10", "nextDue": "2025-02-10", "status": "Up to date"},
      {"name": "Bordetella", "date": "2023-11-20", "nextDue": "2024-11-20", "status": "Due Soon"},
    ];

    final healthRecords = [
      {"date": "2024-08-15", "type": "Checkup", "vet": "Dr. Smith", "notes": "General health checkup - all good"},
      {"date": "2024-06-10", "type": "Vaccination", "vet": "Dr. Johnson", "notes": "Annual vaccinations completed"},
      {"date": "2024-03-22", "type": "Dental", "vet": "Dr. Smith", "notes": "Dental cleaning performed"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pet Info Card
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(pet["photo"]!, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(pet["name"]!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("${pet["breed"]} • ${pet["age"]}"),
                Chip(label: Text(pet["status"]!)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3,
                  children: [
                    _infoTile("Species", pet["species"]!),
                    _infoTile("Gender", pet["gender"]!),
                    _infoTile("Weight", pet["weight"]!),
                    _infoTile("Color", pet["color"]!),
                  ],
                ),
                const SizedBox(height: 16),
                if (pet["microchipId"] != null)
                  Column(
                    children: [
                      const Divider(),
                      const SizedBox(height: 8),
                      Text("Microchip ID: ${pet["microchipId"]!}"),
                    ],
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Book Appointment"),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Add Photo"),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Vaccination Status
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Vaccination Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...vaccinations.map((vaccine) => ListTile(
                  title: Text(vaccine["name"]!),
                  subtitle: Text("Last: ${vaccine["date"]} | Next: ${vaccine["nextDue"]}"),
                  trailing: Chip(
                    label: Text(vaccine["status"]!),
                    backgroundColor: vaccine["status"] == "Up to date" ? Colors.green[100] : Colors.red[100],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Medical Records
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Medical History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...healthRecords.map((record) => ListTile(
                  leading: const Icon(Icons.health_and_safety, color: Colors.green),
                  title: Text(record["type"]!),
                  subtitle: Text("Dr: ${record["vet"]} • ${record["notes"]}"),
                  trailing: Chip(label: Text(record["date"]!)),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Appointments
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Upcoming Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Icon(Icons.calendar_month, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text("No upcoming appointments"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class CareTipsPage extends StatelessWidget {
  const CareTipsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: const [Text('Care Tips', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(height: 12), Text('- Tip 1: Keep your pet hydrated.'), SizedBox(height: 6), Text('- Tip 2: Regular checkups.')])));
}

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: SafeArea(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             const TextField(decoration: InputDecoration(labelText: 'Email')),
//             const SizedBox(height: 8),
//             const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               onPressed: () {},
//               child: const Text('Login', style: TextStyle(color: Colors.white)),
//             )
//           ]),
//         ),
//       ),
//     ),
//   );
// }

// class SignupPage extends StatelessWidget {
//   const SignupPage({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: SafeArea(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Signup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             const TextField(decoration: InputDecoration(labelText: 'Name')),
//             const SizedBox(height: 8),
//             const TextField(decoration: InputDecoration(labelText: 'Email')),
//             const SizedBox(height: 8),
//             const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               onPressed: () {},
//               child: const Text('Create Account', style: TextStyle(color: Colors.white)),
//             )
//           ]),
//         ),
//       ),
//     ),
//   );
// }

// class ForgotPasswordPage extends StatelessWidget {
//   const ForgotPasswordPage({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: SafeArea(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Forgot Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             const TextField(decoration: InputDecoration(labelText: 'Email')),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               onPressed: () {},
//               child: const Text('Reset Password', style: TextStyle(color: Colors.white)),
//             )
//           ]),
//         ),
//       ),
//     ),
//   );
// }

// -------------------- End --------------------
