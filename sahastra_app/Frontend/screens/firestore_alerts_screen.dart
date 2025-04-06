import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreAlertsScreen extends StatefulWidget {
  const FirestoreAlertsScreen({super.key});

  @override
  _FirestoreAlertsScreenState createState() => _FirestoreAlertsScreenState();
}

class _FirestoreAlertsScreenState extends State<FirestoreAlertsScreen> {
  List alerts = [];

  // 🔗 Flask API endpoint
  final String apiUrl = "https://sahastra.onrender.com/alerts"; // change IP if needed

  Future<void> fetchAlerts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          alerts = json.decode(response.body);
        });
      } else {
        print("❌ Error fetching alerts: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Exception while fetching alerts: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Real-Time Alerts"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchAlerts,
          ),
        ],
      ),
      body: alerts.isEmpty
          ? const Center(child: Text("No alerts found."))
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final message = alert['message'] ?? 'No message';
                final lat = alert['latitude'] ?? 'Unknown';
                final long = alert['longitude'] ?? 'Unknown';
                final timestamp = alert['timestamp'] ?? 'No time';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(message, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("📍 $lat, $long\n⏰ $timestamp"),
                    trailing: const Icon(Icons.warning, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}
