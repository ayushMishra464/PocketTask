import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_notifier.dart';
import 'theme_provider.dart';
import '../../domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class MainScreen extends ConsumerWidget {
  MainScreen({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(taskNotifierProvider.notifier);
    final filteredTasks = ref.watch(
      taskNotifierProvider.select((state) => state.filteredTasks),
    );

    final themeNotifier = ref.watch(themeProvider.notifier);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("PocketTasks")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${filteredTasks.where((t) => t.done).length}/${filteredTasks.length}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: filteredTasks.isEmpty
                        ? 0
                        : filteredTasks.where((t) => t.done).length /
                              filteredTasks.length,
                    color: CupertinoColors.activeGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: "Add Task",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final title = _controller.text.trim();
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Title cannot be empty"),
                          ),
                        );
                        return;
                      }
                      provider.addTask(
                        Task(
                          id: const Uuid().v4(),
                          title: title,
                          done: false,
                          createdAt: DateTime.now(),
                        ),
                      );
                      _controller.clear();
                    },
                    child: const Text("Add", selectionColor: Colors.green),
                  ),
                ),
              ],
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search Task",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) => provider.setSearch(query),
              ),
            ),

            // Filter Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text("All"),
                  selected: provider.filter == TaskFilter.all,
                  onSelected: (_) => provider.setFilter(TaskFilter.all),
                  checkmarkColor: Colors.green,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text("Active"),
                  selected: provider.filter == TaskFilter.active,
                  onSelected: (_) => provider.setFilter(TaskFilter.active),
                  checkmarkColor: Colors.green,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text("Done"),
                  selected: provider.filter == TaskFilter.done,
                  onSelected: (_) => provider.setFilter(TaskFilter.done),
                  checkmarkColor: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Task list
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, i) {
                  final task = filteredTasks[i];
                  return Dismissible(
                    key: ValueKey(task.id),
                    background: Container(color: Colors.red),
                    onDismissed: (_) {
                      provider.deleteTask(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Task deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () => provider.restoreTask(task),
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Checkbox(
                        value: task.done,
                        checkColor: Colors.green,
                        activeColor: Colors.white,
                        onChanged: (_) {
                          provider.toggleTaskDone(task);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                task.done
                                    ? 'Marked as undone'
                                    : 'Marked as done',
                              ),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () => provider.toggleTaskDone(task),
                              ),
                            ),
                          );
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      onTap: () => provider.toggleTaskDone(task),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: IconButton(
                iconSize: 36,
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
