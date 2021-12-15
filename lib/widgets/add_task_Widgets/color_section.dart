import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/components/functions.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:to_do_app/widgets/add_task_Widgets/colored_circles.dart';
import 'package:toast/toast.dart';

class color_section extends StatelessWidget {
  const color_section({
    Key? key,
    required this.cubit,
    required this.title,
    required this.note,
    required this.color,
    required this.endTime,
    required this.startTime,
    required this.reminder,
    required this.repeat,
    required this.noteDate,
  }) : super(key: key);

  final TODO_cubit cubit;
  final String title;
  final String noteDate;
  final String note;
  final String startTime;
  final String endTime;
  final int reminder;
  final int color;
  final String repeat;

  @override
  Widget build(BuildContext context) {
    SnackBar showsnack({
      required String text,
    }) {
      return SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        behavior: SnackBarBehavior.floating,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade400,
        duration: Duration(seconds: 2),
        padding: const EdgeInsets.all(4),
        action: SnackBarAction(
          label: 'Warnning',
          onPressed: () {},
          textColor: Colors.red,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Colors'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    coloredCircle(
                      ontap: () {
                        cubit.changeNoteColor(newindex: 0);
                      },
                      color: Colors.blue,
                      child: cubit.selectedColor == 0
                          ? const Icon(Icons.done)
                          : Container(),
                    ),
                    coloredCircle(
                      ontap: () {
                        cubit.changeNoteColor(newindex: 1);
                      },
                      color: Colors.orange,
                      child: cubit.selectedColor == 1
                          ? const Icon(Icons.done)
                          : Container(),
                    ),
                    coloredCircle(
                      ontap: () {
                        cubit.changeNoteColor(newindex: 2);
                      },
                      color: Colors.red,
                      child: cubit.selectedColor == 2
                          ? const Icon(Icons.done)
                          : Container(),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ///1st step : check empty fields
                if (title == 'Enter title here.' ||
                    note == 'Enter note here.' ||
                    title.isEmpty ||
                    note.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(showsnack(text: 'Empty Fields'));
                  return;
                }

                ///dateFormatted:note يمثل الزمن والتاريخ الخاصين بال
                DateTime dateFormatted =
                    DateFormat.yMMMMd().parse(noteDate).add(Duration(
                          hours: DateFormat.jm().parse(startTime).hour,
                          minutes: DateFormat.jm().parse(startTime).minute,
                          seconds: DateFormat.jm().parse(startTime).second,
                          milliseconds:
                              DateFormat.jm().parse(startTime).microsecond,
                        ));

                if (dateFormatted.isAfter(DateTime.now()) && repeat == 'None') {
                  showToast(
                    context: context,
                    msg: 'Insert Successfully',
                    cubit: null,
                    backgroundColor: Colors.green,
                  );
                  cubit.insertIntoDataBase(
                    context: context,
                    title: title,
                    note: note,
                    startTime: startTime,
                    endTime: endTime,
                    color: color,
                    iscompleted: 0,
                    reminder: reminder,
                    repeat: repeat,
                    noteDate: noteDate,
                  );
                } else if (dateFormatted.isBefore(DateTime.now()) &&
                    repeat == 'None') {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(showsnack(text: 'Error is selected time'));
                  return;
                }

                if (repeat != 'None') {
                  showToast(
                    context: context,
                    msg: 'Insert Successfully',
                    cubit: null,
                    backgroundColor: Colors.green,
                  );
                  cubit.insertIntoDataBase(
                    context: context,
                    title: title,
                    note: note,
                    startTime: startTime,
                    endTime: endTime,
                    color: color,
                    iscompleted: 0,
                    reminder: reminder,
                    repeat: repeat,
                    noteDate: noteDate,
                  );
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Create task',
                  style: TextStyle(
                    color: cubit.tm == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
