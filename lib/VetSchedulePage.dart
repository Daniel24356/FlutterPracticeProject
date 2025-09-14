// lib/vet_schedule_page.dart

// lib/vet_schedule_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';

// ----------------------------- Models ------------------------------------

enum ApptStatus { pending, confirmed, rescheduled, cancelled }

class Appointment {
  String id;
  String title;
  String timeRange; // "10:30 AM - 11:00 AM"
  String petName;
  String petImageAsset; // local asset path e.g. images/owners/owner1.png
  String petCategoryAsset; // local asset path e.g. images/pets/dog.png
  ApptStatus status;
  Color cardColor;
  String room;
  DateTime date;

  Appointment({
    required this.id,
    required this.title,
    required this.timeRange,
    required this.petName,
    required this.petImageAsset,
    required this.petCategoryAsset,
    required this.status,
    required this.cardColor,
    required this.room,
    required this.date,
  });
}

class DayAvailability {
  bool isAvailable;
  int slots;
  TimeOfDay? from;
  TimeOfDay? to;

  DayAvailability({this.isAvailable = true, this.slots = 4, this.from, this.to});
}

// --------------------------- VetSchedulePage ------------------------------

class VetSchedulePage extends StatefulWidget {
  const VetSchedulePage({super.key});
  @override
  _VetSchedulePageState createState() => _VetSchedulePageState();
}

