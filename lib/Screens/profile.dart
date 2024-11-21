// ProfileScreen

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/Screens/common_screen.dart';
import 'package:jewellery/Screens/usersEditScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userPhoneNumber;
  String? userName;
  String? userCity;
  String? userEmail;
  String? Admin_;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPreferences();
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber');
      userName = prefs.getString('userName');
      userEmail = prefs.getString('userEmail');
      userCity = prefs.getString('userCity');
      Admin_ = prefs.getString('Admin');
      print('$userPhoneNumber $userName $userCity $userEmail $Admin_');
    });
    if (Admin_ == 'Admin') {
      setState(() {
        isAdmin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark app bar
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.rowdies(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.shortestSide < 600
                  ? MediaQuery.of(context).size.width * 0.05 // Mobile
                  : MediaQuery.of(context).size.width * 0.035, // Tablet
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: MediaQuery.of(context).size.shortestSide < 600
                ? MediaQuery.of(context).size.width * 0.06 // Mobile
                : MediaQuery.of(context).size.width * 0.045, // Tablet
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.solidImages,
                color: const Color.fromARGB(255, 244, 139, 54),
                size: MediaQuery.of(context).size.shortestSide < 600
                    ? MediaQuery.of(context).size.width * 0.06 // Mobile
                    : MediaQuery.of(context).size.width * 0.040, // Tablet
              ),
              onPressed: () {
                Get.to(const CommonScreen(
                  title: 'Home_Slider',
                  categories: ['AllImages'],
                  mainFolder: 'WelcomeImages',
                ));
              },
            ),
            Container(
              width: MediaQuery.of(context).size.shortestSide < 600
                  ? MediaQuery.of(context).size.width * 0.01 // Mobile
                  : MediaQuery.of(context).size.width * 0.025,
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.userCheck,
                color: const Color.fromARGB(255, 244, 139, 54),
                size: MediaQuery.of(context).size.shortestSide < 600
                    ? MediaQuery.of(context).size.width * 0.06 // Mobile
                    : MediaQuery.of(context).size.width * 0.040, // Tablet
              ),
              onPressed: () {
                Get.to(const UserListView());
              },
            ),
            Container(
              width: MediaQuery.of(context).size.shortestSide < 600
                  ? MediaQuery.of(context).size.width * 0.04 // Mobile
                  : MediaQuery.of(context).size.width * 0.025,
            ),
          ],
        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // -- TOP CARD
              Container(
                
                width: double.infinity,
                height: MediaQuery.of(context).size.shortestSide < 600
                    ? MediaQuery.of(context).size.height * 0.47 // Mobile height
                    : MediaQuery.of(context).size.height * 0.5, // Tablet height
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.shortestSide < 600
                      ? 22.0
                      : 50.0, // Wider margin for tablets
                  vertical: 20
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 62, 38, 0), // Darker color
                      const Color.fromARGB(255, 0, 0, 0) // Slightly lighter dark color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12.0,
                    ),
                  ],
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 145, 0),
                    width: 0.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.shortestSide < 600
                      ? MediaQuery.of(context).size.width * 0.04 // Mobile
                      : MediaQuery.of(context).size.width * 0.055,
                  vertical: MediaQuery.of(context).size.shortestSide < 600
                      ? MediaQuery.of(context).size.width * 0 // Mobile
                      : MediaQuery.of(context).size.width * 0.01, // Tablet
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.shortestSide < 600
                              ? 120
                              : 150, // Dynamic size
                          height: MediaQuery.of(context).size.shortestSide < 600
                              ? 120
                              : 150, // Dynamic size
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/profileimage2.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(137, 161, 161, 161),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        userName ?? '',
                        style: GoogleFonts.dmSerifDisplay(
                          textStyle: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.shortestSide < 600
                                    ? 22 // Mobile font size
                                    : 28, // Tablet font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.shortestSide < 600
                          ? MediaQuery.of(context).size.width * 0.04 // Mobile
                          : MediaQuery.of(context).size.width * 0.065,
                    ),
                    _buildInfoContainer(
                      context: context,
                      text: userPhoneNumber ?? '',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoContainer(
                      context: context,
                      text: userEmail ?? '',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoContainer(
                      context: context,
                      text: userCity ?? '',
                    ),
                  ],
                ),
              ),

              // -- LIST VIEW ITEMS (Each in a separate Card)

              Card(
                color: const Color.fromARGB(255, 0, 0, 0),
                elevation: MediaQuery.of(context).size.shortestSide < 600
                    ? 5
                    : 8, // Elev elevation based on screen size
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.shortestSide < 600
                      ? MediaQuery.of(context).size.width * 0.06 // Mobile
                      : MediaQuery.of(context).size.width * 0.06, // Tablet
                  vertical: MediaQuery.of(context).size.shortestSide < 600
                      ? 8.0 // Mobile
                      : 15.0, // Tablet
                ),
                child: ProfileMenuWidget(
                  title: 'Help Center',
                  icon: Icons.help,
                  onPress: () {},
                ),
              ),
              Card(
                 color: const Color.fromARGB(255, 0, 0, 0),
                elevation:
                    MediaQuery.of(context).size.shortestSide < 600 ? 5 : 8,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.shortestSide < 600
                      ? MediaQuery.of(context).size.width * 0.06 // Mobile
                      : MediaQuery.of(context).size.width * 0.06, // Tablet
                  vertical: MediaQuery.of(context).size.shortestSide < 600
                      ? 8.0 // Mobile
                      : 15.0, // Tablet
                ),
                child: ProfileMenuWidget(
                  title: 'Refer',
                  icon: Icons.person_add,
                  onPress: () {},
                ),
              ),
              Card(
                 color: const Color.fromARGB(255, 0, 0, 0),
                elevation:
                    MediaQuery.of(context).size.shortestSide < 600 ? 5 : 8,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.shortestSide < 600
                      ? MediaQuery.of(context).size.width * 0.06 // Mobile
                      : MediaQuery.of(context).size.width * 0.06, // Tablet
                  vertical: MediaQuery.of(context).size.shortestSide < 600
                      ? 8.0 // Mobile
                      : 15.0, // Tablet
                ),
                child: ProfileMenuWidget(
                  title: 'Developers',
                  icon: Icons.developer_mode,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Scaffold(
                            backgroundColor: Colors.black,
                            appBar: AppBar(
                              backgroundColor: Colors.black,
                              elevation: 5,
                              title: Text(
                                'Developers Details',
                                style: GoogleFonts.rowdies(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 20
                                        : 24, // Mobile/Tablet Responsive Font Size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              centerTitle: true,
                              leading: BackButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            body: Container(
                                color: Colors.black,
                                child: const DevelopersSection()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              if (isAdmin) ...[
                Card(
                   color: const Color.fromARGB(255, 0, 0, 0),
                  elevation:
                      MediaQuery.of(context).size.shortestSide < 600 ? 5 : 8,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.shortestSide < 600
                        ? MediaQuery.of(context).size.width * 0.06 // Mobile
                        : MediaQuery.of(context).size.width * 0.06, // Tablet
                    vertical: MediaQuery.of(context).size.shortestSide < 600
                        ? 8.0 // Mobile
                        : 15.0, // Tablet
                  ),
                  child: ProfileMenuWidget(
                    title: 'Recycle Bin',
                    icon: FontAwesomeIcons.dumpster,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () {
                      Get.to(const CommonScreen(
                        title: 'RecycleBin',
                        categories: ['RecycleBin'],
                        mainFolder: 'RecycleBin',
                      ));
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor =
        isDark ? Colors.blue : Colors.green; // Replace with your desired color

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor ?? const Color.fromARGB(255, 203, 203, 203), // Default to white for dark theme
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Icons.arrow_forward_ios,
                  size: 18.0, color: Colors.grey),
            )
          : null,
    );
  }
}

class DevelopersSection extends StatelessWidget {
  const DevelopersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.shortestSide < 600 ? 400 : 500,
        width: MediaQuery.of(context).size.shortestSide < 600 ? 350 : 450,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2C2C2C), // Dark gray
              Color(0xFF4E4E4E), // Slightly lighter gray
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DeveloperInfo(
                name: 'Tharun Rachabanti',
                email: 'thvfuturistai@gmail.com',
                phone: '9347644178',
              ),
              SizedBox(height: 16.0),
              DeveloperInfo(
                name: 'Vijay Kumar Vellanki',
                email: 'thvfuturistai@gmail.com',
                phone: '9150987651',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Name: $name',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Email: $email',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Phone: $phone',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Information Containers
Widget _buildInfoContainer({
  required BuildContext context,
  required String text,
}) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.grey[800], // Darker background for info container
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.shortestSide < 600
              ? 16 // Mobile font size
              : 20, // Tablet font size
          color: Colors.white, // White text for dark theme
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
