import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:maternal_app/provider/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? showBackButton;

  const CustomAppBar({super.key, this.showBackButton});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const SizedBox.shrink(),
      centerTitle: true,
      leading: Container(), // Empty container instead of back button
      actions: [
        IconButton(
          icon: const Badge(
            backgroundColor: Color(0xFFFF6B6B),
            smallSize: 8,
            child: Icon(Icons.notifications_none, color: Color(0xFF8A4F7D)),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: GoogleFonts.afacad(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8A4F7D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF8A4F7D),
                              ),
                              title: Text(
                                'Appointment Reminder',
                                style: GoogleFonts.afacad(),
                              ),
                              subtitle: Text(
                                'Your next appointment is in 2 days',
                                style: GoogleFonts.afacad(),
                              ),
                              trailing: Text(
                                '10:30 AM',
                                style: GoogleFonts.afacad(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.health_and_safety,
                                color: Color(0xFF8A4F7D),
                              ),
                              title: Text(
                                'Health Tip',
                                style: GoogleFonts.afacad(),
                              ),
                              subtitle: Text(
                                'New health tips available',
                                style: GoogleFonts.afacad(),
                              ),
                              trailing: Text(
                                'Yesterday',
                                style: GoogleFonts.afacad(color: Colors.grey),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.payment,
                                color: Color(0xFF8A4F7D),
                              ),
                              title: Text(
                                'Payment Due',
                                style: GoogleFonts.afacad(),
                              ),
                              subtitle: Text(
                                'Your payment is due in 5 days',
                                style: GoogleFonts.afacad(),
                              ),
                              trailing: Text(
                                '2 days ago',
                                style: GoogleFonts.afacad(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Color(0xFF8A4F7D)),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.person, color: Color(0xFF8A4F7D)),
          constraints: const BoxConstraints(minWidth: 280),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          onSelected: (value) {
            if (value == 'logout') {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          itemBuilder: (BuildContext context) {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            return [
              PopupMenuItem<String>(
                enabled: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.user?.name ?? 'Guest User',
                        style: GoogleFonts.afacad(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        auth.user?.email ?? 'No email provided',
                        style: GoogleFonts.afacad(
                          fontSize: 14,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (auth.user?.idType != null &&
                          auth.user?.idNumber != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF8A4F7D,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.badge_outlined,
                                  size: 18,
                                  color: const Color(0xFF8A4F7D),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      auth.user!.idType!.toUpperCase(),
                                      style: GoogleFonts.afacad(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF8A4F7D),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      auth.user!.idNumber!,
                                      style: GoogleFonts.afacad(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                height: 48,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE6E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Color(0xFFE63946),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: GoogleFonts.afacad(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE63946),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}