import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/appointmentService.dart';

enum AppointmentStatus { Upcoming, Completed, Cancelled }

class AppointmentPage extends StatefulWidget {
  final String petId;
  final String petName;
  final String userId; // Pet owner's UID

  const AppointmentPage({
    super.key,
    required this.petId,
    required this.petName,
    required this.userId,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppointmentService _appointmentService = AppointmentService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)}, ${dt.year}';
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$date • ${hour == 0 ? 12 : hour}:$minute $ampm';
  }

  String _monthName(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m - 1];
  }

  Widget _petAvatar(String petType) {
    String emoji;
    switch (petType.toLowerCase()) {
      case 'dog':
        emoji = '🐶';
        break;
      case 'cat':
        emoji = '🐱';
        break;
      case 'bird':
        emoji = '🐦';
        break;
      case 'fish':
        emoji = '🐠';
        break;
      default:
        emoji = '🐾';
    }
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.green.shade50,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }

  void _openBookingSheet() {
    final _formKey = GlobalKey<FormState>();
    final reasonController = TextEditingController();
    DateTime selectedDateTime = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                controller: controller,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text('Book Appointment',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Enter reason' : null,
                      ),
                      const SizedBox(height: 12),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // pick date
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate == null) return;

                            // pick time
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime == null) return;

                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            await _appointmentService.bookAppointment(
                              userId: widget.userId,
                              petId: widget.petId,
                              vetId: "someVetId", // 🔥 replace later
                              dateTime: selectedDateTime,
                              reason: reasonController.text.trim(),
                            );

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Appointment booked ✅')),
                            );
                            setState(() {}); // refresh UI
                          }
                        },
                        child: const Text('Book Appointment'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildAppointmentCard(Map<String, dynamic> data) {
    final status = data["status"] ?? "pending";
    final dt = (data["dateTime"] as Timestamp).toDate();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: ListTile(
        leading: _petAvatar(data["petType"] ?? "pet"),
        title: Text(data["reason"] ?? ""),
        subtitle: Text(_formatDateTime(dt)),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == "pending"
                ? Colors.orange
                : status == "completed"
                ? Colors.blue
                : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Appointments',
            style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .collection("pets")
            .doc(widget.petId)
            .collection("appointments")
            .orderBy("dateTime", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No appointments yet"));
          }
          final docs = snapshot.data!.docs;

          final upcoming = docs.where((d) {
            final dt = (d["dateTime"] as Timestamp).toDate();
            return dt.isAfter(DateTime.now()) &&
                (d["status"] ?? "pending") != "cancelled";
          }).toList();

          final completed = docs
              .where((d) => (d["status"] ?? "").toLowerCase() == "completed")
              .toList();

          final cancelled = docs
              .where((d) => (d["status"] ?? "").toLowerCase() == "cancelled")
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: upcoming.length,
                itemBuilder: (_, i) =>
                    buildAppointmentCard(upcoming[i].data() as Map<String, dynamic>),
              ),
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: completed.length,
                itemBuilder: (_, i) =>
                    buildAppointmentCard(completed[i].data() as Map<String, dynamic>),
              ),
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: cancelled.length,
                itemBuilder: (_, i) =>
                    buildAppointmentCard(cancelled[i].data() as Map<String, dynamic>),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openBookingSheet,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Book', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
