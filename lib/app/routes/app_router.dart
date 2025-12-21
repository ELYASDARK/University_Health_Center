import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/departments/presentation/screens/departments_screen.dart';
import '../../features/doctors/presentation/screens/doctors_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/appointments/presentation/screens/book_appointment_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// Application routing configuration
class AppRouter {
  static GoRouter router({required bool isAuthenticated}) {
    return GoRouter(
      initialLocation: isAuthenticated ? '/home' : '/login',
      redirect: (context, state) {
        final isLoginRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/forgot-password';

        // If not authenticated and trying to access protected route, redirect to login
        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }

        // If authenticated and trying to access login routes, redirect to home
        if (isAuthenticated && isLoginRoute) {
          return '/home';
        }

        return null;
      },
      routes: [
        // Auth routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Main app routes
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/departments',
          builder: (context, state) => const DepartmentsScreen(),
        ),
        GoRoute(
          path: '/doctors',
          builder: (context, state) {
            final departmentId = state.extra as String;
            return DoctorsScreen(departmentId: departmentId);
          },
        ),
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const AppointmentsScreen(),
        ),
        GoRoute(
          path: '/book-appointment',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            return BookAppointmentScreen(
              doctorId: args['doctorId'] as String,
              departmentId: args['departmentId'] as String,
            );
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}