class _VetSchedulePageState extends State<VetSchedulePage>
    with SingleTickerProviderStateMixin {
  // Date state
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Filter tabs
  int _filterIndex = 0; // 0 = all/pending, 1 = confirmed, 2 = rescheduled

  // Date list scroll controller
  final ScrollController _dateScrollController = ScrollController();

  // For showing month indicator while scrolling
  // String? _visibleMonthLabel;

  // Appointment storage by date string
  final Map<String, List<Appointment>> _appointmentsByDate = {};

  // Availability storage per date (map key yyyy-MM-dd)
  final Map<String, DayAvailability> _availabilityByDate = {};

  // Tab controller for mini-filters (Confirmed / Pending / Rescheduled)
  late TabController _miniTabController;

  @override
  void initState() {
    super.initState();
    _miniTabController = TabController(length: 3, vsync: this);
    _setupDummyData();
    // _visibleMonthLabel = _monthLabel(_selectedDay);
    _dateScrollController.addListener(_onDateScroll);
    // ensure date bar starts with selected day visible at beginning
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  @override
  void dispose() {
    _dateScrollController.removeListener(_onDateScroll);
    _dateScrollController.dispose();
    _miniTabController.dispose();
    super.dispose();
  }

  void _setupDummyData() {
    // Create some dummy appointments (local images must exist)
    void addAppt(DateTime date, Appointment appt) {
      final key = _dateKey(date);
      _appointmentsByDate.putIfAbsent(key, () => []).add(appt);
    }

    final today = DateTime.now();
    addAppt(
      today,
      Appointment(
        id: 'a1',
        title: 'General Checkup',
        timeRange: '10:30 AM - 11:00 AM',
        petName: 'Max',
        petImageAsset: 'images/maltese.png',
        petCategoryAsset: 'Dog',
        status: ApptStatus.pending,
        cardColor: const Color(0xFFD9F7E2),
        room: 'Room 2',
        date: today,
      ),
    );

    addAppt(
      today,
      Appointment(
        id: 'a2',
        title: 'Vaccination',
        timeRange: '12:00 PM - 12:30 PM',
        petName: 'Luna',
        petImageAsset: 'images/luna.jpg',
        petCategoryAsset: 'Cat',
        status: ApptStatus.confirmed,
        cardColor: const Color(0xFFFFFFFF),
        room: 'Room 3',
        date: today,
      ),
    );

    final tomorrow = today.add(const Duration(days: 1));
    addAppt(
      tomorrow,
      Appointment(
        id: 'a3',
        title: 'Consultation',
        timeRange: '09:00 AM - 09:30 AM',
        petName: 'Dash',
        petImageAsset: 'images/dash.jpg',
        petCategoryAsset: 'Rabbit',
        status: ApptStatus.rescheduled,
        cardColor: const Color(0xFFFFF6E6),
        room: 'Room 1',
        date: tomorrow,
      ),
    );

    // Default availability for today
    _availabilityByDate[_dateKey(today)] = DayAvailability(isAvailable: true, slots: 4, from: TimeOfDay(hour: 9, minute: 0), to: TimeOfDay(hour: 15, minute: 0));
  }

  // -------------------- utilities --------------------

  String _dateKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  // String _monthLabel(DateTime d) => DateFormat('MMMM yyyy').format(d);

  // Called during date list scrolling to compute visible month label
  void _onDateScroll() {
    // Each tab width approx 68 (we used this in layout) + horizontal margin 16
    // We'll compute index by dividing offset by approx item extent
    const double itemWidth = 68 + 16; // matches layout below
    final offset = _dateScrollController.offset;
    if (offset < 0) return;
    final index = (offset / itemWidth).floor();
    final visibleDay = _focusedDay.add(Duration(days: index));
    // final label = _monthLabel(visibleDay);
    // if (label != _visibleMonthLabel) {
    //   setState(() => _visibleMonthLabel = label);
    //   // hide after 2 seconds
    //   Future.delayed(const Duration(seconds: 2), () {
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   });
    // }
  }

  Future<void> _openCompactCalendar() async {
    // Use a compact dialog height
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Pick a date', style: Theme.of(context).textTheme.titleMedium),
              ),
              Flexible(
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                  onDaySelected: (selected, focused) {
                    Navigator.of(context).pop(selected);
                  },
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDay = picked;
        _focusedDay = picked;
      });
      _scrollToSelectedDay();
    }
  }

  // Scroll date bar so the selected day is at start
  void _scrollToSelectedDay() {
    final diffDays = _selectedDay.difference(_focusedDay).inDays;
    // if selected is before focused, adjust focused to selected
    // We'll scroll so selected appears as the first visible item by setting offset to itemWidth * 2 (since we center around focused earlier)
    const double itemWidth = 68 + 16;
    final offset = (2 + diffDays) * itemWidth; // we generate list with index offset earlier
    _dateScrollController.animateTo(offset.clamp(0.0, _dateScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  // -------------------- UI builders --------------------

  // pulse dot widget used for red/green status
  Widget _pulseDot(Color color) => _PulseDot(color: color);

  // Date tab widget
  Widget _dateTab(DateTime day) {
    final isSelected = isSameDay(day, _selectedDay);
    final key = _dateKey(day);
    final appts = _appointmentsByDate[key] ?? [];
    final hasNew = appts.any((a) => a.status == ApptStatus.pending);
    final hasConfirmed = appts.any((a) => a.status == ApptStatus.confirmed);
    final dotWidget = hasNew
        ? _pulseDot(Colors.red)
        : (hasConfirmed ? _pulseDot(Colors.green) : null);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          _focusedDay = day;
        });
        _scrollToSelectedDay();
      },
      child: SizedBox(
        width: 68,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade200 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300),
                boxShadow: [
                  if (!isSelected)
                    const BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('E').format(day),
                        style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black54)),
                    const SizedBox(height: 6),
                    Text('${day.day}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
                    const SizedBox(height: 6),
                    Text(DateFormat('MMM').format(day),
                        style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : Colors.black45)),
                  ],
                ),
              ),
            ),
            if (dotWidget != null)
              Positioned(top: 6, right: 12, child: dotWidget),
          ],
        ),
      ),
    );
  }

  // Schedule card for vet view (owner info + pet category)
  Widget _scheduleCard(Appointment appt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appt.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ROW 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Column 1: Schedule icon + times
              SizedBox(
                width: 70,
                child: Column(
                  children: [
                    const Icon(Icons.access_time,
                        size: 18, color: Colors.black54),
                    const SizedBox(height: 6),
                    Text(
                      _start(appt.timeRange),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: List.generate(
                        3,
                            (i) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _end(appt.timeRange),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 15),
              // Column 2: Title + Owner info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 29,
                          backgroundImage: AssetImage(appt.petImageAsset),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            appt.petName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Column 3: Status pill + Pet category image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusBg(appt.status),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      _statusText(appt.status),
                      style: TextStyle(
                        color: _statusColor(appt.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.pets, size: 15, color: Colors.orange),
                        SizedBox(width: 5,),
                        Text(
                          (appt.petCategoryAsset),
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 25,),

                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ROW 2: Confirm + Reschedule buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: appt.status == ApptStatus.confirmed
                      ? null
                      : () => _confirmAppointment(appt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _rescheduleAppointment(appt),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: Colors.blueGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                  const Text('Reschedule', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Color _statusBg(ApptStatus s) {
    switch (s) {
      case ApptStatus.pending:
        return Colors.red.shade50;
      case ApptStatus.confirmed:
        return Colors.green.shade50;
      case ApptStatus.rescheduled:
        return Colors.orange.shade50;
      case ApptStatus.cancelled:
        return Colors.grey.shade200;
    }
  }

  Color _statusColor(ApptStatus s) {
    switch (s) {
      case ApptStatus.pending:
        return Colors.red;
      case ApptStatus.confirmed:
        return Colors.green;
      case ApptStatus.rescheduled:
        return Colors.orange;
      case ApptStatus.cancelled:
        return Colors.grey;
    }
  }

  String _statusText(ApptStatus s) {
    switch (s) {
      case ApptStatus.pending:
        return 'PENDING';
      case ApptStatus.confirmed:
        return 'CONFIRMED';
      case ApptStatus.rescheduled:
        return 'RESCHEDULED';
      case ApptStatus.cancelled:
        return 'CANCELLED';
    }
  }

  void _confirmAppointment(Appointment a) {
    setState(() => a.status = ApptStatus.confirmed);
  }

  Future<void> _rescheduleAppointment(Appointment a) async {
    // simple reschedule: pick new date/time via dialog -> update appointment.date/time-range
    final newDate = await showDatePicker(
      context: context,
      initialDate: a.date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDate != null) {
      final newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (newTime != null) {
        final newRange = '${newTime.format(context)} - ${newTime.replacing(hour: newTime.hour+1).format(context)}';
        setState(() {
          // remove from old date
          _appointmentsByDate[_dateKey(a.date)]?.removeWhere((x) => x.id == a.id);
          a.date = newDate;
          a.timeRange = newRange;
          a.status = ApptStatus.rescheduled;
          // add to new date list
          _appointmentsByDate.putIfAbsent(_dateKey(newDate), () => []).add(a);
        });
      }
    }
  }

  String _start(String range) => range.split('-').first.trim();
  String _end(String range) => range.contains('-') ? range.split('-').last.trim() : '';

  // -------------------- Availability UI --------------------

  DayAvailability _getAvailabilityFor(DateTime day) {
    return _availabilityByDate.putIfAbsent(_dateKey(day), () => DayAvailability(isAvailable: true, slots: 4, from: TimeOfDay(hour: 9, minute: 0), to: TimeOfDay(hour: 15, minute: 0)));
  }

  Future<void> _editAvailability(DateTime day) async {
    final key = _dateKey(day);
    final current = _getAvailabilityFor(day);
    int slots = current.slots;
    TimeOfDay? from = current.from;
    TimeOfDay? to = current.to;
    bool isAvailable = current.isAvailable;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Availability - ${DateFormat.yMMMd().format(day)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Switch(value: isAvailable, onChanged: (v) => setState(() => isAvailable = v)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(
                  initialValue: slots.toString(),
                  decoration: const InputDecoration(labelText: 'Slots'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => slots = int.tryParse(v) ?? slots,
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton(onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: from ?? TimeOfDay(hour: 9, minute: 0));
                  if (picked != null) setState(() => from = picked);
                }, child: Text(from != null ? from!.format(context) : 'From'))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: to ?? TimeOfDay(hour: 15, minute: 0));
                  if (picked != null) setState(() => to = picked);
                }, child: Text(to != null ? to!.format(context) : 'To'))),
              ]),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {
                setState(() {
                  _availabilityByDate[key] = DayAvailability(isAvailable: isAvailable, slots: slots, from: from, to: to);
                });
                Navigator.pop(ctx);
              }, child: const Text('Save')),
              const SizedBox(height: 12),
            ]),
          ),
        );
      },
    );
  }

  // -------------------- Build --------------------

  @override
  Widget build(BuildContext context) {
    final dayKey = _dateKey(_selectedDay);
    final allAppts = _appointmentsByDate[dayKey] ?? [];
    // apply mini-filter
    final filteredAppts = allAppts.where((a) {
      if (_miniTabController.index == 0) return a.status == ApptStatus.pending;
      if (_miniTabController.index == 1) return a.status == ApptStatus.confirmed;
      return a.status == ApptStatus.rescheduled;
    }).toList();

    // Also prepare "all" view when tab 0 and if no pending use all
    final displayAppts = filteredAppts.isEmpty && _miniTabController.index == 0 ? allAppts : filteredAppts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "My Schedule",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(children: [
          // top mini toolbar: availability + edit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editAvailability(_selectedDay),
                  icon: const Icon(Icons.schedule),
                  label: Text('Availability: ${_getAvailabilityFor(_selectedDay)}'),
                ),
              ),
              // const SizedBox(width: 8),
              // ElevatedButton(onPressed: () {
              //   // toggle day-wide not available
              //   final key = _dateKey(_selectedDay);
              //   final cur = _getAvailabilityFor(_selectedDay);
              //   setState(() => _availabilityByDate[key] = DayAvailability(isAvailable: !cur.isAvailable, slots: cur.slots, from: cur.from, to: cur.to));
              // }, child: const Text('Toggle Not Avail')),
            ]),
          ),

          // date horizontal bar with month label overlay
          Stack(children: [
            SizedBox(
              height: 96,
              child: ListView.builder(
                controller: _dateScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, i) {
                  final day = _focusedDay.add(Duration(days: i - 2));
                  return _dateTab(day);
                },
              ),
            ),

          ]),

          // mini filter tabs
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
                controller: _miniTabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),

                ),
                indicatorSize: TabBarIndicatorSize.tab, // makes indicator cover full tab
                dividerColor: Colors.transparent, // removes bottom border (Flutter 3.7+)
                tabs: const [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Text('Pending', style: TextStyle(fontSize: 12.5)),

                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Text('Confirmed', style: TextStyle(fontSize: 12.5),),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Text('Rescheduled', style: TextStyle(fontSize: 12.5),),
                    ),
                  ),
                ],
                onTap: (idx) => setState(() {}),
              ),
            ),
          ),


          // appointment list (expanded to prevent flex overflow)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: displayAppts.isEmpty
                  ? Center(child: Text('No appointments', style: TextStyle(color: Colors.grey.shade600)))
                  : ListView.builder(
                itemCount: displayAppts.length,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemBuilder: (context, idx) {
                  final appt = displayAppts[idx];
                  return _scheduleCard(appt);
                },
              ),
            ),
          ),
        ]),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => _openNewAppointmentSheet(),
      //   icon: const Icon(Icons.add),
      //   label: const Text('New Appointment'),
      // ),
    );
  }

  // open simple new appointment sheet (owner selects local images via pickers in real app)
  void _openNewAppointmentSheet() {
    // small demo form - in production you'd allow image picking and validation
    final titleCtl = TextEditingController();
    final ownerCtl = TextEditingController();
    DateTime date = _selectedDay;
    TimeOfDay time = TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('New Appointment', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(controller: titleCtl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextFormField(controller: ownerCtl, decoration: const InputDecoration(labelText: 'Owner name')),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () async {
                final d = await showDatePicker(context: ctx, initialDate: date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) date = d;
              }, child: const Text('Pick date'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(onPressed: () async {
                final t = await showTimePicker(context: ctx, initialTime: time);
                if (t != null) time = t;
              }, child: const Text('Pick time'))),
            ]),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {
              final newAppt = Appointment(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleCtl.text.isEmpty ? 'Consult' : titleCtl.text,
                timeRange: '${time.format(ctx)} - ${time.replacing(hour: time.hour+1).format(ctx)}',
                petName: ownerCtl.text.isEmpty ? 'Owner' : ownerCtl.text,
                petImageAsset: 'images/owners/default_owner.png', // placeholder local asset
                petCategoryAsset: 'rabbit',
                status: ApptStatus.pending,
                cardColor: Colors.white,
                room: 'Room 1',
                date: date,
              );
              setState(() {
                _appointmentsByDate.putIfAbsent(_dateKey(date), () => []).add(newAppt);
              });
              Navigator.pop(ctx);
            }, child: const Text('Create')),
            const SizedBox(height: 8),
          ]),
        ),
      );
    });
  }
}

