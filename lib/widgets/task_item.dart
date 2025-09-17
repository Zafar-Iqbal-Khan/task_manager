// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/add_edit_task_screen.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final Color? backgroundColor; // Add backgroundColor parameter

  const TaskItem({
    super.key,
    required this.task,
    this.backgroundColor, // Optional background color
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem>
    with SingleTickerProviderStateMixin {
  // Entrance animation for the tile
  late final AnimationController _enter;
  late final Animation<double> _fade;
  late final Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _enter, curve: Curves.easeOutCubic);
    _size = CurvedAnimation(parent: _enter, curve: Curves.easeOutBack);
    // Stagger entrance a bit for list feel
    Future.microtask(_enter.forward);
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TaskProvider>(context, listen: false);
    final theme = Theme.of(context);
    final task = widget.task;
    final isOverdue =
        !task.isCompleted && task.dueDate.isBefore(DateTime.now());
    final dueText = DateFormat.yMMMd().format(task.dueDate);

    Color dueBg() {
      if (task.isCompleted) {
        return theme.colorScheme.surfaceVariant.withOpacity(0.6);
      }
      if (isOverdue) return theme.colorScheme.errorContainer;
      return theme.colorScheme.secondaryContainer;
    }

    Color dueFg() {
      if (task.isCompleted) return theme.colorScheme.onSurfaceVariant;
      if (isOverdue) return theme.colorScheme.onErrorContainer;
      return theme.colorScheme.onSecondaryContainer;
    }

    return FadeTransition(
      opacity: _fade,
      child: SizeTransition(
        sizeFactor: _size,
        axisAlignment: -1,
        child: Dismissible(
          key: ValueKey(task.id),
          movementDuration: const Duration(milliseconds: 200),
          // keep thresholds modest; motion should feel deliberate
          dismissThresholds: const {
            DismissDirection.startToEnd: 0.58,
            DismissDirection.endToStart: 0.58,
          },
          background: const _SwipeAction(
            alignment: Alignment.centerLeft,
            colorRole: _SwipeColorRole.edit,
          ),
          secondaryBackground: const _SwipeAction(
            alignment: Alignment.centerRight,
            colorRole: _SwipeColorRole.delete,
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              if (!task.isCompleted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEditTaskScreen(task: task)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Completed tasks cannot be edited.'),
                    behavior: SnackBarBehavior.floating,
                    showCloseIcon: true,
                  ),
                );
              }
              return false;
            }
            return true;
          },
          onDismissed: (_) async {
            final deleted = task;
            await prov.deleteTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Task deleted'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () => prov.restoreTask(deleted),
                ),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 4, // Adds elevation for shadow effect
            shadowColor: theme.colorScheme.shadow
                .withOpacity(0.3), // Subtle shadow color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            color: widget.backgroundColor ??
                theme.colorScheme.surface, // Use backgroundColor
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(16), // Matches the card's border radius
              onTap: widget.task.isCompleted
                  ? null
                  : () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditTaskScreen(task: task),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated checkbox-like control
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: GestureDetector(
                        onTap: () async => prov.toggleComplete(task.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: task.isCompleted
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              width: 2,
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 160),
                            switchInCurve: Curves.easeOutBack,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, anim) => ScaleTransition(
                              scale: anim,
                              child:
                                  FadeTransition(opacity: anim, child: child),
                            ),
                            child: task.isCompleted
                                ? Icon(Icons.check_rounded,
                                    key: const ValueKey('checked'),
                                    size: 16,
                                    color: theme.colorScheme.onPrimary)
                                : const SizedBox(key: ValueKey('unchecked')),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text + meta
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row with animated style
                          Row(
                            children: [
                              Expanded(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 180),
                                  curve: Curves.easeOutCubic,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? theme.colorScheme.onSurfaceVariant
                                        : theme.colorScheme.onSurface,
                                  ),
                                  child: Text(
                                    widget.task.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutBack,
                                turns:
                                    0, // reserved if you want to rotate on press
                                child: Icon(Icons.chevron_right_rounded,
                                    color: theme.colorScheme.outline, size: 22),
                              ),
                            ],
                          ),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 180),
                            crossFadeState: widget.task.description.isNotEmpty
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            secondChild: const SizedBox(height: 0),
                          ),
                          const SizedBox(height: 8),
                          // Meta chips with animated bg/fg and icon swap
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                decoration: BoxDecoration(
                                  color: dueBg(),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 160),
                                      switchInCurve: Curves.easeOutBack,
                                      switchOutCurve: Curves.easeInCubic,
                                      transitionBuilder: (c, a) =>
                                          ScaleTransition(
                                        scale: a,
                                        child: FadeTransition(
                                            opacity: a, child: c),
                                      ),
                                      child: Icon(
                                        isOverdue
                                            ? Icons.warning_amber_rounded
                                            : Icons.event_rounded,
                                        key: ValueKey(isOverdue),
                                        size: 14,
                                        color: dueFg(),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOutCubic,
                                      style:
                                          theme.textTheme.labelMedium!.copyWith(
                                        color: dueFg(),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                      child: Text(isOverdue
                                          ? 'Overdue • $dueText'
                                          : 'Due • $dueText'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                switchInCurve: Curves.easeOutBack,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (c, a) => SizeTransition(
                                  sizeFactor: a,
                                  axisAlignment: -1,
                                  child: FadeTransition(opacity: a, child: c),
                                ),
                                child: task.isCompleted
                                    ? Container(
                                        key: const ValueKey('completed'),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              theme.colorScheme.surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.done_all_rounded,
                                                size: 14,
                                                color: theme.colorScheme
                                                    .onSurfaceVariant),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Completed',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(
                                        key: ValueKey('not-completed')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _SwipeColorRole { edit, delete }

class _SwipeAction extends StatelessWidget {
  final Alignment alignment;
  final _SwipeColorRole colorRole;
  const _SwipeAction({
    required this.alignment,
    required this.colorRole,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = colorRole == _SwipeColorRole.edit
        ? cs.primaryContainer
        : cs.errorContainer;
    final fg = colorRole == _SwipeColorRole.edit
        ? cs.onPrimaryContainer
        : cs.onErrorContainer;
    final icon = colorRole == _SwipeColorRole.edit
        ? Icons.edit_rounded
        : Icons.delete_rounded;
    final label = colorRole == _SwipeColorRole.edit ? 'Edit' : 'Delete';

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: bg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
