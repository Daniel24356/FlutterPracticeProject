import 'package:flutter/material.dart';

enum AppointmentStatus { Upcoming, Completed, Cancelled }

class Appointment {
  final String id;
  String ownerName;
  String contact;
  String petName;
  String petType;
  String service;
  DateTime dateTime;
  String notes;
  AppointmentStatus status;

  Appointment({
    required this.id,
    required this.ownerName,
    required this.contact,
    required this.petName,
    required this.petType,
    required this.service,
    required this.dateTime,
    this.notes = '',
    this.status = AppointmentStatus.Upcoming,
  });
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key, required String petName});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // sample data
    _appointments.addAll([
      Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerName: 'Ada Johnson',
        contact: '+2348012345678',
        petName: 'Buddy',
        petType: 'Dog',
        service: 'General Checkup',
        dateTime: DateTime.now().add(const Duration(days: 3, hours: 10)),
      ),
      Appointment(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        ownerName: 'Emeka',
        contact: '+2348098765432',
        petName: 'Milo',
        petType: 'Cat',
        service: 'Vaccination',
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        status: AppointmentStatus.Completed,
      ),
      Appointment(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        ownerName: 'Sade',
        contact: '+2348023456789',
        petName: 'Goldie',
        petType: 'Fish',
        service: 'Surgery',
        dateTime: DateTime.now().subtract(const Duration(days: 10)),
        status: AppointmentStatus.Cancelled,
      ),
    ]);
  }

  String _formatDateTime(DateTime dt) {
    final date = '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)}, ${dt.year}';
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$date • ${hour == 0 ? 12 : hour}:$minute $ampm';
  }

  String _monthName(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
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
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  void _openBookingSheet({Appointment? appointmentToEdit}) {
    final _formKey = GlobalKey<FormState>();
    final ownerController = TextEditingController(text: appointmentToEdit?.ownerName);
    final contactController = TextEditingController(text: appointmentToEdit?.contact);
    final petNameController = TextEditingController(text: appointmentToEdit?.petName);
    String petType = appointmentToEdit?.petType ?? 'Dog';
    String service = appointmentToEdit?.service ?? 'General Checkup';
    DateTime selectedDateTime = appointmentToEdit?.dateTime ?? DateTime.now().add(const Duration(days: 1));
    final notesController = TextEditingController(text: appointmentToEdit?.notes ?? '');

    Future<void> _pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) {
        selectedDateTime = DateTime(picked.year, picked.month, picked.day, selectedDateTime.hour, selectedDateTime.minute);
      }
    }

    Future<void> _pickTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (picked != null) {
        selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, picked.hour, picked.minute);
      }
    }

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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        appointmentToEdit == null ? 'Book Appointment' : 'Edit Appointment',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Owner
                      TextFormField(
                        controller: ownerController,
                        decoration: const InputDecoration(
                          labelText: 'Owner Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter owner name' : null,
                      ),
                      const SizedBox(height: 10),

                      // Contact
                      TextFormField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          labelText: 'Contact (phone or email)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Enter contact' : null,
                      ),
                      const SizedBox(height: 10),

                      // Pet name & type
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: petNameController,
                              decoration: const InputDecoration(
                                labelText: 'Pet Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Enter pet name' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: petType,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              items: ['Dog', 'Cat', 'Bird', 'Fish', 'Other']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => petType = v ?? 'Dog',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Service
                      DropdownButtonFormField<String>(
                        value: service,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        items: [
                          'General Checkup',
                          'Vaccination',
                          'Grooming',
                          'Surgery',
                          'Dental',
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => service = v ?? 'General Checkup',
                      ),
                      const SizedBox(height: 10),

                      // Date & Time
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await _pickDate();
                                setState(() {});
                              },
                              child: Text('Date: ${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await _pickTime();
                                setState(() {});
                              },
                              child: Text('${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Notes
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (appointmentToEdit == null) {
                              // add new
                              final newAppt = Appointment(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                ownerName: ownerController.text.trim(),
                                contact: contactController.text.trim(),
                                petName: petNameController.text.trim(),
                                petType: petType,
                                service: service,
                                dateTime: selectedDateTime,
                                notes: notesController.text.trim(),
                                status: AppointmentStatus.Upcoming,
                              );
                              setState(() => _appointments.insert(0, newAppt));
                              _tabController.animateTo(0);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment booked ✅')));
                            } else {
                              // edit
                              setState(() {
                                appointmentToEdit.ownerName = ownerController.text.trim();
                                appointmentToEdit.contact = contactController.text.trim();
                                appointmentToEdit.petName = petNameController.text.trim();
                                appointmentToEdit.petType = petType;
                                appointmentToEdit.service = service;
                                appointmentToEdit.dateTime = selectedDateTime;
                                appointmentToEdit.notes = notesController.text.trim();
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment updated ✅')));
                            }
                          }
                        },
                        child: Text(appointmentToEdit == null ? 'Book Appointment' : 'Save Changes'),
                      ),
                      const SizedBox(height: 20),
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

  Widget buildAppointmentCard(Appointment a) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _petAvatar(a.petType),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        a.petName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        a.status == AppointmentStatus.Upcoming
                            ? 'Upcoming'
                            : a.status == AppointmentStatus.Completed
                            ? 'Completed'
                            : 'Cancelled',
                        style: TextStyle(
                          color: a.status == AppointmentStatus.Upcoming
                              ? Colors.green
                              : a.status == AppointmentStatus.Completed
                              ? Colors.blue
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${a.service} • ${_formatDateTime(a.dateTime)}'),
                  const SizedBox(height: 6),
                  Text('Owner: ${a.ownerName} • ${a.contact}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildCardActions(a),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCardActions(Appointment a) {
    final List<Widget> actions = [];

    if (a.status == AppointmentStatus.Upcoming) {
      actions.add(TextButton(
        onPressed: () {
          // cancel
          setState(() => a.status = AppointmentStatus.Cancelled);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment cancelled')));
        },
        child: const Text('Cancel'),
      ));

      actions.add(const SizedBox(width: 8));

      actions.add(ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () => _openBookingSheet(appointmentToEdit: a),
        child: const Text('Reschedule', style: TextStyle(color: Colors.white)),
      ));
    } else if (a.status == AppointmentStatus.Completed) {
      actions.add(ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () async {
          // leave review - simple dialog
          final rating = await showDialog<int>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Leave a review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Thanks for using our service! Leave a short review.'),
                  const SizedBox(height: 12),
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write review...'),
                  )
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Close')),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(1), child: const Text('Submit')),
              ],
            ),
          );

          if (rating != null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks for the feedback!')));
          }
        },
        child: const Text('Leave Review', style: TextStyle(color: Colors.white)),
      ));
    } else if (a.status == AppointmentStatus.Cancelled) {
      actions.add(TextButton(
        onPressed: () {
          // delete (soft delete here)
          setState(() => _appointments.removeWhere((e) => e.id == a.id));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cancelled appointment removed')));
        },
        child: const Text('Delete'),
      ));

      actions.add(const SizedBox(width: 8));

      actions.add(ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () {
          // rebook copies details and opens booking
          _openBookingSheet(appointmentToEdit: Appointment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            ownerName: a.ownerName,
            contact: a.contact,
            petName: a.petName,
            petType: a.petType,
            service: a.service,
            dateTime: DateTime.now().add(const Duration(days: 2)),
            notes: a.notes,
            status: AppointmentStatus.Upcoming,
          ));
        },
        child: const Text('Rebook', style: TextStyle(color: Colors.white)),
      ));
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _appointments.where((a) => a.status == AppointmentStatus.Upcoming).toList();
    final completed = _appointments.where((a) => a.status == AppointmentStatus.Completed).toList();
    final cancelled = _appointments.where((a) => a.status == AppointmentStatus.Cancelled).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('My Appointments', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            children: upcoming.isEmpty
                ? [
              const SizedBox(height: 40),
              Center(child: Text('No upcoming appointments', style: TextStyle(color: Colors.grey.shade600))),
            ]
                : upcoming.map((a) => buildAppointmentCard(a)).toList(),
          ),

          // Completed
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            children: completed.isEmpty
                ? [
              const SizedBox(height: 40),
              Center(child: Text('No completed appointments', style: TextStyle(color: Colors.grey.shade600))),
            ]
                : completed.map((a) => buildAppointmentCard(a)).toList(),
          ),

          // Cancelled
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            children: cancelled.isEmpty
                ? [
              const SizedBox(height: 40),
              Center(child: Text('No cancelled appointments', style: TextStyle(color: Colors.grey.shade600))),
            ]
                : cancelled.map((a) => buildAppointmentCard(a)).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openBookingSheet(),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Book',
            style: TextStyle(color: Colors.white))
      ),
    );
  }
}

