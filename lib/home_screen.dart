import 'package:flutter/material.dart';
import 'package:flutter_camera/pages/camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* AppBar
      // appBar: AppBar(
      //   toolbarHeight: 0,
      // ),
      // appBar: AppBar(
      //   title: Center(child: Text('Hello World $currentPage')),
      //   elevation: 0,
      // ),

      //* Body
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        controller: pageController,
        children: const <Widget>[
          CameraScreen(),
          CustomScreen(
            child: Text('Hola Mundo 2'),
          ),
          CustomScreen(
            child: Text('Hola Mundo 3'),
          ),
        ],
      ),

      //* Tabs
      bottomNavigationBar: currentPage == 0
          ? null
          : BottomNavigationBar(
              currentIndex: currentPage,
              onTap: (value) {
                setState(() {
                  pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                  currentPage = value;
                });
              },
              backgroundColor: Colors.blue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.50),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car),
                  label: 'Capturar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Historial',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Configuracion',
                ),
              ],
            ),
    );
  }
}

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
    // return Container(
    //   color: color,
    //   child: const Center(
    //     child: Text('Hello World'),
    //   ),
    // );
  }
}
