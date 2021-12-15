import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/local_notification/notification.dart';
import 'package:to_do_app/model/model.dart';
import 'package:to_do_app/modules/home_page.dart';
import 'package:to_do_app/shared/components/functions.dart';
import 'package:to_do_app/shared/cubit/to_do_states.dart';

class TODO_cubit extends Cubit<TODO_States> {
  TODO_cubit() : super(initialState());

  static TODO_cubit get(context) => BlocProvider.of(context);

  ///prevent schedual

  bool allowScedual = false;

  void changeperventScedual({
    required bool val,
  }) {
    allowScedual = val;
    emit(changeperventScedualState());
  }

  ///create local dataBase
  late Database databaseInstance;
  final String createTableSql =
      'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, note TEXT, date TEXT, starttime TEXT,endtime TEXT, remind INTEGER, color INTEGER,iscompleted INTEGER, repeat TEXT )';

  void createDataBase() {
    openDatabase(
      'new_todo.db',
      version: 1,
      onCreate: (db, version) => db
          .execute(createTableSql)
          .then(
            (_) => print('table created'),
          )
          .catchError((error) {
        print('Error in creating table ${error.toString()}');
      }),
      onOpen: (db) => databaseInstance = db,
    ).then((databaseObject) {
      databaseInstance = databaseObject;
      changeperventScedual(val: true);
      getData();
      emit(databaseReadyState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void insertIntoDataBase({
    required BuildContext context,
    required String title,
    required String note,
    required String noteDate,
    required String startTime,
    required String endTime,
    required int reminder,
    required int color,
    required int iscompleted,
    required String repeat,
  }) {
    String stored_startTime = DateFormat.Hm().format(starttime);
    String stored_endTime = DateFormat.Hm().format(endtime);

    databaseInstance.transaction(
      (txn) async {
        txn.rawInsert(
          '''
                INSERT INTO notes(
                  title, note, date,starttime,
                  endtime,remind,color,iscompleted,
                  repeat) 
                  VALUES(
                    "$title","$note","$noteDate",
                    "$stored_startTime","$stored_endTime",
                    "$reminder","$color","$iscompleted",
                    "$repeat")
                    ''',
        ).then((value) {
          changeperventScedual(val: true);
          clearNoteInfo();
          goto(
            goalScreen: homePage(),
            context: context,
            moveType: PageTransitionType.rightToLeft,
          );
          getData();
        });
      },
    );
  }

  obtained_data? obtained_dataObject;
  final String getDataSql = 'SELECT * FROM notes';
  void getData() {
    databaseInstance.rawQuery(getDataSql).then((value) {
      obtained_dataObject = obtained_data.fromJson(value);
      filtereddatabyTime(date: DateFormat("yMMMMd").parse(initialDate));
      emit(getDataState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void deleteNote({required int noteID, required BuildContext context}) {
    databaseInstance
        .rawDelete('DELETE FROM notes WHERE id = $noteID')
        .then((value) {
      showToast(
        context: context,
        msg: 'Note deleted',
        backgroundColor: Colors.green,
      );
      changeperventScedual(val: false);
      getData();
      emit(NoteDeletedState());
    });
  }

  void updateNote({
    required int noteID,
    required int value,
    required BuildContext context,
  }) {
    databaseInstance
        .rawUpdate('UPDATE notes SET iscompleted = $value WHERE id = $noteID ')
        .then((value) {
      showToast(
        context: context,
        msg: 'Note updated',
        backgroundColor: Colors.green,
      );
      changeperventScedual(val: false);
      getData();
      emit(NoteUpdatedState());
    });
  }

  ///store title and body for note
  String noteTitle = 'Enter title here.';
  String notebody = 'Enter note here.';

  void changeNoteInfo({
    required int index,
    required String value,
  }) {
    if (index == 1) {
      noteTitle = value;
    } else {
      notebody = value;
    }
    emit(changeNoteInfoState());
  }

  void clearNoteInfo() {
    noteTitle = 'Enter title here.';
    notebody = 'Enter note here.';
    emit(clearNoteInfoState());
  }

  ///############### select note reminder
  int reminder = 5;
  List<int> reminderValue = [5, 10, 15, 20];
  void changeReminder({required int newValue}) {
    reminder = newValue;
    emit(changeReminderState());
  }

  //############## select note repeat

  String repeat = 'None';
  List<String> repeatValue = ['None', 'Daily', 'Weakly', 'Monthly'];
  void changeNoteRepeat({
    required String newValue,
  }) {
    repeat = newValue;
    emit(changeNoteRepeatState());
  }

  ///############## select note Color
  int selectedColor = 0;
  void changeNoteColor({required int newindex}) {
    selectedColor = newindex;
    emit(changeNoteColorState());
  }

  ///###################### select note Date

  String initialDate = DateFormat.yMMMMd().format(DateTime.now());
  void changeNoteDate({
    required String newDate,
  }) {
    initialDate = newDate;
    emit(changeNoteDateState());
  }

  void selectDate({
    required BuildContext context,
  }) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value != null)
        changeNoteDate(newDate: DateFormat.yMMMMd().format(value));
    });
  }

  ///############# select start and end time for note

  DateTime starttime = DateTime.now();
  DateTime endtime = DateTime.now().add(Duration(minutes: 15));
  void selectTime({
    required BuildContext context,
    required int index,
  }) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      ///convert TimeOfDay to dateTime
      DateTime date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        value!.hour,
        value.minute,
      );
      if (index == 1) {
        starttime = date;
      } else {
        endtime = date;
      }
      emit(changeNoteTimeState());
    });
  }

  ThemeMode? tm;

  ///called once at the first run
  void initializeAppMode({
    required bool isDark,
  }) {
    if (isDark) {
      tm = ThemeMode.dark;
      emit(initthemeModeState());
    } else {
      tm = ThemeMode.light;
      emit(initthemeModeState());
    }
  }

  ///######## switch between dark and light theme
  void changeAppTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (tm == ThemeMode.light) {
      tm = ThemeMode.dark;
      emit(changethemeModeState());
      prefs.setBool('isDark', true);
    } else {
      tm = ThemeMode.light;
      emit(changethemeModeState());
      prefs.setBool('isDark', false);
    }
  }

  List<taskModel> filteredData = [];
  void filtereddatabyTime({
    required DateTime date,
  }) {
    filteredData = [];

    final data = obtained_dataObject!.mydata;
    String newdate = DateFormat.yMMMMd().format(date);
    data.forEach((element) {
      if (element.date == newdate ||
          element.repeat == 'Daily' ||

          ///weakly notes
          (element.repeat == 'Weakly' &&
              date.difference(DateFormat.yMMMMd().parse(element.date!)).inDays %
                      7 ==
                  0) ||

          ///monthly notes
          (element.repeat == 'Monthly' &&
              DateFormat.yMMMMd().parse(element.date!).day == date.day)) {
        filteredData.add(element);
      }
    });
    emit(filteredDataByTimeState());
  }

  void cleanDB() {
    TODO_notification().notification.cancelAll().then((value) {
      databaseInstance.delete('notes').then((value) {
        getData();
      });

      emit(cleanNotesState());
    }).catchError((error) {
      print(error.toString());
    });
  }
}
