import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryService {
  static CountryService? _instance;
  CountryService._();
  factory CountryService() => _instance ??= CountryService._();

  Future<List<Map<String, dynamic>>> getCountries() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((country) => {
        'name': country['name']['common'],
        'code': country['cca2'],
      }).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}