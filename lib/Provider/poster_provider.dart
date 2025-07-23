import 'package:flutter/material.dart';
import '../Model/poster_model.dart';
import '../Controller/poster_controller.dart';

class PosterProvider with ChangeNotifier {
  final controller = PosterController();
  List<PosterModel> posters = [];
  bool isLoading = false;

  void loadPosters() {
    controller.streamPosters().listen((list) {
      posters = list;
      notifyListeners();
    });
  }

  Future<void> upload() async {
    isLoading = true;
    notifyListeners();
    await controller.uploadPoster();
    isLoading = false;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await controller.deletePoster(id);
  }
}
