import "dart:io";
import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";

int iii = 0;
List<String> durl = <String>[];
Map<String, String> all = <String, String>{};
String downUrl = "";
String img = "";

Future<String> imageUpload(String v4, String images) async {
  final List<String> image = <String>[];
  final Reference firebaseStorage =
      FirebaseStorage.instance.ref().child("images").child(v4).child("$iii");
  image.add(images);
  UploadTask uploadTask;
  iii++;
  for (img in image) {
    uploadTask = firebaseStorage.putFile(File(img));
    await uploadTask.whenComplete(() async {
      downUrl = await firebaseStorage.getDownloadURL();
      durl.add(downUrl);
    });
  }
  for (int ii = 0; ii < durl.length; ii++) {
    all.addAll(<String, String>{"$ii": durl[ii]});
  }
  await FirebaseFirestore.instance
      .collection("images")
      .doc(v4)
      .collection("value")
      .doc("links")
      .set(all);
  await FirebaseFirestore.instance
      .collection("images")
      .doc(v4)
      .set(<String, String>{"image": "$iii"});

  return v4;
}


Future<String> imageUpload1(String v4, Uint8List images) async {
  final List<Uint8List> image = <Uint8List>[];
  final Reference firebaseStorage =
      FirebaseStorage.instance.ref().child("images").child(v4).child("$iii");
  image.add(images);
  UploadTask uploadTask;
  final SettableMetadata metadata =
      SettableMetadata(contentType: "image/jpeg");
  iii++;
  for (final Uint8List img1 in image) {
    uploadTask = firebaseStorage.putData(img1,metadata);
    await uploadTask.whenComplete(() async {
      downUrl = await firebaseStorage.getDownloadURL();
      durl.add(downUrl);
    });
  }
  for (int ii = 0; ii < durl.length; ii++) {
    all.addAll(<String, String>{"$ii": durl[ii]});
  }
  await FirebaseFirestore.instance
      .collection("images")
      .doc(v4)
      .collection("value")
      .doc("links")
      .set(all);
  await FirebaseFirestore.instance
      .collection("images")
      .doc(v4)
      .set(<String, String>{"image": "$iii"});

  return v4;
}
