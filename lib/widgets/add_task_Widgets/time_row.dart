import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:to_do_app/widgets/add_task_Widgets/input_field.dart';

class time_row extends StatelessWidget {
  const time_row({Key? key, required this.cubit}) : super(key: key);

  final TODO_cubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: input_field(
            label: 'Start time',
            hint: DateFormat.jm().format(cubit.starttime),
            child: const Icon(Icons.schedule),
            ontap: () {
              cubit.selectTime(context: context, index: 1);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: input_field(
            label: 'End Time',
            hint: DateFormat.jm().format(cubit.endtime),
            child: const Icon(Icons.schedule),
            ontap: () {
              cubit.selectTime(context: context, index: 2);
            },
          ),
        ),
      ],
    );
  }
}
