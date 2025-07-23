import 'package:flutter/material.dart';
import '../Controller/support_controller.dart';
import '../Model/support_ticket_model.dart';

class SupportProvider extends ChangeNotifier {
  final SupportController _controller = SupportController();

  List<SupportTicket> _tickets = [];
  bool _isLoading = false;

  List<SupportTicket> get tickets => _tickets;
  bool get isLoading => _isLoading;

  Future<void> loadTickets() async {
    _isLoading = true;
    notifyListeners();

    _tickets = await _controller.fetchTickets();

    _isLoading = false;
    notifyListeners();
  }
}
