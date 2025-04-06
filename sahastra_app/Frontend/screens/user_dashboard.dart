import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool isSending = false;
  String _geminiResponse = '';
  TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;

  // ✅ Function to send SOS request
  Future<void> sendSOSRequest() async {
    setState(() {
      isSending = true;
    });

    const String apiUrl = "https://sahastra.onrender.com/send_sos";
    Map<String, dynamic> requestBody = {
      "latitude": 28.7041,
      "longitude": 77.1025
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🚨 SOS request sent successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to send SOS! Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔥 Error: $e")),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> _askGemini() async {
    final String question = _questionController.text.trim();
    if (question.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://sahastra.onrender.com/gemini_query?query=$question'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _geminiResponse = "Response: ${data['ai_response']}";
          _isLoading = false;
        });
      } else {
        setState(() {
          _geminiResponse = "Error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _geminiResponse = "Exception: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🚨 SOS Button
            ElevatedButton(
              onPressed: isSending ? null : sendSOSRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: isSending
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("🚨 Send SOS", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 30),

            // 🤖 Ask Gemini Section
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: "Ask Anything (Crowd-related)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _askGemini,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("🤖 Ask Gemini"),
            ),
            SizedBox(height: 20),
            Text(
              _geminiResponse.isNotEmpty ? _geminiResponse : "Ask a question to get a response.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
