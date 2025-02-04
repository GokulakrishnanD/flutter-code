import 'package:flutter/material.dart';
import 'package:thiran_tech_task/Views/github_repo_screen.dart';
import 'package:thiran_tech_task/Views/ticket_screen.dart';
import 'package:thiran_tech_task/Views/transactionScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            buildNavigationCard(
              context,
              title: "Auto Mail",
              icon: Icons.email_outlined,
              color: Colors.black,
              screen: const TransactionScreen(),
            ),
            buildNavigationCard(
              context,
              title: "GitHub Repos",
              icon: Icons.code,
              color: Colors.black,
              screen: const GitHubRepoScreen(),
            ),
            buildNavigationCard(
              context,
              title: "Tickets",
              icon: Icons.confirmation_number_outlined,
              color: Colors.black,
              screen: const TicketScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        color: color.withOpacity(0.1), // Light transparent background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
