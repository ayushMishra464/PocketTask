import '../entities/task.dart';
import '../repository/task_repository.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<void> call(List<Task> tasks) async {
    await repository.saveTasks(tasks);
  }
}
