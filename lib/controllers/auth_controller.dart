import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/models/user.dart' as model;
import 'package:tiktok/views/screens/home_screen.dart';
import 'package:tiktok/views/screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;
  File? get profiePhoto => _pickedImage.value;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar("Profile Picture",
          "You have successfully selected your profile picture");
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  //register the user
  void regiserUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //save out user to our auth
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profilePicture')
            .child(FirebaseAuth.instance.currentUser!.uid);
        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot snap = await uploadTask;
        String downlodUrl = await snap.ref.getDownloadURL();

        model.User user = model.User(
            name: username,
            email: email,
            uid: credential.user!.uid,
            profilePhoto: downlodUrl);
        FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
            "Error creating an account", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error creating an account", e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        Get.snackbar(
            "Error creating an account", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error creating an account", e.toString());
    }
  }
    void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
