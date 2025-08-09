import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          // Blueish overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color.fromARGB(255, 61, 163, 246).withOpacity(1),  // bottom: strong blue
                    Colors.transparent,            // top: no color
                  ],
                ),
              ),
            )),

          // Centered content (optional)
       Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // White container with ECOM
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'ECOM',
                    style: TextStyle(
                      color: Color.fromARGB(255, 83, 64, 247),
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Text outside the container
                Text(
                  'Ecommerce App',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )



        ],
      ),
    );
  }
}
