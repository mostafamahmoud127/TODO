import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

  AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changebootomsheetstate(bool isbottom, IconData fabicon) {
    isBottomSheetShown = isbottom;
    fabIcon = fabicon;
    emit(AppChangeBottomsheetState());
  }

  late Database database;
  List<Map> tasks = [];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> arctasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {})
            .catchError((error) {});
      },
      onOpen: (database) {
        getDatabase(database).then((value) {
          tasks = value;
          splittasks();
          emit(AppGetDatabaseState());
        });
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void splittasks() {
    newtasks = [];
    donetasks = [];
    arctasks = [];
    for (var element in tasks) {
      if (element['status'] == 'new') {
        newtasks.add(element);
      } else if (element['status'] == 'done') {
        donetasks.add(element);
      } else {
        arctasks.add(element);
      }
    }
  }

  Future<List<Map>> getDatabase(gdatabase) async {
    return await gdatabase.rawQuery('SELECT * FROM tasks');
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      emit(AppUpdateDatabaseState());
      getDatabase(database).then((value) {
        tasks = value;
        splittasks();
        emit(AppGetDatabaseState());
      });
    }).catchError((error) {});
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      emit(AppdeleteDatabaseState());
      getDatabase(database).then((value) {
        tasks = value;
        splittasks();
        emit(AppGetDatabaseState());
      });
    }).catchError((error) {});
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        emit(AppInsertDatabaseState());

        getDatabase(database).then((value) {
          tasks = value;
          splittasks();
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {});
    });
  }
}
