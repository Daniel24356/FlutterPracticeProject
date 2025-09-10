import 'package:flutter/material.dart';

void main() {
  runApp(const PetDashboardApp());
}

class PetDashboardApp extends StatelessWidget {
  const PetDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare Dashboard',
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

  final List<Widget> _pages = const [
    IndexPage(),
    AppointmentListPage(),
    PetStorePage(),
    HealthRecordsPage(),
    ContactPage(),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('PetCare', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu, color: Colors.green), onPressed: () => Scaffold.of(c).openDrawer())),
        actions: [
          IconButton(
            onPressed: () => _openRoute(const BookAppointmentPage()),
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
            tooltip: 'Quick Book',
          )
        ],
      ),
      body: PageView(controller: _pageController, physics: const BouncingScrollPhysics(), children: _pages, onPageChanged: (i) => setState(() => _selectedIndex = i)),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
        child: FloatingActionButton.extended(
          onPressed: () => _openRoute(const BookAppointmentPage()),
          backgroundColor: Colors.green,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Book', style: TextStyle(color: Colors.white)),
        ),
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_information), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_page), label: 'Contact'),
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
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, backgroundColor: Colors.white, child: const Icon(Icons.pets, color: Colors.green, size: 28)),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Hello, Alex', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
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
                  _drawerItem(context, Icons.add_circle_outline, 'Book Appointment', () => _openRoute(const BookAppointmentPage())),
                  _drawerItem(context, Icons.calendar_today, 'Appointments', () => _openRoute(const AppointmentListPage())),
                  _drawerItem(context, Icons.medical_services, 'Health Records', () => _openRoute(const HealthRecordsPage())),
                  _drawerItem(context, Icons.store, 'Pet Store', () => _openRoute(const PetStorePage())),
                  _drawerItem(context, Icons.lightbulb, 'Care Tips', () => _openRoute(const CareTipsPage())),
                  _drawerItem(context, Icons.contact_mail, 'Contact', () => _openRoute(const ContactPage())),
                  const Divider(),
                  _drawerItem(context, Icons.login, 'Login', () => _openRoute(const LoginPage())),
                  _drawerItem(context, Icons.app_registration, 'Signup', () => _openRoute(const SignupPage())),
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

// ---------------------- Placeholder Pages ----------------------
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dashboard', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                _QuickStatsCard()
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _SectionHeader(title: 'Upcoming Appointments', actionLabel: 'View all', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AppointmentListPage()))),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 140,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.86),
                      children: const [
                        _MiniCard(color: Colors.green, title: 'Buddy', subtitle: 'Grooming • 12 Sept'),
                        _MiniCard(color: Colors.green, title: 'Milo', subtitle: 'Vaccination • 15 Sept'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(title: 'Store Picks', actionLabel: 'Open Store', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PetStorePage()))),
                  const SizedBox(height: 8),
                  SizedBox(height: 160, child: ListView(scrollDirection: Axis.horizontal, children: const [ _StoreItem(), _StoreItem(), _StoreItem() ])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _QuickStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: const [
          Icon(Icons.calendar_month, color: Colors.white),
          SizedBox(width: 8),
          Text('3 Appointments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  const _MiniCard({this.color = Colors.green, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const Icon(Icons.chevron_right, color: Colors.green)]),
        const Spacer(),
        Text(subtitle, style: const TextStyle(color: Colors.black54)),
      ]),
    );
  }
}

class _StoreItem extends StatelessWidget {
  const _StoreItem();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      padding: const EdgeInsets.all(12),
      child: Column(children: const [Icon(Icons.pets, size: 48, color: Colors.green), SizedBox(height: 8), Text('Premium Kibble', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onPressed;
  const _SectionHeader({required this.title, required this.actionLabel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), TextButton(onPressed: onPressed, child: Text(actionLabel))]);
  }
}

// -------------------- Pages placeholders --------------------
class AppointmentListPage extends StatelessWidget {
  const AppointmentListPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Appointments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookAppointmentPage())), child: const Text('Book New', style: TextStyle(color: Colors.white)))]))));
}

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Book Appointment', style: TextStyle(color: Colors.green)), backgroundColor: Colors.white, elevation: 0), body: const Center(child: Text('Booking form (use the Flutter appointment sheet)')));
}

class PetStorePage extends StatelessWidget {
  const PetStorePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.storefront, size: 56, color: Colors.green), SizedBox(height: 12), Text('Pet Store', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
}

class HealthRecordsPage extends StatelessWidget {
  const HealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.medical_information, size: 56, color: Colors.green), SizedBox(height: 12), Text('Health Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.contact_page, size: 56, color: Colors.green), SizedBox(height: 12), Text('Contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
}

class AddPetPage extends StatelessWidget {
  const AddPetPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Add Pet', style: TextStyle(color: Colors.green)), backgroundColor: Colors.white, elevation: 0), body: const Center(child: Text('Add Pet Form')));
}

class PetProfileListPage extends StatelessWidget {
  const PetProfileListPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.pets, size: 56, color: Colors.green), SizedBox(height: 12), Text('My Pets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]))));
}

class CareTipsPage extends StatelessWidget {
  const CareTipsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: const [Text('Care Tips', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(height: 12), Text('- Tip 1: Keep your pet hydrated.'), SizedBox(height: 6), Text('- Tip 2: Regular checkups.')])));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), TextField(decoration: const InputDecoration(labelText: 'Email')), const SizedBox(height: 8), TextField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true), const SizedBox(height: 12), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () {}, child: const Text('Login', style: TextStyle(color: Colors.white))) ])))));
}

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Signup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), TextField(decoration: const InputDecoration(labelText: 'Name')), const SizedBox(height: 8), TextField(decoration: const InputDecoration(labelText: 'Email')), const SizedBox(height: 8), TextField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true), const SizedBox(height: 12), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () {}, child: const Text('Create Account', style: TextStyle(color: Colors.white))) ])))));
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Forgot Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), TextField(decoration: const InputDecoration(labelText: 'Email')), const SizedBox(height: 12), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () {}, child: const Text('Reset Password', style: TextStyle(color: Colors.white))) ])))));
}

// -------------------- End --------------------
