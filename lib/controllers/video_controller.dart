import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok/controllers/auth_controller.dart';
import 'package:tiktok/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videosList = Rx<List<Video>>([]);
  List<Video> get videosList => _videosList.value;

  @override
  void onInit() {
    super.onInit();
    _videosList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Video> returnValue = [];
      for (var element in querySnapshot.docs) {
        returnValue.add(Video.fromSnap(element));
      }
      return returnValue;
    }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('videos').doc(id).get();
    var uid = AuthController.instance.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
