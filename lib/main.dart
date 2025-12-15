import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app/themes/app_theme.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
                final departmentId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return DoctorsScreen(departmentId: departmentId);
              },
              '/appointments': (context) => const AppointmentsScreen(),
              '/book-appointment': (context) {
                final args =
                    ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                return BookAppointmentScreen(
                  doctorId: args['doctorId'] as String,
                  departmentId: args['departmentId'] as String,
                );
              },
              '/profile': (context) => const ProfileScreen(),
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
