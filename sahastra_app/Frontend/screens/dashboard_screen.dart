import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List alerts = []; // List to hold alert data

  // 🚨 API URL for Flask backend
final String apiUrl = "https://sahastra.onrender.com/alerts";

  // 📡 Fetch Alerts from Flask API
  Future<void> fetchAlerts() async {
    try {
      print("📡 Fetching alerts...");
      print("🌐 API URL: $apiUrl");

      // HTTP GET request to Flask API
      final response = await http.get(Uri.parse(apiUrl));
      print("📡 Response status: ${response.statusCode}");

      // ✅ Check if API returned success
      if (response.statusCode == 200) {
        print("✅ API Response: ${response.body}");

        if (response.body.isEmpty || response.body == "[]") {
          print("⚠️ No alerts found!");
          setState(() {
            alerts = []; // No alerts received
          });
          return;
        }

        // Decode JSON response and update alert list
        setState(() {
          alerts = json.decode(response.body);
        });
        print("✅ Loaded ${alerts.length} alerts successfully!");
      } else {
        print("❌ Error fetching alerts! Status: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Connection error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlerts(); // Fetch alerts when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CMS2 Dashboard')),
      body: alerts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Loading alerts...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                var alert = alerts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      alert["message"] ?? "No message",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "📍 Location: ${alert["latitude"] ?? 'Unknown'}, ${alert["longitude"] ?? 'Unknown'}\n⏰ Time: ${alert["timestamp"] ?? 'No Time'}",
                    ),
                    trailing: const Icon(Icons.warning, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}
