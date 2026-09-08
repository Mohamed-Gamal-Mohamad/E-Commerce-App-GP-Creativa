# 🛒 StoreHub - E-Commerce Mobile Application

**StoreHub** is a modern E-Commerce mobile application built with **Flutter**.
The application provides a complete shopping experience, including authentication, product browsing, categories, product details, cart management, wishlist, order management, and user profile features.

The project is organized using a **Feature-First architecture** with **Cubit** for state management, **Firebase Authentication** for user authentication, and a remote product API for retrieving product data.

---

## 👥 Team Members & Contributors

| Member Name               | Student ID | Role              |
| :------------------------ | :--------- | :---------------- |
| **Mohamed Gamal Mohamed** | `F119`     | Flutter Developer |
| **Maher Maher Ali**       | `F87`      | Flutter Developer |

---

## ✨ Key Features

### 🔐 Authentication

* User registration using Firebase Authentication.
* User login using Firebase Authentication.
* Authentication state management using `AuthCubit`.
* Automatic detection of the currently authenticated user.
* Logout functionality.
* User information displayed throughout the application.

### 🚀 Splash & Onboarding

* Custom splash screen.
* Onboarding screen for first-time users.
* Onboarding status is stored locally.
* Automatic navigation based on authentication and onboarding state.

### 🏠 Home & Product Catalog

* Fetch products from a remote REST API.
* Display products in a modern and responsive UI.
* Search for products.
* Filter products by category.
* Promotional banner section.
* Reusable product cards.

### 📦 Product Details

* Display detailed product information.
* Product images.
* Product title and description.
* Product price and related information.
* Add products to the shopping cart.
* Add or remove products from the wishlist.

### 🛒 Shopping Cart

* Add products to the cart.
* Increase or decrease product quantity.
* Remove products from the cart.
* Automatically calculate the total price.
* Display the current cart contents.
* Proceed to checkout.

### ❤️ Wishlist

* Add products to the wishlist.
* Remove products from the wishlist.
* Display saved products in a dedicated wishlist screen.
* Wishlist state is managed using `WishlistCubit`.

### 📋 Orders

* Create an order from the current shopping cart.
* Store order information.
* Display order history.
* Manage orders using `OrderCubit`.

### 👤 Profile

* Display the authenticated user's information.
* Access order history.
* Manage application theme.
* Access shipping addresses.
* Access privacy policy.
* Access About Us.
* Access Contact Us.
* Logout from the application.

### 🌙 Theme Support

* Light mode.
* Dark mode.
* Theme state management using `ThemeCubit`.

---

## 🛠️ Technologies & Tools

| Technology                  | Usage                                         |
| :-------------------------- | :-------------------------------------------- |
| **Flutter**                 | Cross-platform mobile application development |
| **Dart**                    | Programming language                          |
| **Firebase Authentication** | User registration, login, and authentication  |
| **Firebase Core**           | Firebase initialization                       |
| **Flutter Bloc / Cubit**    | State management                              |
| **Dio**                     | HTTP requests and API communication           |
| **Shared Preferences**      | Local storage for application preferences     |
| **DummyJSON API**           | Remote product data                           |
| **Material Design**         | User interface components                     |

---

## 🏗️ Architecture

The project follows a **Feature-First Architecture**.

Each major application feature is organized into its own directory and contains its related business logic and UI.

The main structure is:

