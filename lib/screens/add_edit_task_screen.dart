// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// import '../models/task.dart';
// import '../providers/task_provider.dart';

// class AddEditTaskScreen extends StatefulWidget {
//   final Task? task;
//   const AddEditTaskScreen({super.key, this.task});

//   @override
//   State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
// }

// class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _titleCtrl;
//   late final TextEditingController _descCtrl;
//   DateTime? _dueDate;

//   @override
//   void initState() {
//     super.initState();
//     _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
//     _descCtrl = TextEditingController(text: widget.task?.description ?? '');
//     _dueDate =
//         widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
//   }

//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _descCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     final initial = _dueDate ?? now;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: now.subtract(const Duration(days: 365)),
//       lastDate: now.add(const Duration(days: 3650)),
//     );
//     if (picked != null) setState(() => _dueDate = picked);
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;
//     final provider = Provider.of<TaskProvider>(context, listen: false);

//     if (widget.task == null) {
//       final newTask = Task(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleCtrl.text.trim(),
//         description: _descCtrl.text.trim(),
//         dueDate: _dueDate!,
//       );
//       await provider.addTask(newTask);
//     } else {
//       final updated = Task(
//         id: widget.task!.id,
//         title: _titleCtrl.text.trim(),
//         description: _descCtrl.text.trim(),
//         dueDate: _dueDate!,
//         isCompleted: widget.task!.isCompleted,
//       );
//       await provider.updateTask(widget.task!.id, updated);
//     }

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.task != null;
//     return Scaffold(
//       appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleCtrl,
//                 decoration: const InputDecoration(labelText: 'Title'),
//                 validator: (v) => (v == null || v.trim().isEmpty)
//                     ? 'Please enter title'
//                     : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _descCtrl,
//                 maxLines: 3,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 validator: (v) => (v == null || v.trim().isEmpty)
//                     ? 'Please enter description'
//                     : null,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(_dueDate == null
//                         ? 'No due date'
//                         : 'Due: ${DateFormat.yMMMd().format(_dueDate!)}'),
//                   ),
//                   TextButton.icon(
//                     onPressed: _pickDate,
//                     icon: const Icon(Icons.calendar_month),
//                     label: const Text('Pick Date'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _save,
//                 icon: const Icon(Icons.save),
//                 label: Text(isEditing ? 'Save changes' : 'Add Task'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//!
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _dueDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _dueDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (widget.task == null) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        dueDate: _dueDate!,
      );
      await provider.addTask(newTask);
    } else {
      final updated = Task(
        id: widget.task!.id,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        dueDate: _dueDate!,
        isCompleted: widget.task!.isCompleted,
      );
      await provider.updateTask(widget.task!.id, updated);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit your task' : 'Create a new task',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'No due date selected'
                          : 'Due: ${DateFormat.yMMMd().format(_dueDate!)}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Pick Date'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: Text(isEditing ? 'Save' : 'Add'),
      ),
    );
  }
}
