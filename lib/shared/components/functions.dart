import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void goto({
  required Widget goalScreen,
  required BuildContext context,
  required PageTransitionType moveType,
}) {
  Navigator.of(context).pushReplacement(PageTransition(
    child: goalScreen,
    type: moveType,
    duration: const Duration(milliseconds: 500),
  ));
}

void showToast({
  required BuildContext context,
  TODO_cubit? cubit,
  required String msg,
  required Color backgroundColor,
}) {
  Toast.show(
    msg,
    context,
    backgroundColor: backgroundColor,
    duration: 1,
    textColor: cubit == null
        ? Colors.white
        : cubit.tm == ThemeMode.dark
            ? Colors.white
            : Colors.black,
  );
}

Future<String> getNotificationPicture({
  required String url,
  required String filename,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$filename';
  final response = await http.get(Uri.parse(url));
  final file = File(filePath);

  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}
