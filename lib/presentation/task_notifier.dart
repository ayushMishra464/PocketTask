import 'package:riverpod/riverpod.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/restore_task.dart';
import '../data/model/task_local_data_source.dart';
import '../data/task_repository_impl.dart';
import '../domain/usecases/get_task.dart';
import '../domain/usecases/toogle_done.dart';

enum TaskFilter { all, active, done }

class TaskNotifier extends StateNotifier<TaskNotifierState> {
  final GetTasks getTasksUseCase;
  final AddTask addTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final ToggleDone toggleDoneUseCase;
  final RestoreTask restoreTaskUseCase;

  TaskNotifier(
    this.getTasksUseCase,
    this.addTaskUseCase,
    this.deleteTaskUseCase,
    this.toggleDoneUseCase,
    this.restoreTaskUseCase,
  ) : super(TaskNotifierState()) {
    refresh();
  }

  TaskFilter get filter => state.filter;

  void setFilter(TaskFilter filter) {
    state = state.copyWith(filter: filter);
    _updateFilteredTasks();
  }

  void setSearch(String query) {
    state = state.copyWith(search: query);
    _updateFilteredTasks();
  }

  Future<void> addTask(Task task) async {
    final updatedTasks = [task, ...state.tasks];
    await addTaskUseCase(updatedTasks);
    state = state.copyWith(tasks: updatedTasks);
    _updateFilteredTasks();
  }

  Future<void> deleteTask(Task task) async {
    await deleteTaskUseCase(task);
    await refresh();
  }

  Future<void> restoreTask(Task task) async {
    await restoreTaskUseCase(task);
    await refresh();
  }

  Future<void> toggleTaskDone(Task task) async {
    await toggleDoneUseCase(task);
    await refresh();
  }

  Future<void> refresh() async {
    final tasks = await getTasksUseCase();
    state = state.copyWith(tasks: tasks);
    _updateFilteredTasks();
  }

  void _updateFilteredTasks() {
    var tasks = state.tasks;
    if (state.filter == TaskFilter.active) {
      tasks = tasks.where((t) => !t.done).toList();
    } else if (state.filter == TaskFilter.done) {
      tasks = tasks.where((t) => t.done).toList();
    }
    if (state.search.isNotEmpty) {
      tasks = tasks
          .where(
            (t) => t.title.toLowerCase().contains(state.search.toLowerCase()),
          )
          .toList();
    }
    state = state.copyWith(filteredTasks: tasks);
  }
}

class TaskNotifierState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final TaskFilter filter;
  final String search;

  TaskNotifierState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.filter = TaskFilter.all,
    this.search = '',
  });

  TaskNotifierState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    TaskFilter? filter,
    String? search,
  }) {
    return TaskNotifierState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskNotifierState>((ref) {
      final taskRepository = TaskRepositoryImpl(TaskLocalDataSource());
      final getTasks = GetTasks(taskRepository);
      final addTask = AddTask(taskRepository);
      final deleteTask = DeleteTask(taskRepository);
      final toggleDone = ToggleDone(taskRepository);
      final restoreTask = RestoreTask(taskRepository);

      return TaskNotifier(
        getTasks,
        addTask,
        deleteTask,
        toggleDone,
        restoreTask,
      );
    });
