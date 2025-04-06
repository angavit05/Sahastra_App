import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SosScreen extends StatefulWidget {
  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  List<dynamic> sosRequests = [];

  @override
  void initState() {
    super.initState();
    fetchSosRequests(); // Fetch SOS requests from Flask
  }

  Future<void> fetchSosRequests() async {
    try {
        final response = await http.get(
          Uri.parse('https://sahastra.onrender.com/admin/sos_requests'),
        );

      if (response.statusCode == 200) {
        setState(() {
          sosRequests = json.decode(response.body);
        });
      } else {
        print("Failed to load SOS requests");
      }
    } catch (e) {
      print("Error fetching SOS requests: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SOS Requests")),
      body: sosRequests.isEmpty
          ? Center(child: Text("No SOS requests"))
          : ListView.builder(
              itemCount: sosRequests.length,
              itemBuilder: (context, index) {
                var request = sosRequests[index];
                var location = request['location'] ?? {};
                var latitude = location['latitude'] ?? 'N/A';
                var longitude = location['longitude'] ?? 'N/A';

                return ListTile(
                  title: Text("Location: $latitude, $longitude"),
                  subtitle: Text("Time: ${request['timestamp'] ?? 'N/A'}"),
                  trailing: Icon(Icons.warning, color: Colors.red),
                );
              },
            ),
    );
  }
}
