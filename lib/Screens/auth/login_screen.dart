import 'package:extend_my_pay_admin_panel/Controller/auth_controller.dart';
import 'package:extend_my_pay_admin_panel/Provider/auth_provider.dart';
import 'package:extend_my_pay_admin_panel/Screens/Dashboard.dart';
import 'package:extend_my_pay_admin_panel/Screens/auth/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    void login() async {
      if (_formKey.currentState!.validate()) {
        final provider = Provider.of<AppAuthProvider>(context, listen: false);
        final success = await AuthController().loginAdmin(
          emailController.text.trim(),
          passwordController.text.trim(),
          provider,
        );

        if (success && context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed! Not authorized.")),
          );
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Admin Login", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: login, child: const Text("Login")),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgetPasswordScreen()),
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
