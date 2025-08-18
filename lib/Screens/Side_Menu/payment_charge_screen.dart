import 'package:extend_my_pay_admin_panel/Model/payment_charge_model.dart';
import 'package:extend_my_pay_admin_panel/Provider/payment_charge_provider.dart';
import 'package:extend_my_pay_admin_panel/Widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentChargeScreen extends StatelessWidget {
  const PaymentChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      screenTitle: "Payment Charge Settings",
      child: Consumer<PaymentChargeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.setting == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final baseController = TextEditingController(
              text: provider.setting?.baseAmount.toString() ?? '');
          final chargeController = TextEditingController(
              text: provider.setting?.chargeAmount.toString() ?? '');
          final formKey = GlobalKey<FormState>();

          Future<void> save() async {
            if (formKey.currentState!.validate()) {
              final model = PaymentChargeModel(
                baseAmount: double.parse(baseController.text),
                chargeAmount: double.parse(chargeController.text),
              );
              await Provider.of<PaymentChargeProvider>(
                context,
                listen: false,
              ).saveSetting(model);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Charge settings saved.")),
              );
            }
          }

         return Form(
  key: formKey,
  child: Center(
    child: SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Define charge rule e.g. every \$250 → charge \$25",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            TextFormField(
              controller: baseController,
              decoration: InputDecoration(
                labelText: "Base Amount (e.g., 250)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter base amount' : null,
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: chargeController,
              decoration: InputDecoration(
                labelText: "Charge Amount (e.g., 25)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter charge amount' : null,
            ),
            SizedBox(height: 28.h),
            Consumer<PaymentChargeProvider>(
              builder: (context, provider, _) {
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: const Color(0xFFFF941A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: Text(
                    "Save Settings",
                    style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
                  ),
                  onPressed: provider.isLoading ? null : save,
                );
              },
            ),
          ],
        ),
      ),
    ),
  ),
);

        },
      ),
    );
  }
}
