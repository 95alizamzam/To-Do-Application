import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:to_do_app/widgets/add_task_Widgets/input_field.dart';

class reminderBuilder extends StatelessWidget {
  const reminderBuilder({Key? key, required this.cubit}) : super(key: key);
  final TODO_cubit cubit;
  @override
  Widget build(BuildContext context) {
    return input_field(
      hint: cubit.reminder.toString() + ' minutes early',
      label: 'Reminder',
      ontap: () {},
      child: DropdownButton(
          underline: Container(),
          borderRadius: BorderRadius.circular(12.0),
          dropdownColor: Colors.blueGrey,
          elevation: 2,
          iconSize: 34,
          icon: const Icon(
            Icons.arrow_drop_down,
          ),
          onChanged: (int? index) {
            cubit.changeReminder(newValue: index!);
          },
          items: cubit.reminderValue.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.toString()),
              onTap: () {},
            );
          }).toList()),
    );
  }
}
