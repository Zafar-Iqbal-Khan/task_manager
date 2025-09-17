# Task Manager

A Flutter-based task management application that helps users organize, track, and manage their tasks efficiently. The app supports features like adding, editing, deleting, and filtering tasks, along with persistent storage.

## Features

- **Add Tasks**: Create new tasks with a title, description, and due date.
- **Edit Tasks**: Modify existing tasks.
- **Delete Tasks**: Remove tasks with an option to undo.
- **Mark as Complete**: Toggle task completion status.
- **Filter Tasks**: View tasks based on their status (All, Completed, Pending).
- **Sort Tasks**: Sort tasks by due date in ascending or descending order.
- **Persistent Storage**: Tasks are saved locally using `SharedPreferences`.


## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/zafar-iqbal-khan/task_manager.git
   cd task_manager
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## File and Folder Structure

Here’s an overview of the project structure:

```
task_manager/
├── lib/
│   ├── models/
│   │   └── task.dart          # Task model with properties and methods
│   ├── providers/
│   │   └── task_provider.dart # State management for tasks
│   ├── screens/
│   │   ├── splash_screen #Splash screen
│   │   ├── task_list_screen.dart #Screen for listing tasks
│   │   └── add_edit_task_screen.dart # Screen for adding/editing tasks
│   ├── widgets/
│   │   └── task_item.dart     # Widget for displaying individual tasks
│   └── main.dart              # Entry point of the application
├── pubspec.yaml               # Project dependencies
└── README.md                  # Project documentation
```

## Dependencies

- **[Provider](https://pub.dev/packages/provider)**: State management.
- **[SharedPreferences](https://pub.dev/packages/shared_preferences)**: Persistent storage.
- **[Intl](https://pub.dev/packages/intl)**: Date formatting.


## 📥 Download APK

You can download the latest release APK here [![Download APK](https://img.shields.io/badge/Download-APK-blue.svg?style=for-the-badge)](https://github.com/Zafar-Iqbal-Khan/task_manager/raw/main/release_apk/app-release.apk)

## Video Demo

https://github.com/user-attachments/assets/d44b6d4d-807d-4ec6-bc48-62459aaf40c8


## How to Use

1. **Add a Task**:
   - Tap the "Add" button to create a new task.
   - Fill in the title, description, and due date.

2. **Edit a Task**:
   - Swipe right on a task and tap "Edit" to modify it.

3. **Delete a Task**:
   - Swipe left on a task to delete it.
   - Use the "UNDO" option in the snackbar to restore the task.

4. **Filter Tasks**:
   - Use the filter options to view all, completed, or pending tasks.

5. **Sort Tasks**:
   - Toggle the sort order by selecting the "Sort" option.



## Contact

For any questions or feedback, feel free to reach out:

- **Email**: zafar1219@gmail.com
- **GitHub**: [zafar-iqbal-khan](https://github.com/zafar-iqbal-khan)
