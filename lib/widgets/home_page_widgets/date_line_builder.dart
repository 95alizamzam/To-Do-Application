import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';

class date_line_builder extends StatelessWidget {
  const date_line_builder({Key? key, required this.cubit}) : super(key: key);
  final TODO_cubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: DatePicker(
          DateTime.now(),
          initialSelectedDate: DateFormat("yMMMMd").parse(cubit.initialDate),
          selectionColor: Colors.blue,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            cubit.changeNoteDate(newDate: DateFormat.yMMMMd().format(date));
            cubit.filtereddatabyTime(date: date);
          },
          width: MediaQuery.of(context).size.width / 6,
          height: 80,
          monthTextStyle: GoogleFonts.lato(
            color: cubit.tm == ThemeMode.dark ? Colors.white : Colors.black,
            fontSize: 12,
          ),
          dateTextStyle: GoogleFonts.lato(
            color: cubit.tm == ThemeMode.dark ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          dayTextStyle: GoogleFonts.lato(
            color: cubit.tm == ThemeMode.dark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
