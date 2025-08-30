import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternal_app/widgets/custom_bottom_navigation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.afacad(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8A4F7D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8A4F7D)),
      ),
      backgroundColor: const Color(0xFFF8F6FF),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  const _CustomListTile(
                    title: "Profile",
                    icon: Icons.person_outline,
                  ),
                  _CustomListTile(
                    title: "Dark Mode",
                    icon: Icons.dark_mode_outlined,
                    trailing: CupertinoSwitch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  const _CustomListTile(
                    title: "Language",
                    icon: Icons.language,
                  ),
                  const _CustomListTile(
                    title: "Notifications",
                    icon: Icons.notifications_none,
                  ),
                ],
              ),
              _SingleSection(
                title: "Account",
                children: [
                  const _CustomListTile(
                    title: "Privacy & Security",
                    icon: Icons.security,
                  ),
                  const _CustomListTile(
                    title: "Payment Methods",
                    icon: Icons.payment,
                  ),
                  const _CustomListTile(
                    title: "Subscription",
                    icon: Icons.subscriptions,
                  ),
                ],
              ),
              const _SingleSection(
                title: "Support",
                children: [
                  _CustomListTile(
                    title: "Help Center",
                    icon: Icons.help_outline,
                  ),
                  _CustomListTile(
                    title: "Contact Us",
                    icon: Icons.contact_support_outlined,
                  ),
                  _CustomListTile(
                    title: "About App",
                    icon: Icons.info_outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: 4, // Profile/Settings is the 5th item (index 4)
        onItemTapped: (index) {
          final routes = [
            '/home',
            '/appointment',
            '/reminders',
            '/payment',
            '/profile',
          ];
          // Don't navigate if already on settings page
          if (index != 4) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.afacad(),
      ),
      leading: Icon(icon, color: const Color(0xFF8A4F7D)),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () {},
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