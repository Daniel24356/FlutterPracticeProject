import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/appointment_service.dart';

enum AppointmentStatus { Upcoming, Completed, Cancelled }

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key, required String petName});

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
    DateTime selectedDateTime =
    DateTime.now().add(const Duration(days: 1));

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
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                controller: controller,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text('Book Appointment',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _appointmentService.bookAppointment(
                              petId: "somePetId", // 🔥 plug in actual petId
                              vetId: "someVetId", // 🔥 plug in actual vetId
                              dateTime: selectedDateTime,
                              reason: reasonController.text.trim(),
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Appointment booked ✅')),
                            );
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
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: ListTile(
        leading: _petAvatar("dog"), // 🔥 you can load actual petType here
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
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
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) =>
                buildAppointmentCard(docs[i].data() as Map<String, dynamic>),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openBookingSheet,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Book',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
