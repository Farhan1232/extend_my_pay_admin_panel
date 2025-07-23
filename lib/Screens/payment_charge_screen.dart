import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/payment_charge_model.dart';
import '../Provider/payment_charge_provider.dart';
import '../Widgets/admin_layout.dart';

class PaymentChargeScreen extends StatefulWidget {
  const PaymentChargeScreen({super.key});

  @override
  State<PaymentChargeScreen> createState() => _PaymentChargeScreenState();
}

class _PaymentChargeScreenState extends State<PaymentChargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseController = TextEditingController();
  final _chargeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PaymentChargeProvider>(context, listen: false).loadSetting();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final model = PaymentChargeModel(
        baseAmount: double.parse(_baseController.text),
        chargeAmount: double.parse(_chargeController.text),
      );

      await Provider.of<PaymentChargeProvider>(context, listen: false)
          .saveSetting(model);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Charge settings saved.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentChargeProvider>(context);
    final setting = provider.setting;

    if (setting != null) {
      _baseController.text = setting.baseAmount.toString();
      _chargeController.text = setting.chargeAmount.toString();
    }

    return AdminLayout(
      screenTitle: "Payment Charge Settings",
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Define charge rule e.g. every \$250 → charge \$25", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _baseController,
                    decoration: const InputDecoration(
                      labelText: "Base Amount (e.g., 250)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? 'Enter base amount' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _chargeController,
                    decoration: const InputDecoration(
                      labelText: "Charge Amount (e.g., 25)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? 'Enter charge amount' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save Settings"),
                    onPressed: provider.isLoading ? null : _save,
                  ),
                ],
              ),
            ),
    );
  }
}
