import '../entities/task.dart';
import '../repository/task_repository.dart';

class ToggleDone {
  final TaskRepository repository;
  ToggleDone(this.repository);

  Future<void> call(Task task) async {
    final tasks = await repository.getTasks();
    final updatedTasks = tasks
        .map((t) => t.id == task.id ? t.copyWith(done: !t.done) : t)
        .toList();
    await repository.saveTasks(updatedTasks);
  }
}
