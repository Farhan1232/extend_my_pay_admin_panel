import 'package:extend_my_pay_admin_panel/Provider/AdminNotificationProvider.dart';
import 'package:extend_my_pay_admin_panel/Provider/bill_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/notification_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/notification_template_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/payment_charge_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/poster_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/profile_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/support_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/terms_policy_provider.dart';
import 'package:extend_my_pay_admin_panel/Provider/user_provider.dart';
import 'package:extend_my_pay_admin_panel/Screens/Dashboard.dart';
import 'package:extend_my_pay_admin_panel/Screens/NotificationListScreen.dart';
import 'package:extend_my_pay_admin_panel/Screens/NotificationTemplateScreen.dart';
import 'package:extend_my_pay_admin_panel/Screens/NotificationTemplateScreen_fetch_data.dart';
import 'package:extend_my_pay_admin_panel/Screens/UserBillsListSelectorScreen.dart';
import 'package:extend_my_pay_admin_panel/Screens/auth/admin_access_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/notification_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/payment_charge_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/poster_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/profile_sample.dart';
import 'package:extend_my_pay_admin_panel/Screens/support_tickets_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/terms_policy_screen.dart';
import 'package:extend_my_pay_admin_panel/Screens/user_list_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/forget_password_screen.dart';
import 'Provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyBrHgiKhSzpPTd968ZQA4mzW0bRib9Ml5A",
  authDomain: "extendmypay.firebaseapp.com",
  projectId: "extendmypay",
  storageBucket: "extendmypay.firebasestorage.app",
  messagingSenderId: "3583438611",
  appId: "1:3583438611:web:5eb872672e82226cd7f4e6",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
        ChangeNotifierProvider(create: (_) => TermsPolicyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider( create: (_) => BillProvider()),
        ChangeNotifierProvider(create: (_) => PaymentChargeProvider()),
        ChangeNotifierProvider(create: (_) => AdminNotificationProvider()),
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
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/forget-password': (_) => const ForgetPasswordScreen(),
        '/dashboard': (_) => const AdminDashboardScreen(),
        '/admin-access': (_) => const AdminAccessScreen(), 
        '/support': (_) => const SupportTicketsScreen(),
        '/terms-policy': (_) => const TermsPolicyScreen(),
        '/users': (_) => const UsersListScreen(),
        '/notifications': (context) => const NotificationScreen(),
        
        '/user-bills-selector': (context) => const UserBillsListSelectorScreen(),
        '/notification-templates': (context) => const NotificationTemplateScreen(),
        '/payment-charge': (context) => const PaymentChargeScreen(),
        '/admin_notifications': (context) => const AdminNotificationsScreen(),
        '/profile_sample': (context) => const ProfileListScreen(),
        '/poster' : (context) => const PosterScreen(),
        '/notification_sample_data' : (context) => const NotificationTemplate_fetch_data_Screen(),
        


      },
    );
  }
}