// ------------------------- Pulse dot widget --------------------------------

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _anim = Tween(begin: 0.85, end: 1.25).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Container(width: 10, height: 10, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: widget.color.withOpacity(0.2), blurRadius: 6, spreadRadius: 1)])),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class VetSchedulePage extends StatefulWidget {
//   const VetSchedulePage({super.key});
//   @override
//   _VetSchedulePageState createState() => _VetSchedulePageState();
// }
//
// class _VetSchedulePageState extends State<VetSchedulePage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();
//
//   /// Appointments stored keyed by yyyy-MM-dd for quick date lookup
//   final Map<String, List<Map<String, String>>> _appointmentsByDate = {
//     "2025-09-19": [
//       {
//         "time": "08:30 AM - 09:30 AM",
//         "title": "Dog Vaccination",
//         "room": "Room 3, Vet Clinic",
//         "doctor": "Dr. Goodman",
//         // color as hex string to parse => fallback used if missing/invalid
//         "color": "0xFFCEFFE0",
//         // small image URL or local asset path (use network URL or 'images/...')
//         "petImage": "https://images.unsplash.com/photo-1558944351-d3f00a8a5a9a?w=200&q=80"
//       },
//       {
//         "time": "10:30 AM - 11:30 AM",
//         "title": "Cat Check-up",
//         "room": "Room 5, Vet Clinic",
//         "doctor": "Dr. Melton",
//         "color": "0xFFE6F7FF",
//         "petImage": "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=200&q=80"
//       },
//       {
//         "time": "01:00 PM - 02:00 PM",
//         "title": "Parrot Surgery",
//         "room": "Room 7, Vet Clinic",
//         "doctor": "Dr. Hodge",
//         "color": "0xFFFFF0E0",
//         "petImage": "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=200&q=80"
//       },
//     ],
//     "2025-09-20": [
//       {
//         "time": "09:00 AM - 10:00 AM",
//         "title": "Rabbit Dental Cleaning",
//         "room": "Room 2, Vet Clinic",
//         "doctor": "Dr. Goodman",
//         "color": "0xFFFFE0F0",
//         "petImage": "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80"
//       }
//     ],
//   };
//
//   List<Map<String, String>> _getDayAppointments(DateTime day) {
//     final key = DateFormat('yyyy-MM-dd').format(day);
//     return _appointmentsByDate[key] ?? [];
//   }
//
//   Future<void> _openCalendar() async {
//     DateTime? picked = await showDialog<DateTime>(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime(2020),
//             lastDay: DateTime(2030),
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selected, focused) {
//               Navigator.of(context).pop(selected);
//             },
//             headerStyle: const HeaderStyle(
//               titleCentered: true,
//               formatButtonVisible: false,
//             ),
//           ),
//         ),
//       ),
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDay = picked;
//         _focusedDay = picked;
//       });
//     }
//   }
//
//   Color _parseColor(String? hex, {Color fallback = Colors.white}) {
//     if (hex == null) return fallback;
//     try {
//       final value = int.parse(hex);
//       return Color(value);
//     } catch (_) {
//       return fallback;
//     }
//   }
//
//   // Split time like "10:30 AM - 12:00 PM"
//   String _startTime(String timeRange) {
//     if (timeRange.contains('-')) {
//       return timeRange.split('-')[0].trim();
//     }
//     return timeRange;
//   }
//
//   String _endTime(String timeRange) {
//     if (timeRange.contains('-')) {
//       return timeRange.split('-')[1].trim();
//     }
//     return '';
//   }
//
//   // A small helper to build the card similar to the screenshot
//   Widget _buildScheduleCard(Map<String, String> appt) {
//     final bg = _parseColor(appt["color"], fallback: Colors.white);
//     final title = appt["title"] ?? 'Appointment';
//     final time = appt["time"] ?? '';
//     final room = appt["room"] ?? '';
//     final doctor = appt["doctor"] ?? 'Doctor';
//     final petImage = appt["petImage"]; // may be network url or asset path
//
//     // Fix the card height so inner Column doesn't cause layout overflow
//     return Container(
//       height: 130, // keeps card compact and prevents vertical overflow
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Stack(
//         children: [
//           // subtle inner padding content
//           Positioned.fill(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Left column: times (fixed width)
//                   SizedBox(
//                     width: 76,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.access_time, size: 18, color: Colors.black54),
//                         const SizedBox(height: 8),
//                         Text(
//                           _startTime(time),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 6),
//                         // decorative dotted line
//                         Column(
//                           children: List.generate(3, (i) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(vertical: 2),
//                               width: 3,
//                               height: 3,
//                               decoration: BoxDecoration(
//                                 color: Colors.black26,
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                             );
//                           }),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           _endTime(time),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Middle: title and room + doctor
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Title centered and bold
//                         Text(
//                           title,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black87,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),
//
//                         // Room
//                         Text(
//                           room,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//
//                         // Doctor row with stethoscope and small pet image
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // pet image (default small) - circular
//                             CircleAvatar(
//                               radius: 16,
//                               backgroundColor: Colors.grey.shade200,
//                               backgroundImage: (petImage != null && petImage.startsWith('http'))
//                                   ? NetworkImage(petImage)
//                                   : (petImage != null && petImage.isNotEmpty)
//                                   ? AssetImage(petImage) as ImageProvider
//                                   : const NetworkImage('https://place-puppy.com/80x80') as ImageProvider,
//                             ),
//                             const SizedBox(width: 8),
//                             const Icon(Icons.medical_services, size: 16, color: Colors.green),
//                             const SizedBox(width: 6),
//                             Text(
//                               doctor,
//                               style: const TextStyle(fontWeight: FontWeight.w600),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Optional small top-right pill or calendar icon (left as placeholder)
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final todaysAppointments = _getDayAppointments(_selectedDay);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text("My Schedule", style: TextStyle(color: Colors.black)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_month, color: Colors.black),
//             onPressed: _openCalendar,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Horizontal date bar (scrollable)
//             SizedBox(
//               height: 92,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 21,
//                 itemBuilder: (context, index) {
//                   DateTime day = _focusedDay.add(Duration(days: index - 2));
//                   final isSelected = isSameDay(day, _selectedDay);
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedDay = day;
//                         _focusedDay = day;
//                       });
//                     },
//                     child: Container(
//                       width: 68,
//                       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.green.shade200 : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(DateFormat('E').format(day),
//                               style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black54)),
//                           const SizedBox(height: 6),
//                           Text('${day.day}',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
//                           const SizedBox(height: 6),
//                           Text(DateFormat('MMM').format(day),
//                               style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : Colors.black45)),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Appointment list occupies remaining space (scrollable)
//             Expanded(
//               child: todaysAppointments.isEmpty
//                   ? Center(child: Text("No appointments", style: TextStyle(color: Colors.grey.shade600)))
//                   : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: ListView.builder(
//                   itemCount: todaysAppointments.length,
//                   itemBuilder: (context, index) {
//                     final appt = todaysAppointments[index];
//                     return _buildScheduleCard(appt);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class VetSchedulePage extends StatefulWidget {
//   @override
//   _VetSchedulePageState createState() => _VetSchedulePageState();
// }
//
// class _VetSchedulePageState extends State<VetSchedulePage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();
//
//   // Dummy vet appointments
//   final Map<String, List<Map<String, String>>> appointments = {
//     "2025-09-19": [
//       {
//         "time": "08:30 AM - 09:30 AM",
//         "title": "Dog Vaccination",
//         "room": "Room 3, Vet Clinic",
//         "doctor": "Dr. Goodman",
//         "color": "0xFFFFFFFF"
//       },
//       {
//         "time": "10:30 AM - 11:30 AM",
//         "title": "Cat Check-up",
//         "room": "Room 5, Vet Clinic",
//         "doctor": "Dr. Melton",
//         "color": "0xFFCCFFCC"
//       },
//       {
//         "time": "01:00 PM - 02:00 PM",
//         "title": "Parrot Surgery",
//         "room": "Room 7, Vet Clinic",
//         "doctor": "Dr. Hodge",
//         "color": "0xFFE0E0FF"
//       },
//     ],
//     "2025-09-20": [
//       {
//         "time": "09:00 AM - 10:00 AM",
//         "title": "Rabbit Dental Cleaning",
//         "room": "Room 2, Vet Clinic",
//         "doctor": "Dr. Goodman",
//         "color": "0xFFFFE0E0"
//       }
//     ],
//   };
//
//   List<Map<String, String>> getDayAppointments(DateTime day) {
//     String key = DateFormat('yyyy-MM-dd').format(day);
//     return appointments[key] ?? [];
//   }
//
//   void _openCalendar() async {
//     DateTime? picked = await showDialog<DateTime>(
//       context: context,
//       builder: (context) => Dialog(
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: TableCalendar(
//
//             focusedDay: _focusedDay,
//             firstDay: DateTime(2020),
//             lastDay: DateTime(2030),
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selected, focused) {
//               setState(() {
//                 _selectedDay = selected;
//                 _focusedDay = focused;
//               });
//               Navigator.pop(context, selected);
//             },
//             headerStyle: HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//             ),
//           ),
//         ),
//       ),
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDay = picked;
//         _focusedDay = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> todaysAppointments = getDayAppointments(_selectedDay);
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text("My Schedule", style: TextStyle(color: Colors.black)),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_month, color: Colors.black),
//             onPressed: _openCalendar,
//           ),
//         ],
//       ),
//       body:
//           SafeArea(
//         child: Column(
//           children: [
//             // Horizontal date bar
//             Container(
//               height: 80,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 14,
//                 itemBuilder: (context, index) {
//                   DateTime day = _focusedDay.add(Duration(days: index));
//                   bool isSelected = isSameDay(day, _selectedDay);
//
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedDay = day;
//                       });
//                     },
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.purple[200] : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: isSelected ? Colors.purple : Colors.grey[300]!,
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(DateFormat("E").format(day),
//                               style: TextStyle(
//                                   color: isSelected ? Colors.white : Colors.black)),
//                           SizedBox(height: 4),
//                           Text("${day.day}",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                   isSelected ? Colors.white : Colors.black)),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Appointment list
//             Expanded(
//               child: todaysAppointments.isEmpty
//                   ? Center(
//                   child: Text("No appointments",
//                       style: TextStyle(color: Colors.grey, fontSize: 16)))
//                   : ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: todaysAppointments.length,
//                 itemBuilder: (context, index) {
//                   var appt = todaysAppointments[index];
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 16),
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Color(int.parse(appt["color"]!)),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         )
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(appt["title"]!,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                         SizedBox(height: 4),
//                         Text(appt["time"]!,
//                             style: TextStyle(color: Colors.grey[700])),
//                         SizedBox(height: 4),
//                         Text(appt["room"]!,
//                             style: TextStyle(color: Colors.grey[600])),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.grey[400],
//                               child: Icon(Icons.pets, color: Colors.white),
//                             ),
//                             SizedBox(width: 8),
//                             Text(appt["doctor"]!,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500)),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
