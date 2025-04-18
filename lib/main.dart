import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api/api_rest_client.dart';
import 'services/news_services.dart';
import 'cubit/news_cubit.dart';
import 'pages/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final newsService = NewsService(ApiRestClient());
  runApp(MyApp(newsService: newsService));
}

class MyApp extends StatelessWidget {
  final NewsService newsService;

  const MyApp({super.key, required this.newsService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
      child: BlocProvider(
        create: (_) => NewsCubit(newsService),
        child: MaterialApp(
          title: 'News Search App',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            textTheme: GoogleFonts.robotoCondensedTextTheme(Theme.of(context).textTheme),
          ),
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}