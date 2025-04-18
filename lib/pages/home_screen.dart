import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/news_cubit.dart';
import '../pages/widgets/news_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }


  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      context.read<NewsCubit>().loadMore();
    }
  }

  void _search() {
    FocusScope.of(context).unfocus();
    context.read<NewsCubit>().searchNews(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      hintText: 'Search for News...',suffixIcon: SizedBox(height: 20.h,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(onPressed: () { _search(); },
                          child: Text('Search')),
                        ),
                      )
                    ),
                    onSubmitted: (_) {_search();},
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NewsError) {
                  return Center(child: Text(state.message));
                } else if (state is NewsLoaded || state is NewsLoadingMore) {
                  final articles = state is NewsLoaded ? state.articles : (state as NewsLoadingMore).articles;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: articles.length + (state is NewsLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < articles.length) {
                        return NewsTile(article: articles[index]);
                      } else {
                        return  Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  );
                }
                return const Center(child: Text('Search for news above.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}