import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'AppointmentPage.dart';
import 'PetStorePage.dart';

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
                  SizedBox(height: 160, child: ListView(scrollDirection: Axis.horizontal, children: const [_StoreItem(), _StoreItem(), _StoreItem()])),
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
  const _QuickStatsCard({super.key});

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
  const _MiniCard({this.color = Colors.green, required this.title, required this.subtitle, super.key});

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
  const _StoreItem({super.key});
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
  const _SectionHeader({required this.title, required this.actionLabel, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), TextButton(onPressed: onPressed, child: Text(actionLabel))]);
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
      "pet": {"name": "Max", "species": "Dog", "emoji": "🐕"},
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
      "pet": {"name": "Luna", "species": "Cat", "emoji": "🐱"},
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
      "pet": {"name": "Coco", "species": "Rabbit", "emoji": "🐰"},
      "veterinarian": "Dr. Emily Brown",
      "clinic": "Animal Care Center",
      "date": "2024-08-10",
      "time": "11:00 AM",
      "type": "Dental Cleaning",
      "status": "completed"
    },
    {
      "id": "4",
      "pet": {"name": "Max", "species": "Dog", "emoji": "🐕"},
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(appointment["pet"]["emoji"],
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(appointment["pet"]["name"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(appointment["pet"]["species"],
                    style: const TextStyle(color: Colors.grey)),
              ]),
            ]),
            Chip(
              label: Text(appointment["status"].toString().toUpperCase()),
              backgroundColor: _statusColor(appointment["status"]).withOpacity(0.2),
              labelStyle: TextStyle(color: _statusColor(appointment["status"])),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(appointment["date"]),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(appointment["time"]),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(appointment["clinic"]),
          ]),
          const SizedBox(height: 8),
          Text("Dr: ${appointment["veterinarian"]}",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text("Type: ${appointment["type"]}"),
          if (appointment["phone"] != null)
            Row(children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(appointment["phone"]),
            ]),
          if (showActions) ...[
            const Divider(height: 24),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Reschedule"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Cancel"),
                ),
              ),
            ]),
          ]
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: const [
                  Icon(Icons.calendar_month, color: Colors.green),
                  SizedBox(width: 8),
                  Text("My Appointments",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const BookAppointmentPage()));
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Book New"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),

          // Search box
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search appointments...",
                prefixIcon: const Icon(Icons.search),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => searchTerm = val),
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Upcoming (${upcomingAppointments.length})"),
              Tab(text: "Past (${pastAppointments.length})"),
            ],
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
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

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();

  // Pet data
  String name = "";
  String species = "";
  String breed = "";
  String age = "";
  String gender = "";
  String weight = "";
  String color = "";
  String microchipId = "";
  String description = "";
  File? photo;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      debugPrint("Adding pet: $name, $species");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pet added successfully!")),
      );

      // Navigate to AppointmentPage with petName
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentPage(petName: name),
        ),
      );
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                const InputDecoration(labelText: "Age * (e.g., 2 years)"),
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => age = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Gender *"),
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (value) => gender = value!,
                validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Weight (e.g., 5kg)"),
                onSaved: (value) => weight = value ?? "",
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Color"),
                onSaved: (value) => color = value ?? "",
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Microchip ID"),
                onSaved: (value) => microchipId = value ?? "",
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: photo == null
                        ? const Text("Tap to upload pet photo")
                        : Image.file(photo!, height: 100),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Additional Notes"),
                maxLines: 3,
                onSaved: (value) => description = value ?? "",
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {},
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            )
          ]),
        ),
      ),
    ),
  );
}

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Signup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {},
              child: const Text('Create Account', style: TextStyle(color: Colors.white)),
            )
          ]),
        ),
      ),
    ),
  );
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Forgot Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {},
              child: const Text('Reset Password', style: TextStyle(color: Colors.white)),
            )
          ]),
        ),
      ),
    ),
  );
}

// -------------------- End --------------------
