import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/local_notification/notification.dart';
import 'package:to_do_app/model/model.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';

class taskBuilder extends StatelessWidget {
  const taskBuilder(
      {Key? key, required this.modal, required this.cubit, required this.index})
      : super(key: key);

  final taskModel modal;
  final TODO_cubit cubit;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: Duration(seconds: 1),
      child: SlideAnimation(
        horizontalOffset: 300,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () {
              showmodalButtomSheet(
                context: context,
                cubit: cubit,
                modal: modal,
              );
            },
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: getColor(index: modal.color ?? 0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modal.title.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.schedule),
                        const SizedBox(width: 6),
                        Text(modal.startTime.toString()),
                        const SizedBox(
                          width: 6,
                          child: Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(modal.endTime.toString()),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          modal.note.toString(),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: SizedBox(
                          width: 70,
                          height: 16,
                          child: Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child:
                            Text(modal.isCompleted == 0 ? 'TODO' : 'Completed'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color getColor({required int index}) {
  if (index == 0) {
    return Colors.blue;
  } else {
    if (index == 1) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

showmodalButtomSheet({
  required BuildContext context,
  required TODO_cubit cubit,
  required taskModel modal,
}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: cubit.tm == ThemeMode.dark
          ? Theme.of(context).primaryColor
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (modal.isCompleted == 0)
                bottomSheetItemBuilder(
                    color: Colors.blue,
                    label: 'Task Complete ',
                    context: context,
                    ontap: () {
                      Navigator.of(context).pop();
                      cubit.updateNote(
                        noteID: modal.id!,
                        value: 1,
                        context: context,
                      );
                      TODO_notification().notification.cancel(modal.id!);
                    }),
              bottomSheetItemBuilder(
                  color: Colors.blue,
                  context: context,
                  label: 'delete Task',
                  ontap: () {
                    Navigator.of(context).pop();
                    cubit.deleteNote(noteID: modal.id!, context: context);
                    TODO_notification().notification.cancel(modal.id!);
                  }),
              const Divider(
                color: Colors.red,
                endIndent: 50,
                indent: 50,
              ),
              bottomSheetItemBuilder(
                  color: Colors.red,
                  context: context,
                  label: 'Cancel',
                  ontap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ));
}

Widget bottomSheetItemBuilder({
  required String label,
  required Color color,
  required Function ontap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      ontap();
    },
    child: Container(
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: color,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(10),
      child: Text(
        label,
        style: GoogleFonts.lato(),
      ),
    ),
  );
}
