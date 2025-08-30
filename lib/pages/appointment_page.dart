import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maternal_app/widgets/custom_appbar.dart';
import 'package:maternal_app/widgets/custom_bottom_navigation.dart';

class AppointmentPage extends StatefulWidget {
  final bool initialCreateMother;

  const AppointmentPage({super.key, this.initialCreateMother = false});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Sample appointment data
  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'id': '1',
      'doctor': 'Dr. Jane Smith',
      'specialty': 'Obstetrician & Gynecologist',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '10:00 AM',
      'clinic': 'City Maternal Clinic',
      'status': 'confirmed',
    },
    {
      'id': '2',
      'doctor': 'Dr. Michael Johnson',
      'specialty': 'Ultrasound Specialist',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '2:30 PM',
      'clinic': 'Women\'s Health Center',
      'status': 'confirmed',
    },
  ];

  final List<Map<String, dynamic>> _pastAppointments = [
    {
      'id': '3',
      'doctor': 'Dr. Sarah Williams',
      'specialty': 'Prenatal Care',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'time': '11:15 AM',
      'clinic': 'Family Health Center',
      'status': 'completed',
    },
    {
      'id': '4',
      'doctor': 'Dr. Robert Brown',
      'specialty': 'Nutrition Specialist',
      'date': DateTime.now().subtract(const Duration(days: 20)),
      'time': '9:00 AM',
      'clinic': 'Wellness Clinic',
      'status': 'completed',
    },
  ];

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedDoctor;
  String? _selectedClinic;

  // Available doctors and clinics
  final List<String> _doctors = [
    'Dr. Jane Smith - Obstetrician',
    'Dr. Michael Johnson - Ultrasound',
    'Dr. Sarah Williams - Prenatal Care',
    'Dr. Robert Brown - Nutrition',
  ];

  final List<String> _clinics = [
    'City Maternal Clinic',
    'Women\'s Health Center',
    'Family Health Center',
    'Wellness Clinic',
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

    // If opened from FAB to create mother, show booking form
    if (widget.initialCreateMother) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBookingBottomSheet(context);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
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
                Tab(text: 'Upcoming'),
                Tab(text: 'History'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Appointments Tab
                _buildAppointmentsList(_upcomingAppointments, true),

                // Past Appointments Tab
                _buildAppointmentsList(_pastAppointments, false),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(selectedIndex: 1, onItemTapped: (index) {  },),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookingBottomSheet(context),
        backgroundColor: const Color(0xFF8A4F7D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppointmentsList(List<Map<String, dynamic>> appointments, bool isUpcoming) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today : Icons.history,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming appointments' : 'No appointment history',
              style: GoogleFonts.afacad(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming ? 'Book your first appointment' : 'Your past appointments will appear here',
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
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment, isUpcoming);
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, bool isUpcoming) {
    final date = appointment['date'] as DateTime;
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    final status = appointment['status'] as String;

    Color statusColor;
    String statusText;

    switch (status) {
      case 'confirmed':
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Confirmed';
        break;
      case 'pending':
        statusColor = const Color(0xFFFF9800);
        statusText = 'Pending';
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
              appointment['time'],
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
                    Icons.person,
                    color: Color(0xFF8A4F7D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['doctor'],
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Text(
                        appointment['specialty'],
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
                  Icons.location_on,
                  size: 16,
                  color: Color(0xFF8A4F7D),
                ),
                const SizedBox(width: 4),
                Text(
                  appointment['clinic'],
                  style: GoogleFonts.afacad(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isUpcoming && status == 'confirmed')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showRescheduleDialog(appointment),
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
                      onPressed: () => _showCancelDialog(appointment),
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

  void _showBookingBottomSheet(BuildContext context) {
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
                    'Book New Appointment',
                    style: GoogleFonts.afacad(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8A4F7D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF8A4F7D)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: const Icon(Icons.phone, color: Color(0xFF8A4F7D)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedDoctor,
                    decoration: InputDecoration(
                      labelText: 'Select Doctor',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: const Icon(Icons.medical_services, color: Color(0xFF8A4F7D)),
                    ),
                    items: _doctors.map((String doctor) {
                      return DropdownMenuItem<String>(
                        value: doctor,
                        child: Text(doctor, style: GoogleFonts.afacad()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDoctor = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a doctor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedClinic,
                    decoration: InputDecoration(
                      labelText: 'Select Clinic',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: const Icon(Icons.location_on, color: Color(0xFF8A4F7D)),
                    ),
                    items: _clinics.map((String clinic) {
                      return DropdownMenuItem<String>(
                        value: clinic,
                        child: Text(clinic, style: GoogleFonts.afacad()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedClinic = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a clinic';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Reason for visit',
                      labelStyle: GoogleFonts.afacad(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the reason for your visit';
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
                      onPressed: () => _bookAppointment(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A4F7D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Book Appointment',
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

  void _bookAppointment() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      // Here you would typically save the appointment to your backend

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Appointment booked successfully!',
            style: GoogleFonts.afacad(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Close the bottom sheet
      Navigator.pop(context);

      // Clear form
      _nameController.clear();
      _phoneController.clear();
      _reasonController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
        _selectedDoctor = null;
        _selectedClinic = null;
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

  void _showRescheduleDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reschedule Appointment',
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8A4F7D),
          ),
        ),
        content: Text(
          'Are you sure you want to reschedule your appointment with ${appointment['doctor']} on ${DateFormat('MMM dd, yyyy').format(appointment['date'])}?',
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
              _showBookingBottomSheet(context);
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

  void _showCancelDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Appointment',
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF44336),
          ),
        ),
        content: Text(
          'Are you sure you want to cancel your appointment with ${appointment['doctor']} on ${DateFormat('MMM dd, yyyy').format(appointment['date'])}?',
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
              // Here you would typically cancel the appointment in your backend
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Appointment cancelled successfully',
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