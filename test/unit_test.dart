import 'package:flutter_test/flutter_test.dart';
import 'package:pocketask/domain/entities/task.dart';
import 'package:pocketask/domain/repository/task_repository.dart';
import 'package:pocketask/domain/usecases/add_task.dart';
import 'package:pocketask/domain/usecases/delete_task.dart';
import 'package:pocketask/domain/usecases/restore_task.dart';
import 'package:pocketask/domain/usecases/get_task.dart';
import 'package:pocketask/domain/usecases/toogle_done.dart';
import 'package:pocketask/presentation/task_notifier.dart';

class FakeTaskRepository implements TaskRepository {
  List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    _tasks = tasks;
  }
}

class DummyGetTasks extends GetTasks {
  DummyGetTasks(TaskRepository repository) : super(repository);
  @override
  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}

class DummyAddTask extends AddTask {
  DummyAddTask(TaskRepository repository) : super(repository);
  @override
  Future<void> call(List<Task> tasks) async {
    await repository.saveTasks(tasks);
  }
}

class DummyDeleteTask extends DeleteTask {
  DummyDeleteTask(TaskRepository repository) : super(repository);
  @override
  Future<void> call(Task task) async {
    final tasks = await repository.getTasks();
    final updatedTasks = tasks.where((t) => t.id != task.id).toList();
    await repository.saveTasks(updatedTasks);
  }
}

class DummyToggleDone extends ToggleDone {
  DummyToggleDone(TaskRepository repository) : super(repository);
  @override
  Future<void> call(Task task) async {
    final tasks = await repository.getTasks();
    final updatedTasks = tasks
        .map((t) => t.id == task.id ? t.copyWith(done: !t.done) : t)
        .toList();
    await repository.saveTasks(updatedTasks);
  }
}

class DummyRestoreTask extends RestoreTask {
  DummyRestoreTask(TaskRepository repository) : super(repository);
  @override
  Future<void> call(Task task) async {
    final tasks = await repository.getTasks();
    final updatedTasks = [task, ...tasks];
    await repository.saveTasks(updatedTasks);
  }
}

void main() {
  group('TaskNotifier filtering and search tests', () {
    late TaskNotifier notifier;
    late FakeTaskRepository fakeRepository;

    setUp(() async {
      fakeRepository = FakeTaskRepository();

      notifier = TaskNotifier(
        DummyGetTasks(fakeRepository),
        DummyAddTask(fakeRepository),
        DummyDeleteTask(fakeRepository),
        DummyToggleDone(fakeRepository),
        DummyRestoreTask(fakeRepository),
      );

      final tasks = [
        Task(
          id: '1',
          title: 'Buy milk',
          done: false,
          createdAt: DateTime.now(),
        ),
        Task(id: '2', title: 'Call mom', done: true, createdAt: DateTime.now()),
        Task(
          id: '3',
          title: 'Walk dog',
          done: false,
          createdAt: DateTime.now(),
        ),
        Task(
          id: '4',
          title: 'Buy groceries',
          done: true,
          createdAt: DateTime.now(),
        ),
      ];

      await fakeRepository.saveTasks(tasks);
      await notifier.refresh();
    });

    test('Filter All shows all tasks', () {
      notifier.setFilter(TaskFilter.all);
      notifier.setSearch('');
      final filtered = notifier.state.filteredTasks;
      expect(filtered.length, 4);
    });

    test('Filter Active shows only incomplete tasks', () {
      notifier.setFilter(TaskFilter.active);
      notifier.setSearch('');
      final filtered = notifier.state.filteredTasks;
      expect(filtered.length, 2);
      expect(filtered.every((task) => !task.done), isTrue);
    });

    test('Filter Done shows only done tasks', () {
      notifier.setFilter(TaskFilter.done);
      notifier.setSearch('');
      final filtered = notifier.state.filteredTasks;
      expect(filtered.length, 2);
      expect(filtered.every((task) => task.done), isTrue);
    });

    test('Search filters tasks by title', () {
      notifier.setFilter(TaskFilter.all);
      notifier.setSearch('buy');
      final filtered = notifier.state.filteredTasks;
      expect(filtered.length, 2);
      expect(
        filtered.every((task) => task.title.toLowerCase().contains('buy')),
        isTrue,
      );
    });

    test('Search combined with filter works correctly', () {
      notifier.setFilter(TaskFilter.active);
      notifier.setSearch('walk');
      final filtered = notifier.state.filteredTasks;
      expect(filtered.length, 1);
      expect(filtered.first.title, 'Walk dog');
      expect(filtered.first.done, false);
    });
  });
}
