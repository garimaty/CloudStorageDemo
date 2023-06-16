import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../modals/cloud_storage_result.dart';

class StorageServices {
  Future<void> uploadFile(
      {required String filePath, required String fileName}) async {
    File file = File(filePath);
    try {
      await FirebaseStorage.instance.ref('test/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Stream<ListResult> listFiles() async* {
    final ref= FirebaseStorage.instance.ref();
    var results = await ref.child('test').listAll();
    results.items.forEach((Reference reference) {
      print('found file: $reference');
    });
   yield results;
  }

  Stream<String> downloadUrl(String filename) async*{
    String downloadUrl= await FirebaseStorage.instance.ref('test/$filename').
    getDownloadURL();
    yield downloadUrl;
  }
}
