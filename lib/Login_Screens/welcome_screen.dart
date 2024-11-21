import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/Login_Screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: [
              createPage(
                image: 'assets/images/bb1.png',
                title: Constants.titleOne,
                description: Constants.descriptionOne,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
              createPage(
                image: 'assets/images/yy1.png',
                title: Constants.titleTwo,
                description: Constants.descriptionTwo,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
              createPage(
                image: 'assets/images/first-e.png',
                title: Constants.titleThree,
                description: Constants.descriptionThree,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.12,
            left: screenWidth * 0.1,
            child: Row(
              children: _buildIndicator(screenWidth),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.1,
            right: screenWidth * 0.1,
            child: GestureDetector(
              onTap: () => _nextPage(),
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.primaryColor,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: screenWidth * 0.05,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() async {
    if (currentIndex < 2) {
      currentIndex++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userPhoneNumber');
      await prefs.remove('Admin');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  List<Widget> _buildIndicator(double screenWidth) {
    return List<Widget>.generate(
      3,
      (index) => _indicator(index == currentIndex, screenWidth),
    );
  }

  Widget _indicator(bool isActive, double screenWidth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: screenWidth * 0.02,
      width: isActive ? screenWidth * 0.05 : screenWidth * 0.02,
      margin: EdgeInsets.only(right: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: isActive ? Constants.primaryColor : Colors.grey[700],
        borderRadius: BorderRadius.circular(screenWidth * 0.01),
      ),
    );
  }
}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double screenHeight;
  final double screenWidth;

  const createPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(139, 96, 67, 6)
                ], // Black to Gold gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: screenHeight * 0.1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: screenHeight * 0.3,
          ),
          SizedBox(height: screenHeight * 0.05),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzelDecorative(
              textStyle: TextStyle(
                color: Constants.primaryColor,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(screenWidth * 0.01, screenWidth * 0.01),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.marcellusSc(
              fontSize: screenWidth * 0.040,
              fontWeight: FontWeight.normal,
              color: const Color.fromARGB(255, 162, 162, 162),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(screenWidth * 0.005, screenWidth * 0.005),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Constants {
  static var primaryColor = Colors.orangeAccent;
  static var blackColor = Colors.black54;

  static var titleOne = "Explore Our Shiny Jewelry";
  static var descriptionOne =
      "Check out beautiful gold, silver, diamond, rose gold, and gemstone pieces. We make them sparkle just for you.";
  static var titleTwo = "Expert Goldsmiths";
  static var descriptionTwo =
      "Feel the skill of our own top gold working. From classic gold designs to shiny diamonds, we make your wishes real.";
  static var titleThree = "Selectable Elegance";
  static var descriptionThree =
      "Enjoy beauty and art in every piece. Choose your special style from our handpicked gold, silver, diamond, rose gold, and gemstone choices.";
}
