import 'dart:io' as io show File;
import 'package:extend_my_pay_admin_panel/Model/poster_model.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PosterController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> uploadPoster() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // Important for web!
    );

    if (result == null) return;

    final fileBytes = result.files.first.bytes;
    final fileName = result.files.first.name;

    final id = _firestore.collection('posters').doc().id;
    final ref = _storage.ref('posters/$id.jpg');

    if (kIsWeb) {
      // ✅ Web Upload using bytes
      await ref.putData(
        fileBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else {
      // ✅ Mobile/Desktop Upload using File
      final file = io.File(result.files.single.path!);
      await ref.putFile(file);
    }

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
