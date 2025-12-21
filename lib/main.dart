import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app/themes/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/waitlist_cleanup_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/departments/presentation/providers/department_provider.dart';
import 'features/doctors/presentation/providers/doctor_provider.dart';
import 'features/appointments/presentation/providers/appointment_provider.dart';
import 'features/appointments/presentation/providers/waitlist_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/departments/presentation/screens/departments_screen.dart';
import 'features/doctors/presentation/screens/doctors_screen.dart';
import 'features/appointments/presentation/screens/appointments_screen.dart';
import 'features/appointments/presentation/screens/book_appointment_screen.dart';
import 'features/appointments/presentation/screens/appointment_details_screen.dart';
import 'features/appointments/presentation/screens/reschedule_appointment_screen.dart';
import 'features/appointments/presentation/pages/waitlist_page.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';
import 'features/admin/presentation/pages/admin_dashboard_page.dart';
import 'features/admin/presentation/pages/manage_doctors_page.dart';
import 'features/admin/presentation/pages/add_doctor_page.dart';
import 'features/admin/presentation/pages/edit_doctor_page.dart';
import 'features/admin/presentation/pages/manage_departments_page.dart';
import 'features/admin/presentation/pages/add_department_page.dart';
import 'features/admin/presentation/pages/edit_department_page.dart';
import 'features/admin/presentation/pages/appointments_overview_page.dart';
import 'features/admin/presentation/pages/analytics_page.dart';
import 'features/notifications/presentation/pages/notification_settings_page.dart';
import 'features/profile/presentation/pages/medical_history_page.dart';
import 'features/reviews/presentation/pages/doctor_reviews_page.dart';
import 'features/profile/presentation/pages/accessibility_settings_page.dart';
import 'shared/models/appointment_model.dart';
import 'shared/models/doctor_model.dart';
import 'shared/models/department_model.dart';
import 'core/constants/app_constants.dart';

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

  // Start waitlist cleanup service
  try {
    WaitlistCleanupService().startCleanupService();
  } catch (e) {
    debugPrint('Error starting waitlist cleanup service: $e');
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
        ChangeNotifierProvider(create: (_) => WaitlistProvider()),
        ChangeNotifierProvider(
          create: (_) => AccessibilityProvider()..loadSettings(),
        ),
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
              '/appointment-details': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args == null || args is! AppointmentModel) {
                  return const AppointmentsScreen();
                }
                return AppointmentDetailsScreen(appointment: args);
              },
              '/reschedule-appointment': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args == null || args is! AppointmentModel) {
                  return const AppointmentsScreen();
                }
                return RescheduleAppointmentScreen(appointment: args);
              },
              '/waitlist': (context) => const WaitlistPage(),
              '/doctor-reviews': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args == null || args is! DoctorModel) {
                  return const HomeScreen();
                }
                return DoctorReviewsPage(doctor: args);
              },
              '/admin/manage-doctors': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const ManageDoctorsPage();
                } else {
                  return const HomeScreen();
                }
              },
              '/admin/add-doctor': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const AddDoctorPage();
                } else {
                  return const HomeScreen();
                }
              },
              '/admin/edit-doctor': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  if (args == null || args is! DoctorModel) {
                    return const ManageDoctorsPage();
                  }
                  return EditDoctorPage(doctor: args);
                } else {
                  return const HomeScreen();
                }
              },
              '/admin/manage-departments': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const ManageDepartmentsPage();
                } else {
                  return const HomeScreen();
                }
              },
              '/admin/add-department': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const AddDepartmentPage();
                } else {
                  return const HomeScreen();
                }
              },
              '/admin/edit-department': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  if (args == null || args is! DepartmentModel) {
                    return const ManageDepartmentsPage();
                  }
                  return EditDepartmentPage(department: args);
                } else {
                  return const HomeScreen();
                }
              },
              '/admin': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                // Check if user is admin
                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const AdminDashboardPage();
                } else {
                  // Unauthorized access - redirect to home
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Access denied. Admin privileges required.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  });
                  return const HomeScreen();
                }
              },
              '/admin/appointments': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const AppointmentsOverviewPage();
                } else {
                  return const HomeScreen();
                }
              },
              '/admin/analytics': (context) {
                // Role-based access control
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final user = authProvider.currentUser;

                if (user != null && user.role == AppConstants.roleAdmin) {
                  return const AnalyticsPage();
                } else {
                  return const HomeScreen();
                }
              },
              '/notification-settings': (context) =>
                  const NotificationSettingsPage(),
              '/medical-history': (context) => const MedicalHistoryPage(),
              '/accessibility-settings': (context) =>
                  const AccessibilitySettingsPage(),
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
