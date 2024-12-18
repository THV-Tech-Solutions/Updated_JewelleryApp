import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery/Screens/home_screen.dart';
import 'package:jewellery/Screens/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  var currentIndex = 0;
  late AnimationController _controller;
  String userPhoneNumber = '';
  String userName = '';
  String wishlistUserCollectionDocName = '';

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber')!;
      userName = prefs.getString('userName')!;
      print("$userPhoneNumber $userName");
    });
  }

  static const List<IconData> listOfIcons = [
    Icons.home_max_outlined,
    Icons.favorite_border,
  ];

  static const List<String> listOfStrings = [
    'Home',
    'Favorite',
  ];

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPreferences();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    final displayHeight = MediaQuery.of(context).size.height;

    final isTabletDevice = isTablet(context);
    final bottomNavBarHeight = isTabletDevice ? displayWidth * 0.12 : displayWidth * 0.155;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: [
              const HomeScreen(),
              WishlistScreen(
                userPhoneNumber: userPhoneNumber,
                userName: userName,
              ),
            ],
          ),
          Positioned(
            bottom: displayHeight * 0.0,
            left: displayWidth * 0.05,
            right: displayWidth * 0.05,
            child: Padding(
              padding:EdgeInsets.symmetric(vertical: 1,horizontal: isTabletDevice ? 170 : 8, ),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: bottomNavBarHeight,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 8, 8),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.7),
                        offset: const Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildTab(0, displayWidth, isTabletDevice),
                      buildTab(1, displayWidth, isTabletDevice),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTab(int index, double displayWidth, bool isTabletDevice) {
    final isSelected = index == currentIndex;
    final tabWidth = isTabletDevice ? (isSelected ? displayWidth * .25 : displayWidth * .15) : (isSelected ? displayWidth * .32 : displayWidth * .18);
    final tabHeight = isTabletDevice ? displayWidth * .09 : displayWidth * .12;

    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
          HapticFeedback.lightImpact();
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            width: tabWidth,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn,
              height: isSelected ? tabHeight : 0,
              width: tabWidth,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.deepOrangeAccent.withOpacity(.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            width: tabWidth,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: isSelected ? displayWidth * .13 : 0,
                    ),
                    AnimatedOpacity(
                      opacity: isSelected ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Text(
                        isSelected ? listOfStrings[index] : '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: isSelected ? displayWidth * .03 : 20,
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isSelected ? 1.2 : 1.0,
                          child: Icon(
                            listOfIcons[index],
                            size: isTabletDevice ? displayWidth * .06 : displayWidth * .076,
                            color: isSelected
                                ? Colors.orangeAccent
                                : const Color.fromARGB(255, 255, 255, 255),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
