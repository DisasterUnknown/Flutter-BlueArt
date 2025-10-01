# Blue Art - Flutter E-commerce App

A Flutter-based e-commerce application for art and collectible figures, featuring user authentication, product browsing, shopping cart, and favorites functionality.

## 📱 Download APK

[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android)](https://github.com/DisasterUnknown/Flutter-BlueArt/raw/main/apk/app-release.apk)

**Direct Download:** [app-release.apk](./apk/app-release.apk)

## 🚀 Features

- User Authentication (Login/Register)
- Product Catalog with Categories
- Shopping Cart Management
- Favorites System
- User Profile Management
- Firebase Integration
- Responsive UI Design

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.8.1 or higher)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/Flutter-BlueArt.git
cd Flutter-BlueArt
```

### 2. Install Dependencies

```bash
# Get all dependencies
flutter pub get

# Or install dependencies individually if needed:
flutter pub add cupertino_icons
flutter pub add firebase_core
flutter pub add intl
flutter pub add google_nav_bar
flutter pub add shared_preferences
flutter pub add http
flutter pub add provider
flutter pub add flutter_riverpod
flutter pub add go_router
flutter pub add collection
flutter pub add firebase_database
flutter pub add image_picker
flutter pub add permission_handler
flutter pub add vibration
flutter pub add sqflite
flutter pub add path
flutter pub add connectivity_plus
flutter pub add sensors_plus
```

### 3. Firebase Setup

1. Create a new project in [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication and Realtime Database
3. Download `google-services.json` and place it in `android/app/` directory
4. Update `lib/firebase_options.dart` with your Firebase configuration

### 4. Run the Application

```bash
# Check if everything is set up correctly
flutter doctor

# Run the app
flutter run

