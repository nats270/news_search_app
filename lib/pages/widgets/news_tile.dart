import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/news_api_response_model.dart';

class NewsTile extends StatelessWidget {
  final Articles article;

  const NewsTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: Colors.grey)
        ),
        child: ListTile(
          title: Text(article.title ?? "",style: TextStyle(fontWeight: FontWeight.w600),),
          subtitle: Text(
              '${article.source?.name ?? ""} , ${DateFormat('dd MMM yyyy').format(DateTime.parse("${article.publishedAt}"))}'),
          trailing: article.urlToImage?.isNotEmpty ?? true
              ? Image.network(
                  article.urlToImage ?? "",
                  width: 100.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _placeholderImage();
                  },
                )
              : _placeholderImage(),
          onTap: () => _openDetails(context),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(article.source?.name ?? ""),leading: SizedBox(),),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.urlToImage?.isNotEmpty ?? true)
                  Image.network(article.urlToImage ?? ""),
                 SizedBox(height: 12.h),
                Text(article.title ?? "",
                    style:  TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)),
                 SizedBox(height: 8.h),
                Text(article.description ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 100.w,
      height: 80.h,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
