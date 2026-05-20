# Project Report: HistoriX – Flutter Mobile Application

**Course:** Mobile Application Development  
**Student:** [Your Name]  
**Date:** [Submission Date]

---

## 1. Introduction

HistoriX is a cross-platform mobile application for browsing, purchasing, and reading history books. Originally developed as a React web application, the project has been fully converted to Flutter, Google’s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. The app demonstrates core mobile development concepts: navigation, state management, local storage, responsive UI, and integration of third-party libraries.

---

## 2. App Overview and Features

The application provides a digital bookstore experience centred on history literature. It includes:

- **User Authentication** – Login, registration, and guest access with role-based routing (user / admin / guest).
- **Book Browsing** – A home screen with featured books (horizontal scroll), category filters (chips), and a search bar.
- **Book Details** – Dedicated screen showing cover image, description, metadata, price, rating, and an animated "Add to Cart" button.
- **Shopping Cart** – Full cart management: quantity adjustment, item removal, subtotal, tax, and total calculation.
- **Checkout** – Multi-step form (shipping → payment → review) with validation.
- **Personal Library** – Displays owned books with a “currently reading” progress bar and a basic digital reader preview.
- **Admin Dashboard** – Statistics overview, book list, and user management tabs.
- **Responsive UI** – Custom theme with a luxurious colour palette (navy blue, gold) and adaptive layouts for different screen sizes.

---

## 3. Technical Architecture

### 3.1 Framework & Language
- **Flutter 3.x** (Dart) – Single codebase for Android and iOS.

### 3.2 State Management
- **Provider** – Used for cart state (`CartProvider`), enabling reactive updates across screens.

### 3.3 Navigation & Routing
- **GoRouter** – Declarative routing with redirect guards for authentication.
- Routes: `/login`, `/`, `/book/:id`, `/cart`, `/checkout`, `/library`, `/admin`.
- Protected routes redirect to `/login` if no user role is found in local storage.

### 3.4 Local Persistence
- **SharedPreferences** – Stores user authentication role and email, and the cart contents (serialised as JSON).

### 3.5 UI Components
- **Material Design 3** with custom theming (`ThemeData`).
- **Custom widgets:** `BookCard`, `RatingWidget`, `ImageWithFallback`, `CustomButton`, `CustomInput`, `BottomNav`.
- **Animations:** `AnimatedSwitcher` for tab/content transitions, `TweenAnimationBuilder` for cart feedback, fade-in on login.

### 3.6 Dependency Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.9
  go_router: ^17.2.3
  shared_preferences: ^2.5.5
  provider: ^6.1.5+1

## 4. Code Structure and Key Files
ib/
├── main.dart # App entry, GoRouter config, Provider setup
├── theme.dart # Custom colour palette and typography
├── models/
│ ├── book.dart # Book data model
│ └── cart_item.dart # Cart item with quantity
├── data/
│ └── books_data.dart # Static dataset (6 books) and category list
├── services/
│ └── storage_service.dart # Encapsulates SharedPreferences read/write
├── providers/
│ └── cart_provider.dart # Cart state and logic
├── screens/
│ ├── login_screen.dart # Auth UI with sign‑up toggle and admin checkbox
│ ├── home_screen.dart # Featured books, categories, search, grid
│ ├── book_details_screen.dart # Detail view, add‑to‑cart animation
│ ├── cart_screen.dart # Cart list, quantity controls, totals
│ ├── checkout_screen.dart # 3‑step checkout form
│ ├── library_screen.dart # User’s library and reader preview
│ └── admin_screen.dart # Admin overview, book/user lists
└── widgets/
├── book_card.dart # Reusable card (vertical/horizontal layout)
├── rating_widget.dart # Star rating with numeric display
├── bottom_nav.dart # Bottom navigation bar with role‑aware actions
├── image_with_fallback.dart # Network image with error placeholder
├── custom_button.dart # Styled button with variants
└── custom_input.dart # Form field with show/hide password


## 5. User Authentication & Role Management

- User roles: `admin`, `user`, `guest`.
- On login, the role is saved to `SharedPreferences` (synchronous cache for instant redirect checks).
- `GoRouter`’s `redirect` callback reads the cached role and redirects unauthenticated users to `/login`.
- The admin checkbox on the login screen sets the role to `admin`, granting access to the `/admin` route.
- Logout clears stored credentials and navigates back to login.

---

## 6. Cart System & Local Persistence

- `CartProvider` (ChangeNotifier) holds a list of `CartItem` objects.
- Methods: `addToCart`, `updateQuantity`, `removeItem`, `clearCart`, `loadCart`.
- On every change, the cart is serialised (including full book data) and saved to `SharedPreferences` as a JSON string.
- On app start, `loadCart` reads from storage and populates the provider.
- This ensures cart survives app restarts and remains consistent across screens.

---

## 7. UI/UX Design Decisions

- **Colour Scheme:** Navy blue (`#1A2A44`) as primary, gold (`#D4AF37`) as accent – conveys sophistication appropriate for a history book store.
- **Typography:** `Playfair Display` for headings, `Inter` for body – readable and classic.
- **Responsive Layouts:** `CustomScrollView` with `SliverGrid` and `SliverToBoxAdapter` adapts to various screen sizes without overflow.
- **Animations:** Subtle fade-in, slide, and scale animations using `TweenAnimationBuilder` and `AnimatedSwitcher` for a polished feel.
- **Error Handling:** `ImageWithFallback` shows a broken-image icon if the cover fails to load; missing book displays a “not found” message.

---

## 8. Challenges and Solutions

| Challenge | Solution |
|-----------|----------|
| **RenderFlex overflow in horizontal featured list** | Increased the `SizedBox` height from 280 to 340 to accommodate the `BookCard` internal vertical layout. |
| **Overflow in 2‑column grid** | Adjusted `childAspectRatio` from 0.65 to 0.55 to give more vertical space for image + text. |
| **Asynchronous role check for route guard** | Cached the user role synchronously in `StorageService` so `GoRouter`’s `redirect` can work without `await`. |
| **Cart serialisation** | Stored full book data in JSON to avoid re‑fetching; deserialised using the `Book` model in `loadCart`. |
| **State synchronisation** | Used `Provider` to listen to cart changes, ensuring multiple screens (cart icon badge, cart total) stay in sync. |
| **Emulator broken pipe error** | Cold‑booted emulator and restarted ADB – a typical development environment issue, not a code bug. |

---

## 9. Testing

- A basic widget test (`widget_test.dart`) verifies that the login screen renders with the app title and “Welcome Back” text.
- Manual testing was performed on an Android emulator (x86_64, API 33+). All main flows (login, browse, add to cart, checkout, library, admin) function as expected.

---

## 10. Conclusion

HistoriX successfully demonstrates the conversion of a React web application into a fully functional Flutter mobile app. The project applies core mobile development principles: declarative navigation, state management with Provider, persistent local storage, and a custom theme for a professional look. The app is extendable – additional features like real backend integration, payment gateways, and push notifications can be added without restructuring the architecture. This project has strengthened my understanding of Flutter’s widget tree, reactive state, and cross‑platform development.