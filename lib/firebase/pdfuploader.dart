import "dart:io";
import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";

Future<String> pdfUpload(String v4, Uint8List path1) async {
  String downUrl;
  final Reference firebaseStorage =
      FirebaseStorage.instance.ref().child("pdf").child(v4).child("0");
  UploadTask uploadTask;
  final SettableMetadata metadata =
      SettableMetadata(contentType: "application/pdf");
  uploadTask = firebaseStorage.putData(path1, metadata);
  await uploadTask.whenComplete(() async {
    downUrl = await firebaseStorage.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("pdf")
        .doc(v4)
        .set(<String, String>{"0": downUrl});
  });
  return downUrl=await firebaseStorage.getDownloadURL();
}

Future<String> pdfUpload1(String v4, File path2) async {
  String downUrl;
  final Reference firebaseStorage =
      FirebaseStorage.instance.ref().child("pdf").child(v4).child("0");
  UploadTask uploadTask;
  final SettableMetadata metadata =
      SettableMetadata(contentType: "application/pdf");
  uploadTask = firebaseStorage.putFile(path2, metadata);
  await uploadTask.whenComplete(() async {
    downUrl = await firebaseStorage.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("pdf")
        .doc(v4)
        .set(<String, String>{"0": downUrl});
  });
  return downUrl=await firebaseStorage.getDownloadURL();
}
