import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/news_api_response_model.dart';
import '../services/news_services.dart';
part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsService _service;
  int _page = 1;
  String _query = '';
  bool _hasMore = true;
  final Map<String, List<Articles>> _cache = {};

  NewsCubit(this._service) : super(NewsInitial());

  void searchNews(String query) async {
    _query = query;
    _page = 1;
    _hasMore = true;

    if (_cache.containsKey(query)) {
      emit(NewsLoaded(_cache[query]!, hasMore: true));
      return;
    }

    emit(NewsLoading());
    try {
      final articles = await _service.fetchNews(query, _page);
      _cache[query] = articles;
      if (_cache.length > 5) _cache.remove(_cache.keys.first);
      emit(NewsLoaded(articles, hasMore: articles.length == 20));
    } catch (e) {
      emit(NewsError('Failed to fetch news'));
    }
  }
  void loadMore() async {
    if (!_hasMore || state is NewsLoadingMore || _query.isEmpty) return;

    if (state is NewsLoaded) {
      final currentArticles = (state as NewsLoaded).articles;
      emit(NewsLoadingMore(currentArticles));

      _page++;
      try {
        final newArticles = await _service.fetchNews(_query, _page);
        _hasMore = newArticles.length == 20;
        final updatedArticles = [...currentArticles, ...newArticles];
        _cache[_query] = updatedArticles;
        emit(NewsLoaded(updatedArticles, hasMore: _hasMore));
      } catch (e) {
        emit(NewsLoaded(currentArticles, hasMore: true));
      }
    }
  }

}