# For specific platforms:
flutter run -d android    # Android
flutter run -d ios        # iOS
flutter run -d web        # Web
```

## 📦 Dependencies

This project uses the following main dependencies:

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | ^4.1.1 | Firebase core functionality |
| `firebase_database` | ^12.0.2 | Realtime database |
| `provider` | ^6.1.5+1 | State management |
| `flutter_riverpod` | ^3.0.0 | Advanced state management |
| `go_router` | ^16.2.1 | Navigation routing |
| `image_picker` | ^1.2.0 | Image selection |
| `shared_preferences` | ^2.5.3 | Local storage |
| `sqflite` | ^2.4.2 | Local database |
| `http` | ^1.5.0 | HTTP requests |
| `connectivity_plus` | ^7.0.0 | Network connectivity |
| `sensors_plus` | ^7.0.0 | Device sensors |

## 🏗️ Project Structure & OOP Architecture

This Flutter project follows **Object-Oriented Programming (OOP)** principles with a clean, modular architecture. Here's a detailed breakdown of each directory and its purpose:

### 📁 Directory Structure

```
lib/
├── components/          # Reusable UI components
├── layout/             # App layout components  
├── models/             # Data models (OOP Classes)
├── network/            # API and network services
├── pages/              # App screens/pages (UI Classes)
├── routes/             # Navigation routing
├── services/           # Business logic services
├── states/             # State management (OOP State Classes)
├── store/              # Data storage (Database Classes)
└── theme/              # App theming
```

### 🎯 OOP Design Patterns & Architecture

#### **1. Models (`/models/`) - Data Classes**
- **`products.dart`**: `Product` class with OOP principles
  - **Encapsulation**: Private fields with public getters
  - **Factory Constructors**: `fromJson()`, `fromDbMap()` for data conversion
  - **Method Overloading**: `toDbMap()` for database serialization
  - **Composition**: Contains `List<ProductImage>` objects

- **`user.dart`**: `User` class representing user data
  - **Data Encapsulation**: Private fields with controlled access
  - **Serialization Methods**: `toJson()`, `fromJson()` for API communication

- **`productImage.dart`**: `ProductImage` class for image data management

#### **2. Network Layer (`/network/`) - Service Classes**
- **`core.dart`**: `Network` class (Static Utility Class)
  - **Static Methods**: URL generation and configuration
  - **Factory Pattern**: Dynamic URL creation based on environment
  - **Singleton-like**: Centralized network configuration

- **`/auth/`**: Authentication Service Classes
  - **`login.dart`**: `AuthLogin` class
    - **Dependency Injection**: HTTP client injection
    - **Single Responsibility**: Handles only login operations
    - **Error Handling**: Centralized error management
  - **`register.dart`**: `AuthRegister` class (similar pattern)

- **`/product/`**: Product Service Classes
  - **`product.dart`**: `NetworkProducts` class
    - **Repository Pattern**: Data access abstraction
    - **Caching**: Local product storage
    - **API Integration**: RESTful service communication

- **`/user/`**: User Management Services
  - **`updateProfile.dart`**: User profile update operations
  - **`resetPassword.dart`**: Password reset functionality

#### **3. State Management (`/states/`) - State Classes**
- **`authStateManagement.dart`**: `UserNotifier` class
  - **StateNotifier Pattern**: Riverpod state management
  - **Observer Pattern**: State change notifications
  - **Persistence**: Local storage integration
  - **Methods**: `login()`, `logout()`, `register()`, `loadUserFromPrefs()`

#### **4. Services (`/services/`) - Utility Classes**
- **`localSharedPreferences.dart`**: `LocalSharedPreferences` class
  - **Static Utility Class**: No instantiation needed
  - **Encapsulation**: Private implementation details
  - **CRUD Operations**: Create, Read, Update, Delete for local storage

- **`sharedPrefValues.dart`**: Constants class for preference keys
- **`shakeDectector.dart`**: Device sensor service class

#### **5. UI Layer (`/pages/` & `/layout/`) - Widget Classes**
- **`/pages/`**: Screen Widget Classes
  - **`homePage.dart`**: `HomePage` StatefulWidget
    - **State Management**: Local state with `setState()`
    - **Callback Functions**: Parent-child communication
    - **Composition**: Uses multiple child widgets
  - **`loginPage.dart`**: Authentication UI
  - **`cartPage.dart`**: Shopping cart management
  - **`profilePage.dart`**: User profile interface

- **`/layout/`**: Layout Component Classes
  - **`layout.dart`**: `Layout` ConsumerStatefulWidget
    - **Provider Integration**: Riverpod state consumption
    - **Tab Management**: Bottom navigation state
    - **Lifecycle Management**: Widget lifecycle methods

#### **6. Data Storage (`/store/`) - Database Classes**
- **`DBHelper.dart`**: Database management class
  - **Singleton Pattern**: Single database instance
  - **CRUD Operations**: Database operations abstraction
  - **SQLite Integration**: Local database management

- **`/liveStore/`**: Live data management
  - **`productLiveStore.dart`**: Real-time product data management

#### **7. Navigation (`/routes/`) - Routing Classes**
- **`app_route.dart`**: `AppRoute` class
  - **Static Configuration**: Route definitions
  - **Factory Pattern**: Route creation based on parameters
  - **Centralized Routing**: Single source of truth for navigation

### 🔧 OOP Principles Applied

#### **1. Encapsulation**
- Private fields with controlled access through methods
- Data hiding in model classes
- Service classes encapsulate business logic

#### **2. Inheritance**
- Flutter's `StatefulWidget` and `StatelessWidget` inheritance
- `ConsumerStatefulWidget` extends Flutter's base classes
- Custom widget inheritance hierarchy

#### **3. Polymorphism**
- Method overriding in widget lifecycle methods
- Interface implementation through abstract classes
- Dynamic method dispatch in state management

#### **4. Abstraction**
- Service layer abstracts API complexity
- Database layer abstracts storage operations
- State management abstracts data flow

### 🎨 Design Patterns Used

1. **Repository Pattern**: Data access abstraction in network layer
2. **Observer Pattern**: State management with Riverpod
3. **Factory Pattern**: Object creation in models and services
4. **Singleton Pattern**: Database and service instances
5. **MVC Pattern**: Model-View-Controller separation
6. **Provider Pattern**: Dependency injection and state management

### 🔄 Data Flow Architecture

```
UI Layer (Pages) 
    ↓ (User Interaction)
State Management (Riverpod)
    ↓ (State Changes)
Service Layer (Network/Services)
    ↓ (API Calls)
Data Layer (Models/Database)
    ↓ (Data Processing)
Back to UI Layer (Reactive Updates)
```

### 📱 Key Classes & Their Responsibilities

| Class | Purpose | OOP Pattern |
|-------|---------|-------------|
| `Product` | Data model for products | Encapsulation + Factory |
| `User` | User data representation | Data Encapsulation |
| `Network` | API configuration | Static Utility Class |
| `AuthLogin` | Authentication logic | Service Class + DI |
| `UserNotifier` | User state management | StateNotifier + Observer |
| `HomePage` | Main UI screen | StatefulWidget + Composition |
| `Layout` | App structure | ConsumerStatefulWidget |
| `LocalSharedPreferences` | Local storage | Static Utility Class |

## 🔧 Development

### Building for Release

```bash
# Build APK for Android
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release

# Build for iOS
flutter build ios --release
```

### Testing

```bash
# Run tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📱 Screenshots

*Add screenshots of your app here*

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **DisasterUnknown** - *DisasterUnknown* - [GitHub](https://github.com/DisasterUnknown)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All open-source package contributors



