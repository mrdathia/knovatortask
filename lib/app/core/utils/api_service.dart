import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

Map<String, dynamic> genErrorResponse(String error, int code) => {"success": false, "error": error, "status": code};


class ApiModule {
  http.Client get client => http.Client();

  ApiService apiService(http.Client client) => ApiService(client);
}


class ApiService {
  final http.Client _client;

  ApiService(this._client);

  Future<Map<String, dynamic>> _performRequest(
      Future<http.Response> Function() request, {
        Duration timeout = const Duration(seconds: 10),
      }) async {
    try {
      final response = await request().timeout(timeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {"success": true, "response": jsonDecode(response.body), "status": response.statusCode};
      }
      return genErrorResponse('Unexpected Error: ${response.body} ${response.reasonPhrase}', response.statusCode);
    } on TimeoutException {
      return genErrorResponse('Request timed out. Please try again later.', 500);
    } on http.ClientException {
      return genErrorResponse('Connection error. Please check your internet.', 500);
    } catch (e) {
      return genErrorResponse('An error occurred: ${e.toString()}', 500);
    }
  }

  Future<Map<String, dynamic>> postRequest(String url, Map<String, String> headers, Map<String, dynamic> body) async {
    return await _performRequest(() => _client.post(Uri.parse(url), headers: headers, body: jsonEncode(body)));
  }

  Future<Map<String, dynamic>> getRequest(String url, Map<String, String> headers) async {
    return await _performRequest(() => _client.get(Uri.parse(url), headers: headers));
  }

  Future<Map<String, dynamic>> retryPostRequest(
      String url,
      Map<String, String> headers,
      Map<String, dynamic> body, {
        int retries = 2,
      }) async {
    final retryClient = RetryClient(_client, retries: retries);
    try {
      return await _performRequest(() => retryClient.post(Uri.parse(url), headers: headers, body: jsonEncode(body)));
    } finally {
      retryClient.close();
    }
  }

  Future<Map<String, dynamic>> retryGetRequest(String url, Map<String, String> headers, {int retries = 2}) async {
    final retryClient = RetryClient(_client, retries: retries);
    try {
      return await _performRequest(() => retryClient.get(Uri.parse(url), headers: headers));
    } finally {
      retryClient.close();
    }
  }
}
