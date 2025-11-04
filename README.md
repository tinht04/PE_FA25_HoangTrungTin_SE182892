# Flutter MVVM — Fake Store API (Offline-first)

**App title:** Hoang Trung Tin - SE182892

This is a Flutter mobile application that implements an **offline-first** architecture using **MVVM pattern** with **Fake Store API** (`https://fakestoreapi.com/products`).

## 🎯 Features

### Screen 1: List Screen (Home Screen)

- ✅ Displays products in a scrollable list
- ✅ Shows product title, image, and category for each item
- ✅ Loading indicator during network fetch
- ✅ Error handling with user-friendly messages
- ✅ **Search bar** to filter products by name
- ✅ **Category filters** (auto-generated from fetched data)
- ✅ Navigation to Detail Screen on item tap
- ✅ Offline-first: Caches data locally using SQLite (Drift)

### Screen 2: Detail Screen

- ✅ Displays complete product details (title, price, description, category, image)
- ✅ **Favorite toggle button** (star/heart icon)
- ✅ Button state reflects current favorite status
- ✅ Immediate UI updates on favorite toggle
- ✅ Data persisted in local database

### Screen 3: Favorites Screen

- ✅ Displays only favorited products
- ✅ **Search bar** to filter favorites by name
- ✅ **Category filters** (auto-generated from favorites)
- ✅ Real-time updates when favorites change
- ✅ Empty state message when no favorites exist
- ✅ Navigation to Detail Screen on item tap

## 🏗️ Architecture

**MVVM (Model-View-ViewModel)** pattern with clean architecture:

```
lib/
 ┣ main.dart                    # App entry point with Riverpod providers
 ┣ models/
 ┃  ┗ item_model.dart           # Product data model
 ┣ data/
 ┃  ┣ remote/
 ┃  ┃  ┗ api_service.dart       # Fake Store API client
 ┃  ┣ local/
 ┃  ┃  ┗ app_db.dart            # Drift SQLite database
 ┃  ┗ repository/
 ┃     ┗ item_repository.dart   # Data layer abstraction
 ┣ viewmodels/
 ┃  ┣ list_viewmodel.dart       # List screen business logic
 ┃  ┣ detail_viewmodel.dart     # Detail screen business logic
 ┃  ┗ favorites_viewmodel.dart  # Favorites screen business logic
 ┣ ui/
 ┃  ┣ screens/
 ┃  ┃  ┣ list_screen.dart       # Home screen UI
 ┃  ┃  ┣ detail_screen.dart     # Detail screen UI
 ┃  ┃  ┗ favorites_screen.dart  # Favorites screen UI
 ┃  ┗ widgets/
 ┃     ┗ item_tile.dart         # Reusable product list item
 ┗ utils/
    ┗ network_info.dart         # Network connectivity checker
```

## 📦 Tech Stack

- **Flutter** (>=3.0)
- **State Management:** `flutter_riverpod` ^2.3.2
- **HTTP Client:** `dio` ^5.0.0
- **Local Database:** `drift` ^2.8.0 (SQLite)
- **Network Detection:** `connectivity_plus` ^4.0.0
- **JSON Serialization:** Manual (simple approach)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- An Android/iOS emulator or physical device

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd hoangtrungtin_se182892
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Drift database code**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔑 Key Implementation Details

### Offline-First Strategy

1. **On app launch:**

   - Check network connectivity
   - If online: Fetch from API → Cache to SQLite
   - If offline: Load from SQLite cache

2. **Data persistence:**
   - All products cached automatically
   - Favorites stored with `isFavorite` flag
   - Database survives app restarts

### MVVM with Riverpod

- **Models:** Plain Dart classes with JSON serialization
- **Views:** Stateful/Stateless widgets (UI only)
- **ViewModels:** StateNotifier classes managing business logic
- **Providers:** Global state management with Riverpod

### Search & Filter Implementation

- **Client-side filtering:** Efficient local data filtering
- **Dynamic categories:** Auto-extracted from fetched data
- **Real-time updates:** Immediate UI refresh on input

## 📱 Screens Preview

### 1. List Screen

- Search bar at the top
- Horizontal scrollable category chips
- Vertical scrollable product list
- Each item shows: image, title, category

### 2. Detail Screen

- Large product image
- Title, price, category chip
- Full description
- Toggle Favorite button with instant feedback

### 3. Favorites Screen

- Search bar for filtering favorites
- Category filter chips
- Same list layout as List Screen
- Empty state when no favorites

## 🗄️ Database Schema

**Items Table:**

```dart
- id: int (Primary Key)
- title: String
- price: double
- description: String
- category: String
- image: String (URL)
- isFavorite: bool (default: false)
```

## 🔧 Build Commands

### Generate database code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch mode (auto-regenerate on changes)

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Clean and rebuild

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 📝 Notes

- **API:** Uses Fake Store API (https://fakestoreapi.com/products)
- **No Authentication Required:** Public API
- **Error Handling:** Graceful fallback to cached data
- **Performance:** Efficient local filtering and caching
- **Real-time Updates:** Favorites sync across screens using Riverpod

## 👨‍💻 Developer

**Name:** Hoang Trung Tin  
**Student ID:** SE182892  
**Project:** Flutter MVVM Offline-First App

---

## 📄 License

This project is created for educational purposes.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
