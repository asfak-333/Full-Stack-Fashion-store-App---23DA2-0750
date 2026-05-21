import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fashion_app/core/theme.dart';
import 'package:fashion_app/widgets/main_scaffold.dart';

import 'package:fashion_app/providers/auth_provider.dart';
import 'package:fashion_app/providers/product_provider.dart';
import 'package:fashion_app/providers/cart_provider.dart';
import 'package:fashion_app/providers/address_provider.dart';
import 'package:fashion_app/providers/order_provider.dart';

import 'package:fashion_app/screens/cart_screen.dart';
import 'package:fashion_app/screens/checkout_screen.dart';
import 'package:fashion_app/screens/home_screen.dart';
import 'package:fashion_app/screens/orders_screen.dart';
import 'package:fashion_app/screens/product_details_screen.dart';
import 'package:fashion_app/screens/profile_screen.dart';
import 'package:fashion_app/screens/shop_screen.dart';
import 'package:fashion_app/screens/sign_in_screen.dart';
import 'package:fashion_app/screens/sign_up_screen.dart';
import 'package:fashion_app/screens/splash_screen.dart';
import 'package:fashion_app/screens/personal_details_screen.dart';
import 'package:fashion_app/screens/payment_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    _router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        if (authProvider.isLoading) return null;

        final isAuthenticated = authProvider.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/signin' || state.matchedLocation == '/signup';
        final isSplashRoute = state.matchedLocation == '/splash';
        final isProtectedRoute = state.matchedLocation == '/profile' || 
                                 state.matchedLocation == '/orders' ||
                                 state.matchedLocation == '/checkout' ||
                                 state.matchedLocation == '/personal-details' ||
                                 state.matchedLocation == '/payment-details';

        if (isSplashRoute) return null;

        if (!isAuthenticated && isProtectedRoute) {
          return '/signin';
        }
        if (isAuthenticated && isLoginRoute) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
            GoRoute(
              path: '/shop',
              builder: (context, state) {
                final category = state.uri.queryParameters['category'];
                return ShopScreen(initialCategory: category);
              },
            ),
            GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) => ProductDetailsScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: '/personal-details',
          builder: (context, state) => const PersonalDetailsScreen(),
        ),
        GoRoute(
          path: '/payment-details',
          builder: (context, state) => const PaymentDetailsScreen(),
        ),
        GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
        GoRoute(path: '/signin', builder: (context, state) => const SignInScreen()),
        GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Satin & Stone',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
