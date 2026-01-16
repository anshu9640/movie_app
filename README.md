# 🎬 Movie App

A Flutter-based Movie Browsing App that allows users to explore trending movies, view details, mark favourites, and manage a personal watchlist.  
The app uses **The Movie Database (TMDB) API** to fetch real-time movie data.

---

## 📱 Download APK
You can download and test the app here:

➡️ [Download Movie App APK](./apk/movie_app_v1.0.apk)

---

## 🚀 Features

- Beautiful splash screen → home page navigation  
- Bottom Navigation Bar with three tabs:
  - 🎥 **Movies** — Browse, search, and explore all movies
  - ❤️ **Favourites** — User’s liked movies
  - ⏰ **Watchlist** — Movies to watch later
- Integrated **TMDB API** for real-time movie data
- Movie detail screen with:
  - Poster
  - Name
  - Genre
  - Description
  - Release date
  - Circular user rating indicator
  - “Play Now” button with in-app notification
- Search functionality
- State management using **Provider**
- Persistent favourites & watchlist (unique for each user)
- Smooth UI and responsive grid layout

---

## 🛠️ Setup Instructions

### 1️⃣ Prerequisites
Ensure you have the following installed on your system:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code with Flutter plugin
- Git
- An emulator or a physical Android device

---

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/<your-repo-name>.git
cd movie_app
