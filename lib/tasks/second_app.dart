import 'package:flutter/material.dart';

class Task {
  String title;
  bool isDone;
  Task(this.title, {this.isDone = false});
}

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final List<Task> _tasks = [
    Task("Finish Flutter project"),
    Task("Buy groceries"),
    Task("Go to the gym"),
  ];

  Future<bool> _showDeleteConfirmationDialog(
    BuildContext context,
    String task,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: Text("Are you sure you want to delete \"$task\"?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _deleteTask(int index) {
    final task = _tasks[index];

    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Deleted \"${task.title}\""),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _tasks.insert(index, task);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager"), centerTitle: true),
      body: ReorderableListView.builder(
        itemCount: _tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: ValueKey(task.title),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              final confirmed = await _showDeleteConfirmationDialog(
                context,
                task.title,
              );
              if (confirmed) {
                _deleteTask(index);
              }
              return confirmed;
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isDone ? Colors.grey : Colors.black,
                ),
              ),
              trailing: Checkbox(
                value: task.isDone,
                onChanged: (checked) {
                  setState(() {
                    task.isDone = checked ?? false;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
