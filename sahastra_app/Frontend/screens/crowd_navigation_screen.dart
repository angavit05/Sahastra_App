import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrowdNavigationScreen extends StatefulWidget {
  @override
  _CrowdNavigationScreenState createState() => _CrowdNavigationScreenState();
}

class _CrowdNavigationScreenState extends State<CrowdNavigationScreen> {
  List<dynamic> _results = [];
  bool _isLoading = false;
  bool _hasError = false;

  Future<void> runCrowdNavigation() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _results.clear();
    });

    try {
      final response = await http.get(
        Uri.parse("https://sahastra.onrender.com/run_crowd_navigation"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _results = data["results"];
        });
      } else {
        setState(() => _hasError = true);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget buildResultCard(dynamic result) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🧍‍♂️ Person ID: ${result['person_id']}", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("🕒 Frame: ${result['frame']}"),
            Text("📍 Coordinates: (${result['x']}, ${result['y']})"),
            SizedBox(height: 4),
            Text("🚪 Exit ID: ${result['exit_id']}", style: TextStyle(fontWeight: FontWeight.w600)),
            Text("📝 Description: ${result['exit_description']}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crowd Navigation"),
        backgroundColor: Colors.green.shade700,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Text(
                    "⚠️ Error fetching results. Please try again.",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : _results.isEmpty
                  ? Center(
                      child: ElevatedButton.icon(
                        onPressed: runCrowdNavigation,
                        icon: Icon(Icons.play_arrow),
                        label: Text("Run Crowd Navigation"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return buildResultCard(_results[index]);
                      },
                    ),
    );
  }
}
