import '../entities/task.dart';
import '../repository/task_repository.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<List<Task>> call() async => await repository.getTasks();
}