```text
lib/
│
├── app/
│   ├── app.dart
│   └── main_shell.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_text_styles.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── utils/
│   │   └── shared_prefs_helper.dart
│   │
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_widget.dart
│
├── data/
│   ├── models/
│   │   ├── cart_item_model.dart
│   │   ├── order_model.dart
│   │   └── product_model.dart
│   │
│   └── services/
│       └── product_service.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart
│   │   │   └── auth_state.dart
│   │   └── views/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   ├── onboarding/
│   │   └── views/
│   │       ├── splash_screen.dart
│   │       └── onboarding_screen.dart
│   │
│   ├── home/
│   │   ├── cubit/
│   │   │   ├── home_cubit.dart
│   │   │   └── home_state.dart
│   │   └── views/
│   │       ├── home_screen.dart
│   │       └── widgets/
│   │           ├── category_chip.dart
│   │           ├── product_card.dart
│   │           └── promo_banner.dart
│   │
│   ├── product/
│   │   ├── cubit/
│   │   │   ├── product_cubit.dart
│   │   │   └── product_state.dart
│   │   └── views/
│   │       ├── product_detail_screen.dart
│   │       └── manage_products_screen.dart
│   │
│   ├── cart/
│   │   ├── cubit/
│   │   │   ├── cart_cubit.dart
│   │   │   └── cart_state.dart
│   │   └── views/
│   │       └── cart_screen.dart
│   │
│   ├── wishlist/
│   │   ├── cubit/
│   │   │   ├── wishlist_cubit.dart
│   │   │   └── wishlist_state.dart
│   │   └── views/
│   │       └── wishlist_screen.dart
│   │
│   ├── orders/
│   │   ├── cubit/
│   │   │   ├── order_cubit.dart
│   │   │   └── order_state.dart
│   │
│   └── profile/
│       ├── cubit/
│       │   ├── theme_cubit.dart
│       │   └── theme_state.dart
│       │
│       └── views/
│           ├── profile_screen.dart
│           ├── order_history_screen.dart
│           ├── shipping_addresses_screen.dart
│           ├── privacy_policy_screen.dart
│           ├── about_us_screen.dart
│           └── contact_us_screen.dart
│
├── firebase_options.dart
└── main.dart
```

---

## 🔄 State Management

The application uses **Cubit from the `flutter_bloc` package** to manage application state.

Different Cubits are responsible for different features:

* `AuthCubit` → Authentication state.
* `HomeCubit` → Home screen and product loading/search functionality.
* `ProductCubit` → Product-related operations.
* `CartCubit` → Shopping cart state and operations.
* `WishlistCubit` → Wishlist state.
* `OrderCubit` → Order creation and order history.
* `ThemeCubit` → Light/Dark theme state.

This separation makes the application easier to maintain, test, and extend.

---

## 🌐 Data & API Layer

The application uses a dedicated service for communicating with the remote product API.

```text
UI
 ↓
Cubit
 ↓
ProductService
 ↓
REST API
 ↓
Product Model
 ↓
UI
```

The `ProductService` is responsible for retrieving product data from the remote API, while the product model is used to represent the received data inside the application.

---

## 🔥 Firebase Integration

Firebase is mainly used for authentication.

The authentication flow is:

```text
Register / Login Screen
          ↓
      AuthCubit
          ↓
   Firebase Authentication
          ↓
   Authentication Result
          ↓
       App State
```

Firebase is initialized when the application starts through `main.dart`.

---

## 💾 Local Storage

The application uses **Shared Preferences** for storing local application preferences.

It is mainly used to remember whether the user has completed the onboarding process.

```text
First App Launch
      ↓
 Onboarding
      ↓
Save Onboarding Status
      ↓
Next Launch
      ↓
Skip Onboarding
```

---

## 🎨 UI & Theme

The application contains reusable UI components and centralized styling.

Common UI components are located inside:

```text
lib/core/widgets/
```

Including:

* Custom Button
* Custom Text Field
* Loading Widget

Application colors, strings, text styles, and themes are also centralized inside the `core` directory.

---

## 📱 Application Flow

The general application flow is:

```text
Application Start
       ↓
     Splash
       ↓
Check Onboarding Status
       ↓
Check Authentication
       ↓
 ┌─────┴─────┐
 ↓           ↓
Login      Main App
 ↓
Register/Login
 ↓
Main App
       ↓
      Home
       ↓
 ┌─────┼─────┬──────┬───────┐
 ↓     ↓     ↓      ↓       ↓
Products Cart Wishlist Orders Profile
```

---



## 🚀 Future Improvements

Possible future improvements include:

* Online payment integration.
* Persistent cart and wishlist storage.
* Advanced product filtering and sorting.
* Improved search functionality.
* Push notifications.
* User profile editing.
* Real backend for products and orders.
* Product ratings and reviews.
* Admin dashboard.
* Better order tracking.

---

## 📌 Conclusion

**StoreHub** demonstrates the development of a modern Flutter E-Commerce application using a structured and maintainable architecture.

The project combines:

* Flutter & Dart
* Firebase Authentication
* REST API integration
* Dio
* Cubit / Flutter Bloc
* Shared Preferences
* Feature-First Architecture
* Reusable UI components

The application is designed to provide a clean shopping experience while keeping the codebase organized and easy to maintain and extend.
