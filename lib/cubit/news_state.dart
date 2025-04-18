part of 'news_cubit.dart';


abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoadingMore extends NewsState {
  final List<Articles> articles;
  NewsLoadingMore(this.articles);
}

class NewsLoaded extends NewsState {
  final List<Articles> articles;
  final bool hasMore;
  NewsLoaded(this.articles, {required this.hasMore});
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}