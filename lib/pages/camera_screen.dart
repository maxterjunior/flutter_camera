import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  late String imagePath;

  @override
  void initState() {
    super.initState();

    availableCameras().then((value) => {
          cameras = value,
          if (cameras.isNotEmpty)
            {
              setState(() {
                selectedCameraIndex = 0;
              }),
              _initCameraController(cameras[selectedCameraIndex]).then((value) {
                setState(() {});
              })
            }
          else
            {print('No camera available')}
        });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    cameraController.addListener(() {
      if (mounted) {
        // cameraController.setFlashMode(FlashMode.off);
        setState(() {});
      }
    });
    if (cameraController.value.hasError) {
      print('Camera error ${cameraController.value.errorDescription}');
    }
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Camera error $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  // Display camera preview
  Widget _cameraPreviewWidget() {
    if (cameras.isEmpty || !cameraController.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  // Display camera control (take photo, flash)
  Widget _cameraControlWidget(context) {
    return FloatingActionButton.large(
      backgroundColor: Colors.transparent,
      onPressed: () {
        _onCapturePressed(context);
      },
      elevation: 0,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.circle, color: Colors.white38, size: 80),
          Icon(Icons.circle, color: Colors.white, size: 65),
        ],
      ),
    );
  }

  // Flash control
  Widget _toggleCameraWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: IconButton(
          icon: cameraController.value.flashMode == FlashMode.off
              ? const Icon(Icons.flash_off, color: Colors.white, size: 30)
              : const Icon(Icons.flash_on, color: Colors.white, size: 30),
          onPressed: () {
            _onSwitchFlash();
          },
        ),
      ),
    );
  }

  void _onCapturePressed(context) async {
    try {
      XFile picture = await cameraController.takePicture();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Photo Preview'),
            ),
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(picture.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _onSwitchFlash() {
    if (cameraController.value.flashMode == FlashMode.off) {
      cameraController.setFlashMode(FlashMode.torch);
    } else {
      cameraController.setFlashMode(FlashMode.off);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) return Container();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _cameraPreviewWidget(),
        ),
        SizedBox(
          height: 120,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _toggleCameraWidget(),
              _cameraControlWidget(context),
              const Spacer(),
            ],
          ),
        )
      ],
    );
  }
}
