import 'package:eval_task_camera_pan/screens/camera_screen.dart';
import 'package:eval_task_camera_pan/utils/app_images.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    //initial animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.repeat(reverse: true);

    //slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.7),
    ).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: _animationController,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pan Scanner'),
      ),
      body: Column(
        children: [
          _buildDescriptionWidget(),
          _buildCardScannerWidget(context),
          const SizedBox(
            height: 50,
          ),
          _buildButtonWidget(),
        ],
      ),
    );
  }

  Widget _buildButtonWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 10, 130, 228),
            borderRadius: BorderRadius.circular(5)),
        child: const Center(
          child: Text(
            'CLICK PAN CARD PICTURE',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardScannerWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300,
          margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
          alignment: Alignment.center,
          child: AppImages.panCardImage(context),
        ),
        // change values in position, width, margin ( in the widget below )
        // and slide animation method in init state
        // to adjust the animation
        Positioned(
          bottom: 170,
          child: SlideTransition(
            position: _slideAnimation,
            child: Opacity(
              opacity: 0.3,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 209, 59),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 154, 2),
                      width: 2,
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDescriptionWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Add PAN Card Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'PAN Card is mandatory for investing in India',
            style: TextStyle(
              color: Color.fromARGB(255, 150, 150, 150),
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 240, 243),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 10,
                  child: Icon(
                    Icons.shield_moon_rounded,
                    size: 14,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Your information is safe and encrypted',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
