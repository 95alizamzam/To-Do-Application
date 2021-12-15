import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:to_do_app/local_notification/notification.dart';
import 'package:to_do_app/modules/home_page.dart';
import 'package:to_do_app/shared/components/functions.dart';
import 'package:to_do_app/shared/cubit/to_do_states.dart';
import 'package:to_do_app/shared/cubit/todo_cubit.dart';

class notifictionScreen extends StatelessWidget {
  const notifictionScreen({Key? key, required this.id}) : super(key: key);

  final int id;
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 14,
          color: Colors.grey.shade600,
        );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        bottom: true,
        child: BlocConsumer<TODO_cubit, TODO_States>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = TODO_cubit.get(context);

            final model =
                cubit.filteredData.firstWhere((element) => element.id == id);
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).backgroundColor,
                leading: IconButton(
                  onPressed: () {
                    TODO_notification().notification.cancel(id).then((value) {
                      cubit.changeperventScedual(val: false);
                      goto(
                        goalScreen: homePage(),
                        context: context,
                        moveType: PageTransitionType.topToBottom,
                      );
                    }).catchError((error) {
                      print('Error in back from notifications Screen : $error');
                    });
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey.shade400,
                  ),
                ),
                title: Text(
                  'Notification Details',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                titleSpacing: 0,
                actions: [appbarAction()],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Image(
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 4,
                        image: AssetImage('images/icon.png'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView(
                          children: [
                            headingsTitleBuilder(title: 'Notifiction Title : '),
                            Container(
                              child: Text(
                                model.title.toString(),
                                textAlign: TextAlign.justify,
                                style: style,
                              ),
                            ),
                            headingsTitleBuilder(title: 'Notifiction Note : '),
                            Container(
                              child: Text(
                                model.note.toString(),
                                textAlign: TextAlign.justify,
                                style: style,
                              ),
                            ),
                            headingsTitleBuilder(title: 'Notifiction Time :'),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          color: Colors.grey.shade400,
                                        ),
                                        Text(
                                          ' Start at ${model.startTime}',
                                          style: style.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.schedule,
                                            color: Colors.grey.shade400),
                                        Text(
                                          ' End at  ${model.endTime}',
                                          style: style.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            headingsTitleBuilder(title: 'Notifiction Date :'),
                            Text(
                              'You should do this task at : ${model.date!}',
                              style: style,
                            ),
                            headingsTitleBuilder(
                                title: 'Notifiction Date Repeat :'),
                            Text(
                                model.repeat == 'None'
                                    ? 'No Repeat'
                                    : 'Notifiction Repeat : ${model.repeat} at the same time',
                                style: style),
                            headingsTitleBuilder(title: 'Notifiction Status :'),
                            Text(
                                model.isCompleted == 0
                                    ? 'Not Completed'
                                    : 'Completed',
                                style: style),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
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

Widget headingsTitleBuilder({
  required String title,
}) =>
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
