import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/views/screens/confirm_screen.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  pickvideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmScreen(
                    videoFile: File(video.path),
                    videoPath: video.path,
                  )));
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              backgroundColor: Colors.grey,
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    pickvideo(ImageSource.camera, context);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt),
                      Text(
                        'Camera',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickvideo(ImageSource.gallery, context);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Text(
                        'Gallery',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.cancel),
                      Text(
                        'cancel',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            showOptionsDialog(context);
          },
          child: Container(
            width: 190,
            height: 50,
            decoration: const BoxDecoration(color: Colors.red),
            child: const Center(
              child: Text(
                "Add video",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}