# Project Structure - Clean Architecture

This Android launcher project follows Clean Architecture principles with clear separation of concerns.

## Directory Structure

```
lib/
├── core/                           # Core utilities and constants
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   └── theme/
│       └── app_theme.dart         # Theme configuration
│
├── data/                          # Data layer
│   └── repositories/
│       └── app_repository_impl.dart # Repository implementation
│
├── domain/                        # Domain/Business layer
│   ├── entities/
│   │   └── app_entity.dart       # App entity model
│   ├── repositories/
│   │   └── app_repository.dart   # Repository interface
│   └── usecases/
│       ├── get_installed_apps_usecase.dart
│       ├── launch_app_usecase.dart
│       └── open_app_settings_usecase.dart
│
├── presentation/                  # Presentation layer
│   ├── cubit/
│   │   └── launcher_cubit.dart   # State management
│   ├── di/
│   │   └── dependency_injection.dart # Dependency injection
│   ├── pages/
│   │   └── launcher_page.dart    # Main launcher page
│   └── widgets/
│       ├── app_grid_item.dart    # App grid item widget
│       ├── app_options_bottom_sheet.dart
│       └── search_bar.dart       # Search bar widget
│
└── main.dart                      # App entry point
```

## Architecture Layers

### 1. Core Layer
- **Constants**: Application-wide constants
- **Theme**: Theme configuration and styling

### 2. Data Layer
- **Repositories**: Concrete implementations of domain repositories
- Handles external data sources (installed_apps package)

### 3. Domain Layer
- **Entities**: Pure Dart business objects
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Single-responsibility business logic operations

### 4. Presentation Layer
- **Cubit**: State management using ChangeNotifier
- **Pages**: Screen-level widgets
- **Widgets**: Reusable UI components
- **DI**: Dependency injection setup

## Data Flow

```
UI (Page) → Cubit → Use Case → Repository → Data Source
                ↓
            State Update
                ↓
            UI Update
```

## Benefits of This Architecture

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Easy to unit test use cases and business logic
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features following the same pattern
5. **Dependency Rule**: Dependencies point inward (toward domain layer)
