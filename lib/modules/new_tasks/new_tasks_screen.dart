import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => ListView.separated(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(
                      AppCubit().get(context).newtasks[index]['id'].toString()),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 40.0,
                          child: Text(
                            '${AppCubit().get(context).newtasks[index]['time']}',
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppCubit().get(context).newtasks[index]['title']}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${AppCubit().get(context).newtasks[index]['date']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          onPressed: () {
                            AppCubit().get(context).updateData(
                                  status: 'done',
                                  id: AppCubit().get(context).newtasks[index]
                                      ['id'],
                                );
                          },
                          icon: const Icon(
                            Icons.check_box,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AppCubit().get(context).updateData(
                                  status: 'archive',
                                  id: AppCubit().get(context).newtasks[index]
                                      ['id'],
                                );
                          },
                          icon: const Icon(
                            Icons.archive,
                            color: Colors.black45,
                          ),
                        ),
                      ])),
                  onDismissed: (direction) {
                    AppCubit().get(context).deleteData(
                          id: AppCubit().get(context).newtasks[index]['id'],
                        );
                  },
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 20.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: AppCubit().get(context).newtasks.length,
            ));
  }
}
