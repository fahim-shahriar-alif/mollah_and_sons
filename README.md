# Mollah And Sons - Fertilizer Ordering App

A modern, feature-rich Flutter mobile application designed for agricultural businesses to streamline fertilizer ordering and management. Built with Firebase backend integration and beautiful animations for an enhanced user experience.

## 🌱 About

Mollah And Sons is a comprehensive fertilizer ordering platform that connects farmers and agricultural businesses with quality fertilizers. The app provides a seamless experience for browsing products, placing orders, and managing agricultural supply needs.

## ✨ Features

### Customer Features
- **User Authentication**: Secure login/signup with Firebase Auth
- **Product Catalog**: Browse fertilizers by categories (Chemical, Organic, Micronutrients)
- **Search & Filter**: Find products quickly with advanced search
- **Shopping Cart**: Add/remove items with real-time cart management
- **Order Management**: Place orders and track order history
- **Profile Management**: Update personal and shop information
- **Multi-language Support**: English and Bengali localization
- **Responsive Design**: Optimized for various screen sizes

### Admin Features
- **Product Management**: Add new fertilizer products to the catalog
- **Real-time Updates**: Products sync instantly across all users
- **Firebase Integration**: Secure cloud-based data management

### UI/UX Features
- **Modern Design**: Material Design 3 with agricultural green theme
- **Smooth Animations**: Dynamic animations and visual effects
- **Intuitive Navigation**: Bottom navigation with clear iconography
- **Loading States**: Professional loading indicators and feedback

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication)
- **State Management**: Provider pattern
- **Localization**: Custom localization system (English/Bengali)
- **Architecture**: Clean architecture with service layer
- **Animations**: Custom animations with TickerProviderStateMixin

## 📱 App Structure

```
lib/
├── l10n/                     # Localization files
├── models/                   # Data models
│   ├── cart_item.dart
│   ├── order_model.dart
│   ├── product_model.dart
│   └── user_model.dart
├── screens/                  # UI screens
│   ├── admin_add_product_screen.dart
│   ├── cart_screen.dart
│   ├── change_password_screen.dart
│   ├── dashboard_screen.dart
│   ├── login_screen.dart
│   ├── order_history_screen.dart
│   ├── profile_screen.dart
│   └── signup_screen.dart
├── services/                 # Business logic
│   ├── cart_service.dart
│   ├── firebase_auth_service.dart
│   ├── firebase_cart_service.dart
│   ├── order_service.dart
│   └── product_service.dart
├── widgets/                  # Reusable components
└── main.dart                # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mollah_and_sons
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Add Firebase configuration files**
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Setup
1. Create a new Firebase project
2. Enable Authentication (Email/Password)
3. Create Firestore database
4. Add your app's package name: `com.example.alif.mollah_and_sons`
5. Download and add configuration files

### Database Structure
```
users/
  {userId}/
    - name: string
    - email: string
    - shopName: string
    - phone: string
    - location: string
    - orders/
      {orderId}/
        - items: array
        - totalAmount: number
        - timestamp: timestamp
        - status: string

products/
  {productId}/
    - name: string
    - description: string
    - price: number
    - category: string
    - unit: string
    - stockQuantity: number
    - imageUrl: string
```

## 🎨 Design System

- **Primary Color**: Agricultural Green (#2E7D32)
- **Secondary Colors**: Various green shades for depth
- **Typography**: Material Design typography scale
- **Icons**: Material Design icons with custom agricultural icons
- **Animations**: Smooth transitions and micro-interactions

## 📦 Dependencies

Key packages used:
- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - Database operations
- `provider` - State management
- `flutter_localizations` - Internationalization

## 🌍 Localization

The app supports:
- **English** (default)
- **Bengali** (বাংলা)

Language can be switched using the toggle button in the app header.

## 🚀 Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is proprietary software developed for Mollah And Sons.

## 📞 Support

For support and inquiries, please contact the development team.

---

**Built with ❤️ for the agricultural community**
