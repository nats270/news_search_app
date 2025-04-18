import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_base.dart';

class ApiRestClient extends ApiBase {
  @override
  Future<dynamic> get(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error fetching data: ${response.statusCode}');
    }
  }
}
