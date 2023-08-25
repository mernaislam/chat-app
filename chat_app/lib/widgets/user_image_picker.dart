import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;
  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 150,
        imageQuality: 50,
      );
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });

      widget.onPickedImage(_pickedImageFile!);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromARGB(136, 158, 158, 158),
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
