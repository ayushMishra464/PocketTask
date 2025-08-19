import '../entities/task.dart';
import '../repository/task_repository.dart';

class RestoreTask {
  final TaskRepository repository;
  RestoreTask(this.repository);

  Future<void> call(Task task) async {
    final tasks = await repository.getTasks();
    final updatedTasks = [task, ...tasks];
    await repository.saveTasks(updatedTasks);
  }
}
