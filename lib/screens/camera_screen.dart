import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:eval_task_camera_pan/screens/preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isReady = false;
  XFile? picture;
  File? croppedPicture;
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.high,
    );
    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      picture = await _controller.takePicture();
      _cropImage(File(picture!.path));
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _cropImage(File imageFile) async {
    setState(() {
      _isCropping = true;
    });

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    setState(() {
      _isCropping = false;
    });

    croppedPicture = File(croppedImage!.path);
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(picture: croppedPicture),
        ));
  }

  Future<void> _requestPermission() async {
    Permission cameraPermission = Permission.camera;
    bool ispermanetelydenied = await cameraPermission.isPermanentlyDenied;
    dynamic cameraStat;
    if (ispermanetelydenied) {
      await openAppSettings();
    } else {
      var cameraStatus = await cameraPermission.request();
      cameraStat = cameraStatus.isGranted;
      if (cameraStat == false) {
        await openAppSettings();
      } else {
        null;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      Timer(const Duration(seconds: 3), () {
        _requestPermission();
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isCropping == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pan Scanner'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCameraInstructionsWidget(),
          _buildCameraWidget(),
          _buildCameraButtonWidget()
        ],
      ),
    );
  }

  Widget _buildCameraButtonWidget() {
    return GestureDetector(
      onTap: () {
        _takePicture();
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Colors.blue,
            ),
          ),
          child: const CircleAvatar(
            radius: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildCameraWidget() {
    return ClipPath(
      clipper: Clip(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.6,
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          height: 1,
          width: 1,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  Widget _buildCameraInstructionsWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Keep your PAN Card within the',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'frame',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Capture your photo and signature clearly. Avoid a',
            style: TextStyle(
              color: Color.fromARGB(255, 150, 150, 150),
              fontSize: 16,
            ),
          ),
          Text(
            'blurred picture.',
            style: TextStyle(
              color: Color.fromARGB(255, 150, 150, 150),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class Clip extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 50, size.width - 20, size.height / 2),
        const Radius.circular(20),
      ));
    return path;
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}
