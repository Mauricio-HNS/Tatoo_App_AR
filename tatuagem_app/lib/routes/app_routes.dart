import 'package:flutter/material.dart';

import '../presentation/screens/home_page.dart';
import '../presentation/screens/login_page.dart';
import '../presentation/screens/signup_page.dart';

class AppRoutesWidget extends StatelessWidget {
  const AppRoutesWidget({super.key});

  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String tattoos = '/tattoos';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    // Use HomePage as a safe placeholder if specific pages are unavailable.
    tattoos: (context) => const HomePage(),
    profile: (context) => const HomePage(),
    settings: (context) => const HomePage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(settings: settings, builder: builder);
    }

    // Fallback: route to HomePage if unknown
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tattoo App',
      initialRoute: home,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
