import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:to_do_app/modules/home_page.dart';
import 'package:to_do_app/shared/components/functions.dart';

import 'package:to_do_app/shared/cubit/to_do_states.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:to_do_app/widgets/add_task_Widgets/color_section.dart';
import 'package:to_do_app/widgets/add_task_Widgets/input_field.dart';
import 'package:to_do_app/widgets/add_task_Widgets/reminder_section.dart';
import 'package:to_do_app/widgets/add_task_Widgets/repeat_section.dart';
import 'package:to_do_app/widgets/add_task_Widgets/time_row.dart';

class addTaskScreen extends StatelessWidget {
  const addTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TODO_cubit, TODO_States>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = TODO_cubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              leading: appBarLeading(context: context),
              actions: [appbarAction()],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ///title
                    input_field(
                      label: 'Title',
                      hint: 'Enter Title here.',
                      onchange: (String newValue) {
                        cubit.changeNoteInfo(index: 1, value: newValue);
                      },
                    ),

                    ///note
                    input_field(
                      label: 'Note',
                      hint: 'Enter Note here.',
                      onchange: (String newValue) {
                        cubit.changeNoteInfo(index: 2, value: newValue);
                      },
                    ),

                    ///date
                    input_field(
                      label: 'Date',
                      hint: cubit.initialDate,
                      child: Icon(Icons.calendar_today),
                      ontap: () {
                        cubit.selectDate(context: context);
                      },
                    ),

                    ///start end time
                    time_row(cubit: cubit),

                    ///reminder
                    reminderBuilder(cubit: cubit),

                    ///repeat
                    repeatBuilder(cubit: cubit),

                    ///last widget
                    color_section(
                      cubit: cubit,
                      title: cubit.noteTitle,
                      note: cubit.notebody,
                      startTime: DateFormat.jm().format(cubit.starttime),
                      endTime: DateFormat.jm().format(cubit.endtime),
                      color: cubit.selectedColor,
                      reminder: cubit.reminder,
                      repeat: cubit.repeat,
                      noteDate: cubit.initialDate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget appBarLeading({
  required BuildContext context,
}) {
  return IconButton(
    icon: Icon(
      Icons.arrow_back_ios_new,
      color: Colors.grey.shade500,
      size: 16,
    ),
    onPressed: () {
      goto(
        goalScreen: homePage(),
        context: context,
        moveType: PageTransitionType.fade,
      );
    },
  );
}

Widget appbarAction() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: CircleAvatar(
      radius: 25,
      backgroundImage: AssetImage('images/person.jpg'),
    ),
  );
}
