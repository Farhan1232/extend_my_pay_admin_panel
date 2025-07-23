import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Model/poster_model.dart';

class PosterController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> uploadPoster() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final id = _firestore.collection('posters').doc().id;
    final ref = _storage.ref('posters/$id.jpg');

    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await _firestore.collection('posters').doc(id).set({
      'imageUrl': url,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deletePoster(String id) async {
    final doc = await _firestore.collection('posters').doc(id).get();
    final url = doc['imageUrl'] as String;

    await _firestore.collection('posters').doc(id).delete();

    final ref = _storage.refFromURL(url);
    await ref.delete();
  }

  Stream<List<PosterModel>> streamPosters() {
    return _firestore
        .collection('posters')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => PosterModel.fromMap(d.id, d.data()))
            .toList());
  }
}
