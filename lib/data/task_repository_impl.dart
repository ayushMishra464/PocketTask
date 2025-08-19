import '../../domain/entities/task.dart';
import '../domain/repository/task_repository.dart';
import 'model/task_model.dart';
import 'model/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  List<TaskModel> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    _tasks = await localDataSource.loadTasks();
    return _tasks;
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await localDataSource.saveTasks(
      tasks
          .map(
            (e) => TaskModel(
              id: e.id,
              title: e.title,
              done: e.done,
              createdAt: e.createdAt,
            ),
          )
          .toList(),
    );
    _tasks = tasks
        .map(
          (e) => TaskModel(
            id: e.id,
            title: e.title,
            done: e.done,
            createdAt: e.createdAt,
          ),
        )
        .toList();
  }
}
