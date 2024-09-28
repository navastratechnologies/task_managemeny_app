import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/viewmodels/task_viewmodel.dart';
import 'package:task_management_app/views/helpers/color_constants.dart';
import 'package:task_management_app/views/task_add_screen.dart';

import 'views/task_list_screen.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel()..fetchTasks(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Management App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const TaskListScreen(),
          '/taskAdd': (context) => const TaskAddScreen(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: blackColor,
          appBarTheme: AppBarTheme(
            backgroundColor: blackColor,
          ),
        ),
      ),
    );
  }
}
