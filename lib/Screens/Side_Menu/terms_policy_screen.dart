import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Provider/terms_policy_provider.dart';
import '../../Widgets/admin_layout.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _descController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Consumer<TermsPolicyProvider>(
      builder: (context, provider, _) {
        if (!provider.isLoading && provider.policy == null) {
          provider.loadPolicy().then((_) {
            if (provider.policy != null) {
              _descController.text = provider.policy!.description;
            }
          });
        }

        return AdminLayout(
          screenTitle: "Terms & Policy",
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Container(
                      width: 800.w,
                      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Edit Terms & Policy",
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF941A),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            TextFormField(
                              controller: _descController,
                              minLines: 10,
                              maxLines: 20,
                              decoration: InputDecoration(
                                labelText: "Description",
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(fontSize: 16.sp),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Required' : null,
                            ),
                            SizedBox(height: 32.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF941A),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await provider.savePolicy(
                                      '',
                                      _descController.text.trim(),
                                    );

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Saved successfully")),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
