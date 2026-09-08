# 🛒 StoreHub - Modern E-Commerce Mobile Application

**StoreHub** is a feature-rich, modern E-commerce mobile application developed using **Flutter**. The app follows the **MVVM architecture** with **Cubit (flutter_bloc)** for robust state management and integrates **Firebase Authentication** alongside RESTful APIs.

---

## 👥 Team Members & Contributors

| Member Name | Student ID | Role |
| :--- | :--- | :--- |
| **Mohamed Gamal Mohamed** | `F119` | Mobile App Developer |
| **Maher Maher Ali** | `F87` | Mobile App Developer |

---

## ✨ Key Features

- **🔐 Firebase Authentication:** Full Sign-Up and Sign-In flow with input validation, persistent login sessions via `shared_preferences`, and profile name integration.
- **📱 Splash & Onboarding:** Custom animated splash screen with app branding and single-launch onboarding flow.
- **🎨 UI & Theme Support:** Modern UI design matching StoreHub aesthetics with dynamic Light and Dark mode switching.
- **🛍️ Product Catalog:** Fetching and displaying products dynamically from [DummyJSON API](https://dummyjson.com/products).
- **🏷️ Category Filtering:** Seamless product filtering based on selected categories.
- **⭐ Product Details & Reviews:** Detailed product view including images, pricing, descriptions, and user reviews.
- **🛒 Cart Management:** Real-time quantity increment/decrement, dynamic total price calculation, and item removal powered by Cubit.
- **📦 Checkout & Order System:** "Proceed to Checkout" flow converting cart items into placed orders tracked under the "My Orders" section.
- **👤 Profile Management:** Displays registered user details, theme preferences, and app navigation (Privacy Policy, About Us, Contact Us, Logout).

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Architecture:** MVVM (Model-View-ViewModel)
- **State Management:** `flutter_bloc` (Cubit)
- **Backend & Auth:** [Firebase Authentication](https://firebase.google.com/)
- **REST API:** [DummyJSON API](https://dummyjson.com/)
- **Local Storage:** `shared_preferences`
- **Networking:** `dio` / `http`
- **Icon Generation:** `flutter_launcher_icons`

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   └── services/
├── logic/
│   ├── auth_cubit/
│   ├── cart_cubit/
│   ├── order_cubit/
│   └── product_cubit/
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   ├── cart/
│   │   ├── home/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   └── splash/
│   └── widgets/
└── main.dart