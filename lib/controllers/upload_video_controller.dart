import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  // _compressVideo(String videoPath) async {
  //   final compressedVideo = await VideoCompress.compressVideo(videoPath,
  //       quality: VideoQuality.MediumQuality);
  //   return compressedVideo!.file;
  // }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child("videos").child(id);

    UploadTask uploadTask = ref.putFile(
        File(videoPath), SettableMetadata(contentType: "video/mp4"));
    // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {

    //   print((taskSnapshot.bytesTransferred.toDouble() /
    //           taskSnapshot.totalBytes.toDouble())
    //       .toString());
    // });
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbNail;
  }

  _uploadImageToStorage(String id, String videoPath) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("thumbnails").child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      var allDocs = await FirebaseFirestore.instance.collection("videos").get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto']);
 
      await FirebaseFirestore.instance
          .collection("videos")
          .doc("Video $len")
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar("Error Uploading video", e.toString());
    }
  }
}
