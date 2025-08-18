import 'package:extend_my_pay_admin_panel/Controller/auth_controller.dart';
import 'package:extend_my_pay_admin_panel/Provider/auth_provider.dart';
import 'package:extend_my_pay_admin_panel/Screens/Main/Dashboard.dart';
import 'package:extend_my_pay_admin_panel/Screens/auth/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxWidth: 500.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF941A),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.h),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.email, color: Color(0xFFFF941A)),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 15.h),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFFF941A)),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 25.h),

                Selector<AppAuthProvider, bool>(
                  selector: (_, provider) => provider.user != null,
                  builder: (_, __, ___) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF941A),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final provider = context.read<AppAuthProvider>();
                          final success = await AuthController().loginAdmin(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            provider,
                          );

                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminDashboardScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login failed! Not authorized.")),
                            );
                          }
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    );
                  },
                ),

                SizedBox(height: 15.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgetPasswordScreen()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFFFF941A)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
