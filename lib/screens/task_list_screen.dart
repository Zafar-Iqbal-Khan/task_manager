import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import 'add_edit_task_screen.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasks;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalTasks = tasks.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with Progress Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 60.0,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.9), // Distinct background color
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                provider.filter == 'all'
                    ? '$completedTasks of $totalTasks tasks completed'
                    : 'Tasks',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white), // White text for contrast
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: provider.filter == 'all'
                  ? Container(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.9), // Match app bar color
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 56.0, left: 16, right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: totalTasks == 0
                                    ? 0
                                    : completedTasks / totalTasks,
                                minHeight: 8, // controls thickness
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'sort') {
                    provider.toggleSortOrder();
                  } else {
                    provider.setFilter(v);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'all',
                    child: Row(
                      children: [
                        Icon(
                          Icons.list_alt,
                          color: provider.filter == 'all'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 8),
                        const Text('All'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'pending',
                    child: Row(
                      children: [
                        Icon(
                          Icons.pending_actions,
                          color: provider.filter == 'pending'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 8),
                        const Text('Pending'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'completed',
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: provider.filter == 'completed'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 8),
                        const Text('Completed'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'sort',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sort by Due Date'),
                        Icon(
                          provider.sortByDueDateAsc
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Task List Section
          tasks.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No tasks added yet.\nTap the "+" button to add a task.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final t = tasks[i];
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 300 + (i * 50)),
                        transitionBuilder: (child, animation) =>
                            SlideTransition(
                          position: Tween<Offset>(
                            begin:
                                const Offset(1, 0), // Slide in from the right
                            end: Offset.zero,
                          ).animate(animation),
                          child:
                              FadeTransition(opacity: animation, child: child),
                        ),
                        child: TaskItem(
                          key: ValueKey(t.id),
                          task: t,
                          backgroundColor: t.isCompleted
                              ? Theme.of(context).colorScheme.secondary.withOpacity(
                                  0.1) // Light secondary color for completed tasks
                              : Theme.of(context)
                                  .colorScheme
                                  .surface, // Default surface color for pending tasks
                        ),
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        backgroundColor: Theme.of(context)
            .colorScheme
            .secondary, // Secondary color for better visibility
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
