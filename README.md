# PocketTasks

PocketTasks is a cleanly architected Flutter application for managing daily tasks efficiently. It provides a simple and intuitive interface to add, search, filter, and manage tasks with persistent local storage and a smooth user experience.

## Features

- **Add Tasks:** Quickly add new tasks with validation to prevent empty entries.
- **Delete Tasks:** Just Swipe right to delete any task.
- **Search & Filter:** Search tasks by title with a debounced search box and filter tasks by All, Active, or Done status.
- **Task Management:** Toggle task completion with undo functionality, and swipe to delete tasks with undo support.
- **Persistent Storage:** Tasks are stored locally using Shared Preferences as JSON, ensuring data persistence between app restarts.
- **Reactive State Management:** Built using Riverpod's StateNotifier for robust, reactive, and clean state handling.
- **Dark & Light Themes:** Supports both light and dark modes with a toggle button positioned neatly in the UI.
- **Performance Optimized:** Efficient use of ListView.builder allows smooth handling even with 100+ tasks.
- **Clean Architecture:** Separation of concerns with distinct layers for data, domain, and presentation for maintainability and testability.
- **Unit Tested:** Includes unit tests for core filtering and searching logic to ensure reliable functionality.

## Project Structure

- **Data Layer:** Responsible for local data persistence and repository implementation.
- **Domain Layer:** Contains business entities, repository interfaces, and use case classes.
- **Presentation Layer:** Flutter UI and state notifier managing UI state reactively.

## ScreenShots

![WhatsApp Image 2025-08-20 at 02 31 04_d4a6f560](https://github.com/user-attachments/assets/0fb52df4-c5c8-4a5a-a6ea-259ac2b98950)

![WhatsApp Image 2025-08-20 at 02 31 04_033ece2f](https://github.com/user-attachments/assets/493ad1fa-d587-44d2-a093-748be14e4473)



***
