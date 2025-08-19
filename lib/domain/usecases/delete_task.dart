import '../entities/task.dart';
import '../repository/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  Future<void> call(Task task) async {
    final tasks = await repository.getTasks();
    final updatedTasks = tasks.where((t) => t.id != task.id).toList();
    await repository.saveTasks(updatedTasks);
  }
}
