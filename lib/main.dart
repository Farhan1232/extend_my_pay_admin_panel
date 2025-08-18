import 'package:extend_my_pay_admin_panel/Provider/bill_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/notification_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/notification_template_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/payment_charge_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/poster_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/profile_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/support_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/terms_policy_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/user_provider.dart';

import 'package:extend_my_pay_admin_panel/Screens/Bill/UserBillsListSelectorScreen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Main/Dashboard.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/NotificationListScreen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/NotificationTemplateScreen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/NotificationTemplateScreen_fetch_data.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/notification_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/payment_charge_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/poster_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/support_tickets_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Side_Menu/terms_policy_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/Users/profile_sample.dart';
import 'package:extend_my_pay_admin_panel/Screens/auth/admin_access_screen.dart';
import 'package:extend_my_pay_admin_panel/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/forget_password_screen.dart';
import 'Provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
        ChangeNotifierProvider(create: (_) => TermsPolicyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
        ChangeNotifierProvider(create: (_) => PaymentChargeProvider()),
        ChangeNotifierProvider(create: (_) => PosterProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => NotificationTemplateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Admin Panel',
          debugShowCheckedModeBanner: false,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: ClampingScrollWrapper.builder(context, child!),
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1200, name: DESKTOP),
              const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
            ],
          ),
      theme: ThemeData(primarySwatch: Colors.teal),





          initialRoute: '/login',
          routes: {
            '/login': (_) => const LoginScreen(),
            '/forget-password': (_) => const ForgetPasswordScreen(),
            '/dashboard': (_) => const AdminDashboardScreen(),
            '/admin-access': (_) => const AdminAccessScreen(),
            '/support': (_) => const SupportTicketsScreen(),
            '/terms-policy': (_) => const TermsPolicyScreen(),
            '/notifications': (_) => const NotificationScreen(),
            '/user-bills-selector': (_) => const UserBillsListSelectorScreen(),
            '/notification-templates': (_) => NotificationTemplateScreen(),
            '/payment-charge': (_) => const PaymentChargeScreen(),
            '/admin_notifications': (_) => const AdminNotificationsScreen(),
            '/profile_sample': (_) => const ProfileListScreen(),
            '/poster': (_) => const PosterScreen(),
            '/notification_sample_data': (_) => const NotificationTemplate_fetch_data_Screen(),
          },
        );
      },
    );
  }
}
