# QuoteVault 🚀

A modern, full-featured quote discovery and collection app built with Flutter and Supabase.

## ✨ Features

### 🔐 Authentication & User Accounts
- **Sign up/Login:** Email and password authentication via Supabase.
- **Password Reset:** Complete flow for resetting forgotten passwords.
- **Session Persistence:** Users stay logged in across app restarts.
- **User Profile:** View and update display name, track statistics (favorites/collections).

### 📖 Quote Browsing & Discovery
- **Home Feed:** Prominent "Quote of the Day" and recent quotes.
- **Categorization:** Browse quotes across 5+ categories (Motivation, Love, Success, Wisdom, Humor).
- **Search:** Instant keyword search for quotes and authors.
- **Pull-to-Refresh:** Easily refresh the home feed and browse tabs.
- **Infinite Scrolling:** Paginated quote loading for a smooth experience.

### ❤️ Favorites & Collections
- **Favorites:** One-tap hearting to save quotes to your personal favorites.
- **Custom Collections:** Create themed collections (e.g., "Monday Morning", "Work Vibes").
- **Cloud Sync:** All favorites and collections are synced to Supabase and persist across devices.

### 🔔 Daily Quote & Notifications
- **Daily Inspiration:** Unique "Quote of the Day" every 24 hours.
- **Push Notifications:** Local notifications to remind you of your daily quote.
- **Customizable Time:** Set your preferred reminder time in settings.
- **Home Screen Widget:** (Android) View your daily quote directly from your home screen.

### 🎨 Personalization & Themes
- **Dark/Light Mode:** Full support for system and manual theme switching.
- **Multiple Themes:** Choose from 4 distinct accent colors (Orange, Nature Green, Ocean Blue, Minimal).
- **Adjustable Font Size:** Personalize your reading experience with dynamic font sizing.
- **Modern UI:** Built with **Google Fonts (Inter)**, glassmorphism, and staggered animations.

### 📤 Sharing & Export
- **Text Share:** Quick share via system share sheet.
- **Image Cards:** Generate beautiful, styled quote cards.
- **5 Unique Styles:** Modern, Nature, Ocean, Midnight, and Sunset card templates.

## 🛠️ Tech Stack
- **Framework:** [Flutter](https://flutter.dev/)
- **Backend:** [Supabase](https://supabase.com/) (Auth + Database + RLS)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
- **Local Storage:** [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Notifications:** [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Widget:** [home_widget](https://pub.dev/packages/home_widget)
- **UI Components:** Google Fonts, Staggered Animations, Screenshot.

## 🚀 Setup Instructions

### 1. Supabase Configuration
1. Create a new project at [Supabase](https://supabase.com/).
2. Run the SQL script found in `setup_database.sql` in the Supabase SQL Editor.
3. Enable Email Auth in your Supabase Auth settings.
4. (Optional) Set up deep linking for email confirmation (see `android/app/src/main/AndroidManifest.xml`).

### 2. App Configuration
1. Clone this repository.
2. Run `flutter pub get` to install dependencies.
3. Open `lib/constants/app_constants.dart` and replace `supabaseUrl` and `supabaseAnonKey` with your project's credentials.

### 3. Run the App
- Android/iOS: `flutter run`
- Web (limited support for notifications/widgets): `flutter run -d chrome`

## 🤖 AI Workflow & Proficiency
This project was built primarily leveraging AI tools to accelerate development while maintaining high code quality.

### Tools Used:
- **OpenCode:** Used as the primary architect and lead developer for scaffolding, logic implementation, and complex refactoring.
- **Grep/Glob Tools:** Used extensively for codebase exploration and ensuring architectural consistency.
- **UI Redesign:** Leveraged AI to upgrade the UI from standard Material to a bespoke, minimalistic aesthetic with animations.

### Key AI Techniques:
- **Component-Driven Development:** Prompted the AI to create modular, reusable widgets (e.g., `QuoteCard`, `CustomTextField`).
- **Safety-First Iteration:** Used AI to analyze error logs (like `setState during build`) and suggest robust fixes like `addPostFrameCallback`.
- **Backend Orchestration:** Leveraged AI to design the Supabase schema and RLS policies for secure data access.

---
Built with ❤️ and AI for the Mobile Application Developer Assignment.