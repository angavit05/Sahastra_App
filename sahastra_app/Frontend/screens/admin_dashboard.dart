import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Alerts Page
import 'sos_screen.dart'; // SOS Page
import 'crowd_navigation_screen.dart'; // For running video analysis
import 'firestore_alerts_screen.dart'; // Real-time alert screen from Flask

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, Admin!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreAlertsScreen()),
                );
              },
              child: Text("View Alerts"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SosScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("View SOS Requests", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrowdNavigationScreen()),
                );
              },
              child: Text('Run Crowd Navigation'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
