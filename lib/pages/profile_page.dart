import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/custom_bottom_navigation.dart';
import 'package:maternal_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8A4F7D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8A4F7D)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF8A4F7D)),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F6FF),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // User Profile Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF8A4F7D).withOpacity(0.1),
                          image: user?.profilePicture != null
                              ? DecorationImage(
                                  image: NetworkImage(user!.profilePicture!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: user?.profilePicture == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: const Color(0xFF8A4F7D).withOpacity(0.5),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // User Name
                      Text(
                        user?.name ?? 'Guest User',
                        style: GoogleFonts.afacad(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // User Email
                      Text(
                        user?.email ?? 'No email provided',
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Personal Information Section
                _SingleSection(
                  title: "Personal Information",
                  children: [
                    _InfoTile(
                      title: "Full Name",
                      value: user?.name ?? 'Not provided',
                      icon: Icons.person_outline,
                    ),
                    _InfoTile(
                      title: "Email Address",
                      value: user?.email ?? 'Not provided',
                      icon: Icons.email_outlined,
                    ),
                    if (user?.phone != null)
                      _InfoTile(
                        title: "Phone Number",
                        value: user!.phone!,
                        icon: Icons.phone_outlined,
                      ),
                   
                  ],
                ),
                // Account Information Section
                
                // Statistics Section
                _SingleSection(
                  title: "Statistics",
                  children: [
                    _StatTile(
                      title: "Appointments",
                      value: user?.appointments?.length.toString() ?? '0',
                      icon: Icons.calendar_today_outlined,
                    ),
                    _StatTile(
                      title: "Reminders",
                      value: user?.reminders?.length.toString() ?? '0',
                      icon: Icons.notifications_active_outlined,
                    ),
                    _StatTile(
                      title: "Health Tips",
                      value: user?.healthTips?.length.toString() ?? '0',
                      icon: Icons.health_and_safety_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: 4, // Profile is the 5th item (index 4)
        onItemTapped: (index) {
          final routes = [
            '/home',
            '/appointment',
            '/reminders',
            '/payment',
            '/profile',
          ];
          // Don't navigate if already on profile page
          if (index != 4) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8A4F7D)),
      title: Text(
        title,
        style: GoogleFonts.afacad(
          fontSize: 14,
          color: const Color(0xFF777777),
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.afacad(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF555555),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8A4F7D)),
      title: Text(
        title,
        style: GoogleFonts.afacad(),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF8A4F7D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          value,
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8A4F7D),
          ),
        ),
      ),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.afacad(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8A4F7D),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}