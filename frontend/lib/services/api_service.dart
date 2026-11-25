import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../data/content.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Talks to the Node.js API, which in turn reads/writes Supabase.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final http.Client _client = http.Client();

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');

  /// Programmes for the "Our Work" page. Falls back to built-in content.
  Future<List<Program>> fetchPrograms() async {
    try {
      final res = await _client.get(_uri('/api/programs')).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return fallbackPrograms;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (body['data'] as List? ?? const []).map((e) => Program.fromJson(e as Map<String, dynamic>)).toList();
      return list.isEmpty ? fallbackPrograms : list;
    } catch (_) {
      return fallbackPrograms;
    }
  }

  /// Returns the success message from the server.
  Future<String> _post(String path, Map<String, dynamic> data) async {
    http.Response res;
    try {
      res = await _client
          .post(_uri(path), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data))
          .timeout(const Duration(seconds: 12));
    } on TimeoutException {
      throw ApiException('The server took too long to respond. Please try again.');
    } catch (_) {
      throw ApiException('Could not reach the server. Please check your connection.');
    }

    Map<String, dynamic>? body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return (body?['message'] as String?) ?? 'Thank you! Your submission has been received.';
    }
    throw ApiException((body?['error'] as String?) ?? 'Something went wrong. Please try again.');
  }

  Future<String> submitContact(Map<String, dynamic> d) => _post('/api/contact', d);
  Future<String> submitVolunteer(Map<String, dynamic> d) => _post('/api/volunteer', d);
  Future<String> submitPledge(Map<String, dynamic> d) => _post('/api/donation-pledge', d);
}
