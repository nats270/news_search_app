import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅
import '../models/news_api_response_model.dart';
import '../api/api_base.dart';

class NewsService {
  final ApiBase client;
  static final String _apiKey = dotenv.env['NEWS_API_KEY'] ?? ''; // ✅
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  NewsService(this.client);

  Future<List<Articles>> fetchNews(String query, int page) async {
    final url = '$_baseUrl?q=$query&pageSize=20&page=$page&apiKey=$_apiKey';
    final data = await client.get(url);
    List articles = data['articles'];
    return articles.map((json) => Articles.fromJson(json)).toList();
  }
}
