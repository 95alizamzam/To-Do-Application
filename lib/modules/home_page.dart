import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'package:to_do_app/local_notification/notification.dart';
import 'package:to_do_app/modules/about_app.dart';
import 'package:to_do_app/modules/notifiction_screen.dart';
import 'package:to_do_app/modules/on_boarding_screen.dart';
import 'package:to_do_app/shared/components/functions.dart';

import 'package:to_do_app/shared/cubit/to_do_states.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';
import 'package:to_do_app/widgets/home_page_widgets/date_line_builder.dart';
import 'package:to_do_app/widgets/home_page_widgets/no_task_yet.dart';
import 'package:to_do_app/widgets/home_page_widgets/noteBuilder.dart';
import 'package:to_do_app/widgets/home_page_widgets/top_section.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    super.initState();

    ///it works only when i tap on triggered notification
    TODO_notification.notificationListener.stream.listen(
      (tappedId) {
        TODO_notification()
            .notification
            .pendingNotificationRequests()
            .then((value) {
          value.forEach((element) {
            if (element.id == int.parse(tappedId)) {
              goto(
                goalScreen: notifictionScreen(id: int.parse(tappedId!)),
                context: context,
                moveType: PageTransitionType.rightToLeft,
              );
              TODO_notification().notification.cancel(int.parse(tappedId));
            }
          });
        });
      },
    );
  }

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
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text(
                    'TODO App',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('images/person.jpg'),
                    ),
                  ),
                  actions: [
                    DropdownButton(
                      underline: Container(),
                      borderRadius: BorderRadius.circular(12.0),
                      elevation: 2,
                      iconSize: 30,
                      dropdownColor: Colors.blue.shade300,
                      icon: const Icon(Icons.more_vert),
                      onChanged: (val) {
                        if (val == 'change Mode') {
                          cubit.changeAppTheme();
                        } else if (val == 'clean Notes') {
                          cubit.cleanDB();
                        } else if (val == 'Contact us') {
                          goto(
                            goalScreen: contact_us(),
                            context: context,
                            moveType: PageTransitionType.fade,
                          );
                        } else if (val == 'About TODO app') {
                          goto(
                            goalScreen: onBoardingScreen(),
                            context: context,
                            moveType: PageTransitionType.fade,
                          );
                        } else if (val == 'close') {
                          exit(0);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'change Mode',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              cubit.tm == ThemeMode.dark
                                  ? Icon(
                                      Icons.wb_sunny,
                                      color: Colors.yellow,
                                    )
                                  : Icon(
                                      Icons.dark_mode_outlined,
                                      color: Colors.black,
                                    ),
                              const SizedBox(width: 10),
                              Text(cubit.tm == ThemeMode.dark
                                  ? 'Light Mode'
                                  : 'Dark Mode'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'clean Notes',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.cleaning_services_outlined),
                              SizedBox(width: 10),
                              Text('clean Notes'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'About TODO app',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.info),
                              SizedBox(width: 10),
                              Text('About TODO app'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Contact us',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              FaIcon(FontAwesomeIcons.addressBook),
                              SizedBox(width: 10),
                              Text('Contact us'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'close',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text('close'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
              body: Column(
                children: [
                  top_home_section(),
                  date_line_builder(cubit: cubit),
                  cubit.obtained_dataObject == null
                      ? Expanded(
                          child: Image(image: AssetImage('images/loading.gif')),
                        )
                      : cubit.filteredData.length == 0
                          ? noTasksYet()
                          : Expanded(
                              child: Container(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) {
                                  var hour = cubit
                                      .filteredData[index].startTime!
                                      .split(':')[0];
                                  var minutes = cubit
                                      .filteredData[index].startTime!
                                      .split(':')[1];

                                  if (cubit.allowScedual &&
                                      (cubit.filteredData[index].isCompleted ==
                                          0)) {
                                    ///add notification for a note (which is inserted in database)
                                    /// ///من اجل كل ملاحظة يجب جدولة اشعار خاص بها
                                    TODO_notification().scheduleNotifications(
                                      hour: int.parse(hour),
                                      minutes: int.parse(minutes),
                                      note: cubit.filteredData[index],
                                    );
                                  }

                                  return taskBuilder(
                                    index: index,
                                    modal: cubit.filteredData[index],
                                    cubit: cubit,
                                  );
                                },
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 6),
                                itemCount: cubit.filteredData.length,
                              ),
                            ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
