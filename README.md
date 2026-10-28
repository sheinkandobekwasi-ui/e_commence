# Shei Store - Mobile & Web E-Commerce Application

A fully functioning Flutter & Dart e-commerce mobile application built for a university coursework project. The app is ready to run directly in Android Studio or VS Code on Android Emulators, iOS Simulators, Physical Devices, or Web/Desktop.

---

## 📱 Project Architecture & Folder Structure

```
lib/
├── main.dart                          # Root MaterialApp, Named Routes, Material 3 Theme
├── models/
│   ├── product.dart                   # Product model (specifications, durability, functionality, GH₵ price)
│   ├── cart_item.dart                 # CartItem model (product, quantity, line total)
│   └── user_profile.dart              # User profile session model
├── data/
│   ├── mock_data.dart                 # 36 sample products, 6 categories, 19 local assets, promo banners
│   ├── cart_service.dart              # Reactive Singleton Cart & Session state (ChangeNotifier)
│   ├── product_service.dart           # Reactive Local Product Catalog & Persistence (SharedPreferences)
│   └── wishlist_service.dart          # Reactive Local Wishlist state & Persistence (SharedPreferences)
├── services/
│   ├── admin_service.dart             # Admin session and authorization management
│   ├── firebase_service.dart          # Hybrid Firestore text storage (orders & support tickets)
│   └── order_notification_service.dart# Real-time customer order alerts & status notifications
├── widgets/
│   ├── account_helpdesk_card.dart     # 24/7 LIVE Support card with WhatsApp & Hotline url_launcher links
│   ├── app_image.dart                 # Uncropped dynamic image loader (local assets, device files, base64)
│   ├── product_card.dart              # Product grid card with wishlist heart, rating, GH₵ price & quick-add
│   ├── category_chip.dart             # Selectable animated category filter chip
│   ├── promo_banner.dart              # Gradient promotional banner with rounded containers
│   ├── custom_button.dart             # Material 3 reusable styled button with loading state
│   └── custom_text_field.dart         # Form input field with border styles & validation support
└── screens/
    ├── login_screen.dart              # Authentication with email/password form validation
    ├── registration_screen.dart       # Account creation with matching password validation
    ├── main_screen.dart               # Jumia-style 5-tab NavigationBar (Home, Categories, Cart, Wishlist, Account)
    ├── home_screen.dart               # Search, hotline bar, promo carousel, flash sale countdown, 2-column grid
    ├── categories_screen.dart         # 6 coursework categories with toggleable GridView / ListView
    ├── product_details_screen.dart    # Receives Product via route arguments, specs, durability & cart actions
    ├── cart_screen.dart               # StatefulWidget shopping cart with real-time GH₵ calculations
    ├── wishlist_screen.dart           # Liked items view with direct "Move to Cart" actions
    ├── checkout_screen.dart           # Ghana 16 regions dropdown, Sunyani GPS mapping & Cedis payments
    ├── order_confirmation_screen.dart # Invoice summary, delivery confirmation & order notification banner
    ├── profile_screen.dart            # User profile details, Admin Portal shortcut, helpdesk card & logout
    ├── admin_login_screen.dart        # Authorized administrator login portal
    ├── admin_dashboard_screen.dart    # Product inventory management, real-time order alerts & order review
    └── admin_product_form_screen.dart # Pre-populated product edit & new product creation form
```

---

## 🎓 Lecturer's Required Concepts Checklist

| Lecturer Concept | Implementation Location | Explanation for Student Defense |
|---|---|---|
| **MaterialApp** | `lib/main.dart` | The root widget configuring the application title, theme colors, and named routes table. |
| **Scaffold** | All screens in `lib/screens/` | Provides standard visual layout structure: top `appBar`, content `body`, and `bottomNavigationBar`. |
| **AppBar** | `HomeScreen`, `CategoriesScreen`, `ProductDetailsScreen`, etc. | Displays screen titles, back buttons, and interactive cart badge action icons. |
| **NavigationBar** | `lib/screens/main_screen.dart` | Material 3 navigation bar with 4 destinations: Home, Categories, Cart (with badge), and Profile. |
| **Container** | Used across cards, banners, chips | Provides box styling, rounded borders (`BorderRadius.circular`), shadows, gradients, and padding. |
| **StatelessWidget** | `ProductCard`, `PromoBanner`, `CategoryChip`, `CustomButton` | Used for immutable UI components whose presentation depends entirely on input parameters. |
| **StatefulWidget** | `MainScreen`, `CartScreen`, `CheckoutScreen`, `LoginScreen`, etc. | Used when the screen state needs to mutate dynamically (e.g. cart quantity, tabs, form fields). |
| **Widget** | Typed return throughout all `build()` methods | The foundational building block of the entire Flutter UI hierarchy. |
| **child & children** | Single-child (`Container`, `SizedBox`) & multi-child (`Column`, `Row`, `ListView`, `GridView`) | Defines hierarchy: `child` takes a single widget; `children` takes an array of widgets. |
| **body** | Inside every `Scaffold` | The primary content area occupying the viewport beneath the `AppBar`. |
| **SizedBox** | Used for layout spacing | Provides fixed-size gaps (`SizedBox(height: 16)`) and constraint boxes. |
| **ListView** | `HomeScreen`, `CategoriesScreen`, `CartScreen` | Renders scrollable linear lists (horizontal promo banners, category chips, vertical cart items). |
| **GridView** | `HomeScreen`, `CategoriesScreen` | 2-column responsive product layout using `SliverGridDelegateWithFixedCrossAxisCount`. |
| **Page navigation** | `Navigator.pushNamed`, `Navigator.pop` | Declarative routing between Login, Register, Main, Details, Cart, Checkout, and Confirmation. |
| **Form validation** | `LoginScreen`, `RegistrationScreen`, `CheckoutScreen` | Uses `GlobalKey<FormState>()`, `Form`, `TextFormField`, and `validator: (value) => ...`. |
| **Arguments** | `ProductDetailsScreen`, `OrderConfirmationScreen` | Passed via `Navigator.pushNamed(context, '/product-details', arguments: product)` and extracted via `ModalRoute.of(context)!.settings.arguments`. |

---

## 🛒 Complete Navigation Flow

```mermaid
flowchart LR
    Login[Login Screen] --> Register[Registration Screen]
    Login --> Main[Main Screen / Home]
    Register --> Main
    Main --> Details[Product Details]
    Details --> Cart[Shopping Cart]
    Main --> Cart
    Cart --> Checkout[Checkout Form]
    Checkout --> Confirmation[Order Confirmation]
    Confirmation --> Main
```

---

## 🚀 How to Run the Application

### 1. In Android Studio:
1. Open Android Studio.
2. Select **Open** and choose the `e_commence_app` folder.
3. Allow Gradle and Flutter to sync.
4. Select your target device (Android Emulator or physical device).
5. Click the green **Run (▶)** button or press `Shift + F10`.

### 2. From the Terminal / Command Prompt:
```bash
# Verify dependencies
flutter pub get

# Run static analysis (Verifies 0 issues)
flutter analyze

# Run test suite
flutter test

# Launch the app
flutter run
```

---

## 💡 Demo Credentials (Quick Grading)
- **Customer Email**: `shei.customer@university.edu`
- **Customer Password**: `password123`
- **Admin Email**: `admin@sheistore.com`
- **Admin Password**: `admin123`
- *Alternatively, click the **"Continue as Guest"** button on the Login screen to immediately explore the shop.*
