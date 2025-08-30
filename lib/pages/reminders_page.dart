import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maternal_app/widgets/custom_appbar.dart';
import 'package:maternal_app/widgets/custom_bottom_navigation.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Sample reminder data
  final List<Map<String, dynamic>> _activeReminders = [
    {
      'id': '1',
      'title': 'Take Prenatal Vitamins',
      'type': 'Medication',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '8:00 AM',
      'notes': 'Take with breakfast',
      'status': 'active',
    },
    {
      'id': '2',
      'title': 'Hydration Check',
      'type': 'Daily Task',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '12:00 PM',
      'notes': 'Drink 8 glasses of water',
      'status': 'active',
    },
  ];

  final List<Map<String, dynamic>> _completedReminders = [
    {
      'id': '3',
      'title': 'Prenatal Yoga Session',
      'type': 'Exercise',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'time': '9:00 AM',
      'notes': '30-minute session',
      'status': 'completed',
    },
    {
      'id': '4',
      'title': 'Blood Test',
      'type': 'Medical',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'time': '10:30 AM',
      'notes': 'Fasting required',
      'status': 'completed',
    },
  ];

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedType;

  // Available reminder types
  final List<String> _reminderTypes = [
    'Medication',
    'Daily Task',
    'Exercise',
    'Medical',
    'Nutrition',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
           
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF8A4F7D),
              labelColor: const Color(0xFF8A4F7D),
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.afacad(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Reminders Tab
                _buildRemindersList(_activeReminders, true),

                // Completed Reminders Tab
                _buildRemindersList(_completedReminders, false),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: 2,
        onItemTapped: (index) {
          final routes = [
            '/home',
            '/appointment',
            '/reminders',
            '/payment',
            '/profile',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReminderBottomSheet(context),
        backgroundColor: const Color(0xFF8A4F7D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRemindersList(List<Map<String, dynamic>> reminders, bool isActive) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.notifications_none : Icons.history,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active reminders' : 'No completed reminders',
              style: GoogleFonts.afacad(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive ? 'Set your first reminder' : 'Your completed reminders will appear here',
              style: GoogleFonts.afacad(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return _buildReminderCard(reminder, isActive);
      },
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder, bool isActive) {
    final date = reminder['date'] as DateTime;
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    final status = reminder['status'] as String;

    Color statusColor;
    String statusText;

    switch (status) {
      case 'active':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Active';
        break;
      case 'completed':
        statusColor = const Color(0xFF9E9E9E);
        statusText = 'Completed';
        break;
      case 'cancelled':
        statusColor = const Color(0xFFF44336);
        statusText = 'Cancelled';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.afacad(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF555555),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.afacad(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              reminder['time'],
              style: GoogleFonts.afacad(
                fontSize: 14,
                color: const Color(0xFF8A4F7D),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A4F7D).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Color(0xFF8A4F7D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder['title'],
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Text(
                        reminder['type'],
                        style: GoogleFonts.afacad(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.note,
                  size: 16,
                  color: Color(0xFF8A4F7D),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    reminder['notes'],
                    style: GoogleFonts.afacad(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isActive && status == 'active')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showRescheduleDialog(reminder),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8A4F7D),
                        side: const BorderSide(color: Color(0xFF8A4F7D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Reschedule',
                        style: GoogleFonts.afacad(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showCancelDialog(reminder),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        foregroundColor: const Color(0xFFF44336),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.afacad(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showReminderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Set New Reminder',
                    style: GoogleFonts.afacad(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8A4F7D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Reminder Title',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: const Icon(Icons.notifications, color: Color(0xFF8A4F7D)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reminder title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Reminder Type',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: const Icon(Icons.category, color: Color(0xFF8A4F7D)),
                    ),
                    items: _reminderTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type, style: GoogleFonts.afacad()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a reminder type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      alignLabelWithHint: true,
                      prefixIcon: const Icon(Icons.note, color: Color(0xFF8A4F7D)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter notes for the reminder';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectDate(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8A4F7D),
                            side: const BorderSide(color: Color(0xFF8A4F7D)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                            style: GoogleFonts.afacad(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectTime(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8A4F7D),
                            side: const BorderSide(color: Color(0xFF8A4F7D)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : _selectedTime!.format(context),
                            style: GoogleFonts.afacad(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setReminder(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A4F7D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Set Reminder',
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8A4F7D),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8A4F7D),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8A4F7D),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8A4F7D),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _setReminder() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      // Here you would typically save the reminder to your backend

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reminder set successfully!',
            style: GoogleFonts.afacad(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Close the bottom sheet
      Navigator.pop(context);

      // Clear form
      _titleController.clear();
      _notesController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
        _selectedType = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields',
            style: GoogleFonts.afacad(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRescheduleDialog(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reschedule Reminder',
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8A4F7D),
          ),
        ),
        content: Text(
          'Are you sure you want to reschedule your reminder "${reminder['title']}" on ${DateFormat('MMM dd, yyyy').format(reminder['date'])}?',
          style: GoogleFonts.afacad(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.afacad(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showReminderBottomSheet(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A4F7D),
            ),
            child: Text(
              'Reschedule',
              style: GoogleFonts.afacad(),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Reminder',
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF44336),
          ),
        ),
        content: Text(
          'Are you sure you want to cancel your reminder "${reminder['title']}" on ${DateFormat('MMM dd, yyyy').format(reminder['date'])}?',
          style: GoogleFonts.afacad(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No, Keep It',
              style: GoogleFonts.afacad(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Here you would typically cancel the reminder in your backend
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reminder cancelled successfully',
                    style: GoogleFonts.afacad(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.afacad(),
            ),
          ),
        ],
      ),
    );
  }
}