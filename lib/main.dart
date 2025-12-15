import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app/themes/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/departments/presentation/providers/department_provider.dart';
import 'features/doctors/presentation/providers/doctor_provider.dart';
import 'features/appointments/presentation/providers/appointment_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/departments/presentation/screens/departments_screen.dart';
import 'features/doctors/presentation/screens/doctors_screen.dart';
import 'features/appointments/presentation/screens/appointments_screen.dart';
import 'features/appointments/presentation/screens/book_appointment_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable offline persistence
  try {
    await FirebaseService().enableOfflinePersistence();
  } catch (e) {
    debugPrint('Error enabling offline persistence: $e');
  }

  // Initialize notification service
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Error initializing notifications: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'University Health Center',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,

            // Custom error widget builder
            builder: (context, widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Something went wrong',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please restart the app',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              };
              return widget ?? const SizedBox.shrink();
            },

            // Initial route based on auth state
            initialRoute: authProvider.isAuthenticated ? '/home' : '/login',

            // Route configuration
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/home': (context) => const HomeScreen(),
              '/departments': (context) => const DepartmentsScreen(),
              '/doctors': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args == null || args is! String) {
                  // Safe fallback - return to departments
                  return const DepartmentsScreen();
                }
                return DoctorsScreen(departmentId: args);
              },
              '/appointments': (context) => const AppointmentsScreen(),
              '/book-appointment': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args == null || args is! Map<String, dynamic>) {
                  // Safe fallback - return to departments
                  return const DepartmentsScreen();
                }
                final doctorId = args['doctorId'];
                final departmentId = args['departmentId'];
                if (doctorId == null || departmentId == null) {
                  return const DepartmentsScreen();
                }
                return BookAppointmentScreen(
                  doctorId: doctorId as String,
                  departmentId: departmentId as String,
                );
              },
              '/profile': (context) => const ProfileScreen(),
              '/notifications': (context) => const NotificationsScreen(),
            },

            // Handle unknown routes
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
