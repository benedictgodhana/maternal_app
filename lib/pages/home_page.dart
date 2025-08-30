import 'package:flutter/material.dart';
import 'package:maternal_app/provider/auth_provider.dart';
import 'package:maternal_app/widgets/custom_appbar.dart';
import 'package:maternal_app/widgets/custom_bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      appBar: const CustomAppBar(),
      body: const DashboardPage(),
      bottomNavigationBar: CustomBottomNavigation(selectedIndex: 0, onItemTapped: (index) {  },),
      floatingActionButton: auth.user != null && auth.user!.role != 'mother' 
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to AppointmentPage with create mother flag
                Navigator.pushNamed(
                  context,
                  '/appointment',
                  arguments: {'initialCreateMother': true},
                );
              },
              backgroundColor: const Color(0xFF8A4F7D),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            )
          : null,
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          _buildPregnancyProgress(context),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildUpcomingAppointments(context),
          const SizedBox(height: 24),
          _buildHealthTips(),
          const SizedBox(height: 24),
          _buildWeeklyProgress(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8A4F7D), Color(0xFFC86B98)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A4F7D).withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${auth.user?.name?.split(" ")[0] ?? 'there'}! 👋',
                      style: GoogleFonts.afacad(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How are you feeling today?',
                      style: GoogleFonts.afacad(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Week 24 • 2nd Trimester',
                        style: GoogleFonts.afacad(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 40),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPregnancyProgress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFF8A4F7D), size: 24),
              const SizedBox(width: 10),
              Text(
                'Pregnancy Progress',
                style: GoogleFonts.afacad(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF555555),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EBF4),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                height: 12,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A4F7D), Color(0xFFC86B98)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week 24 of 40',
                style: GoogleFonts.afacad(
                  fontSize: 14,
                  color: const Color(0xFF777777),
                ),
              ),
              Text(
                '60% Complete',
                style: GoogleFonts.afacad(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8A4F7D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressIndicator('1st', '12 weeks', 0.3),
              _buildProgressIndicator('2nd', '24 weeks', 0.6),
              _buildProgressIndicator('3rd', '40 weeks', 0.1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(String trimester, String weeks, double progress) {
    return Column(
      children: [
        Text(
          trimester,
          style: GoogleFonts.afacad(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          weeks,
          style: GoogleFonts.afacad(
            fontSize: 12,
            color: const Color(0xFF777777),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF8A4F7D),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                backgroundColor: const Color(0xFFF0EBF4),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8A4F7D)),
              ),
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.afacad(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8A4F7D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.afacad(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
          children: [
            _buildActionCard(
              icon: Icons.calendar_today,
              title: 'Appointment',
              color: const Color(0xFF8A4F7D),
              onTap: () {
                Navigator.pushNamed(context, '/appointment');
              },
            ),
            _buildActionCard(
              icon: Icons.medical_services,
              title: 'Medication',
              color: const Color(0xFF5B8C85),
            ),
            _buildActionCard(
              icon: Icons.favorite,
              title: 'Health Tips',
              color: const Color(0xFFE76F51),
            ),
            _buildActionCard(
              icon: Icons.emergency,
              title: 'Emergency',
              color: const Color(0xFFE63946),
            ),
            _buildActionCard(
              icon: Icons.description,
              title: 'Reports',
              color: const Color(0xFF3A86FF),
            ),
            _buildActionCard(
              icon: Icons.menu_book,
              title: 'Education',
              color: const Color(0xFF9B5DE5),
            ),
            _buildActionCard(
              icon: Icons.people,
              title: 'Community',
              color: const Color(0xFF00BBF9),
            ),
            _buildActionCard(
              icon: Icons.settings,
              title: 'Settings',
              color: const Color(0xFF50514F),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.afacad(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF8A4F7D), size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Upcoming Appointments',
                    style: GoogleFonts.afacad(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/appointment');
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.afacad(
                    color: const Color(0xFF8A4F7D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAppointmentItem(
            date: 'Tomorrow',
            time: '10:00 AM',
            doctor: 'Dr. Jane Smith',
            type: 'Prenatal Checkup',
            color: const Color(0x208A4F7D),
          ),
          const SizedBox(height: 12),
          _buildAppointmentItem(
            date: 'Oct 15, 2023',
            time: '2:30 PM',
            doctor: 'Dr. Michael Johnson',
            type: 'Ultrasound Scan',
            color: const Color(0x20C86B98),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem({
    required String date,
    required String time,
    required String doctor,
    required String type,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Color(0xFF8A4F7D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$date • $time',
                  style: GoogleFonts.afacad(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor,
                  style: GoogleFonts.afacad(
                    color: const Color(0xFF777777),
                  ),
                ),
                Text(
                  type,
                  style: GoogleFonts.afacad(
                    color: const Color(0xFF8A4F7D),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Color(0xFF8A4F7D), size: 16),
        ],
      ),
    );
  }

  Widget _buildHealthTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety, color: Color(0xFF8A4F7D), size: 24),
              const SizedBox(width: 10),
              Text(
                'Health Tips',
                style: GoogleFonts.afacad(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF555555),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            icon: Icons.favorite,
            title: 'Nutrition during pregnancy',
            description: 'Foods to eat and avoid for a healthy pregnancy',
            color: const Color(0x205B8C85),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            icon: Icons.directions_run,
            title: 'Exercise guidelines',
            description: 'Safe exercises for each trimester',
            color: const Color(0x20E76F51),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            icon: Icons.emoji_emotions,
            title: 'Mental wellness',
            description: 'Managing stress and anxiety during pregnancy',
            color: const Color(0x203A86FF),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF8A4F7D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.afacad(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.afacad(
                    fontSize: 12,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFF8A4F7D), size: 24),
              const SizedBox(width: 10),
              Text(
                'Weekly Progress',
                style: GoogleFonts.afacad(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF555555),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeeklyItem('Steps', '7,842', Icons.directions_walk, const Color(0xFF5B8C85)),
              _buildWeeklyItem('Water', '8 glasses', Icons.local_drink, const Color(0xFF3A86FF)),
              _buildWeeklyItem('Sleep', '7.5 hrs', Icons.nightlight, const Color(0xFF9B5DE5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.afacad(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF555555),
          ),
        ),
        Text(
          title,
          style: GoogleFonts.afacad(
            fontSize: 12,
            color: const Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}