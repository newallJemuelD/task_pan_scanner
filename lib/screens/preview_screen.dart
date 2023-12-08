import 'dart:io';

import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final File? picture;
  const PreviewScreen({super.key, required this.picture});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pan Scanner'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewDescriptionWidget(),
          const SizedBox(
            height: 100,
          ),
          _buildImagePreviewWidget(),
          _buildBackNavigationWidget(),
          const SizedBox(
            height: 100,
          ),
          _buildButtonWidget(),
        ],
      ),
    );
  }

  Widget _buildButtonWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 130, 228),
          borderRadius: BorderRadius.circular(5)),
      child: const Center(
        child: Text(
          'CONFIRM',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackNavigationWidget() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 20),
        child: const Text(
          'Not Happy? Click again?',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewDescriptionWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'PAN preview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'If the picture is unclear, click again',
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

  Widget _buildImagePreviewWidget() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.file(File(widget.picture!.path)),
      ),
    );
  }
}
