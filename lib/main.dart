import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/local_notification/notification.dart';
import 'package:to_do_app/modules/home_page.dart';
import 'package:to_do_app/modules/on_boarding_screen.dart';
import 'package:to_do_app/shared/cubit/to_do_states.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:to_do_app/shared/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TODO_notification().init_notification(wantSceduleNotification: true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool storedmode = prefs.getBool('isDark') ?? false;
  bool watchOnBoardingScreen = prefs.getBool('watchOnBoarding') ?? false;
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(
    MyApp(
      mode: storedmode,
      onBoard: watchOnBoardingScreen,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.mode, required this.onBoard})
      : super(key: key);

  final bool mode;
  final bool onBoard;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TODO_cubit()
            ..createDataBase()
            ..initializeAppMode(isDark: mode),
        ),
      ],
      child: BlocConsumer<TODO_cubit, TODO_States>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = TODO_cubit.get(context);
          return MaterialApp(
            title: 'TODO Application',
            theme: TODO_themes.lighttheme,
            darkTheme: TODO_themes.darktheme,
            debugShowCheckedModeBanner: false,
            themeMode: cubit.tm,
            home: onBoard ? homePage() : onBoardingScreen(),
          );
        },
      ),
    );
  }
}
