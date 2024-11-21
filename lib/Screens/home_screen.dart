import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/Screens/Search.dart';
import 'package:jewellery/Screens/common_screen.dart';
import 'package:jewellery/Screens/diamonds_screen.dart';
import 'package:jewellery/Screens/profile.dart';
import 'gemstones_screen.dart';
import 'gold_screen.dart';
import 'rosegold_screen.dart';
import 'silver_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // Import this for Timer

bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width > 600;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_scrollController.hasClients) {
        final double maxScrollExtent =
            _scrollController.position.maxScrollExtent;
        final double currentScroll = _scrollController.offset;
        final double nextScroll = currentScroll +
            MediaQuery.of(context).size.width * 1.02; // Adjust as needed

        if (nextScroll >= maxScrollExtent) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            nextScroll,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  final List<String> images = [
    'assets/images/scrollsecond1.png',
    // 'assets/images/scrollsecond.png',
    'assets/images/scrollsecond3.png',
    'assets/images/scrollsecond4.png',
    'assets/images/scrollsecond5.png',
    'assets/images/scrollsecond6.png',
    // 'assets/images/canvascrollable.png',
    // 'assets/images/canvascrollable2.png',
    // 'assets/images/image 2.jpg',
    // 'assets/images/poster2.jpg',
    // 'assets/images/poster3.png',
    // 'assets/images/jj.jpg',
    // 'assets/images/poster6.jpg',
    // 'assets/images/poster7.jpg',
    // 'assets/images/poster8.jpg',
  ];

  final FocusNode _focusNode = FocusNode();

  void _showUnderDevelopmentMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Under Development"),
          content: const Text("This feature is currently under development."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool tablet = isTablet(context);

    // Define responsive sizes for mobiles and tablets for appbar
    double toolbarHeight = tablet
        ? screenWidth * 0.1
        : screenWidth * 0.15; // Larger toolbar for tablets
    double logoSize = tablet
        ? screenWidth * 0.09
        : screenWidth * 0.12; // Smaller logo for tablets
    double titleFontSize = tablet
        ? screenWidth * 0.05
        : screenWidth * 0.07; // Smaller font for tablets
    double profileImageSize = tablet
        ? screenWidth * 0.05
        : screenWidth * 0.07; // Adjust profile image size
    double sidePadding = tablet ? screenWidth * 0.14 : screenWidth * 0.01;
    double topdownPadding = tablet ? screenWidth * 0.04 : screenWidth * 0.1;

    // Responsive settings for GridView
    int crossAxisCount = tablet ? 3 : 3; // More columns for tablets
    double mainAxisSpacing = tablet ? 20 : 12;
    double crossAxisSpacing = tablet ? 20 : 10;
    double childAspectRatio = tablet ? (180 / 240) : (180 / 260);

    // Responsive properties of poster1
    final isTablet1 = screenWidth > 600;
    double containerHeight =
        isTablet1 ? screenHeight * 0.15 : screenHeight * 0.12;
    double topMargin = isTablet1 ? 40.0 : 40.0;

    // Responsive properties of scrollable posters
    double containerheight =
        isTablet1 ? screenHeight * 0.318 : screenHeight * 0.230;
    double topmargin = isTablet1 ? 60.0 : 40.0;
    double imageSpacing = isTablet1 ? 15.0 : 10.0;

    // Responsive properties of poster3
    double containerHeight1 =
        isTablet1 ? screenHeight * 0.45 : screenHeight * 0.33;
    double topMargin1 = isTablet1 ? 100.0 : 70.0;
    double sideMargin1 = isTablet1 ? 50.0 : 30.0;
    double bottomMargin1 = isTablet1 ? 60.0 : 30.0;

    return Scaffold(
      // backgroundColor: Colors.grey[300],
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(65, 0, 0, 0),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: toolbarHeight, // Responsive toolbar height
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo with fixed padding from the left
            Padding(
              padding: EdgeInsets.only(
                  left: sidePadding,
                  top: topdownPadding,
                  bottom: topdownPadding),
              child: SizedBox(
                width: logoSize,
                height: logoSize,
                child: Image.asset(
                  'assets/images/logo9.png',
                  width: logoSize * 0.80, // 84% of logo size
                  height: logoSize * 0.80,
                ),
              ),
            ),
            // Center title
            Expanded(
              child: Center(
                child: Text(
                  MediaQuery.of(context).size.width > 600
                      ? "Sri Balaji Jewellers"
                      : "SriBalajiJewelers",
                  style: MediaQuery.of(context).size.width > 600
                      ? GoogleFonts.cinzelDecorative(
                          //cinzelDecorative, marcellusSc, bonaNova, spectralSc, cormorantSc
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          // color: Colors.orangeAccent,
                          letterSpacing: 1,
                          shadows: [
                            const Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 7,
                              color: Colors.black,
                            ),
                          ],
                          decoration: TextDecoration.none,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Colors.orange, Colors.orange],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 30.0)),
                        )
                      : GoogleFonts.mateSc(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          shadows: [
                            const Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 7,
                              color: Colors.black,
                            ),
                          ],
                          decoration: TextDecoration.none,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Colors.orange, Colors.orange],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 30.0)),
                        ),
                ),
              ),
            ),
            // Profile icon with fixed padding from the right
            Padding(
              padding: EdgeInsets.only(right: sidePadding),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.white54,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Get.to(const ProfileScreen());
                  },
                  // child: Padding(
                  //   padding: const EdgeInsets.all(3),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(20),
                  //     child: Image.network(
                  //       'https://cdn-icons-png.freepik.com/512/10302/10302971.png',
                  //       width: profileImageSize,
                  //       height: profileImageSize,
                  //       fit: BoxFit.cover,
                  //       loadingBuilder: (BuildContext context, Widget child,
                  //           ImageChunkEvent? loadingProgress) {
                  //         if (loadingProgress == null) {
                  //           return child;
                  //         }
                  //         return Center(
                  //           child: CircularProgressIndicator(
                  //             value: loadingProgress.expectedTotalBytes != null
                  //                 ? loadingProgress.cumulativeBytesLoaded /
                  //                     (loadingProgress.expectedTotalBytes ?? 1)
                  //                 : null,
                  //           ),
                  //         );
                  //       },
                  //       errorBuilder: (BuildContext context, Object exception,
                  //           StackTrace? stackTrace) {
                  //         return const Icon(Icons.error);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/profileimage.png', // Update with your asset path
                        width: profileImageSize,
                        height: profileImageSize,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.shortestSide >= 600
                                ? MediaQuery.of(context).size.width *
                                    0.03 // 10% for tablets
                                : MediaQuery.of(context).size.width *
                                    0.05, // 5% for phones
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.shortestSide >= 600
                                    ? MediaQuery.of(context).size.width *
                                        0.01 // 4% for tablets
                                    : MediaQuery.of(context).size.width *
                                        0.02, // 2% for phones
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onTap: () {
                                    _focusNode.unfocus();
                                    Get.to(const SearchScreen());
                                  },
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide >=
                                            600
                                        ? MediaQuery.of(context).size.width *
                                            0.03 // Larger font for tablets
                                        : MediaQuery.of(context).size.width *
                                            0.04, // Smaller font for phones
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Search for Ornaments",
                                    hintStyle: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .shortestSide >=
                                              600
                                          ? MediaQuery.of(context).size.width *
                                              0.025 // Larger hint font for tablets
                                          : MediaQuery.of(context).size.width *
                                              0.035, // Smaller hint font for phones
                                      color: const Color.fromARGB(
                                          185, 218, 218, 218),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: MediaQuery.of(context)
                                                  .size
                                                  .shortestSide >=
                                              600
                                          ? MediaQuery.of(context).size.width *
                                              0.05 // Extra padding for tablets
                                          : MediaQuery.of(context).size.width *
                                              0.04, // Standard padding for phones
                                    ),
                                  ),
                                  focusNode: _focusNode,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showUnderDevelopmentMessage();
                                },
                                icon: const Icon(Icons.mic),
                                iconSize:
                                    MediaQuery.of(context).size.shortestSide >=
                                            600
                                        ? MediaQuery.of(context).size.width *
                                            0.04 // Larger icon for tablets
                                        : MediaQuery.of(context).size.width *
                                            0.06, // Smaller icon for phones
                                color: const Color.fromARGB(194, 255, 255, 255),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showUnderDevelopmentMessage();
                                },
                                icon: const Icon(Icons.settings),
                                iconSize:
                                    MediaQuery.of(context).size.shortestSide >=
                                            600
                                        ? MediaQuery.of(context).size.width *
                                            0.04 // Larger icon for tablets
                                        : MediaQuery.of(context).size.width *
                                            0.06, // Smaller icon for phones
                                color: const Color.fromARGB(189, 255, 255, 255),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomCarouselSlider(images: images),
                    const SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: tablet ? 50.0 : 16.0,
                          vertical: tablet ? 10.0 : 16.0),
                      child: GridView.count(
                        crossAxisCount:
                            crossAxisCount, // Responsive column count
                        mainAxisSpacing: mainAxisSpacing, // Responsive spacing
                        crossAxisSpacing: crossAxisSpacing,
                        childAspectRatio:
                            childAspectRatio, // Responsive aspect ratio
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          CategoryCard(
                            image: "assets/images/rk1.6.png",
                            title: "Gold",
                            onTap: () {
                              Get.to(const GoldScreen());
                            },
                          ),
                          CategoryCard(
                            image: "assets/images/rk1.4.png",
                            title: "Silver",
                            onTap: () {
                              Get.to(const SilverScreen());
                            },
                          ),
                          CategoryCard(
                            image: "assets/images/diamon.png",
                            title: "Diamond",
                            onTap: () {
                              Get.to(const DiamondScreen());
                            },
                          ),
                          CategoryCard(
                            image: "assets/images/ty.jpg",
                            title: "Gemstone",
                            onTap: () {
                              Get.to(const GemStonesScreen());
                            },
                          ),
                          CategoryCard(
                            image: "assets/images/RoseGoldHome.png",
                            title: "RoseGold",
                            onTap: () {
                              Get.to(const RoseGoldScreen());
                            },
                          ),
                          CategoryCard(
                            image: "assets/images/ty.jpg",
                            title: "Gemstone",
                            onTap: () {
                              Get.to(const GemStonesScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: containerHeight, // Responsive height
                      margin:
                          EdgeInsets.only(top: topMargin), // Responsive margin
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/canva2.png'),
                          fit: BoxFit
                              .cover, // This will cover the entire container.
                        ),
                      ),
                    ),
                    Container(
                      height: containerheight, // Responsive height
                      margin:
                          EdgeInsets.only(top: topmargin), // Responsive margin
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/canvascroll1.png',
                            height:
                                containerheight, // Adjust image height to match container
                          ),
                          SizedBox(
                            width: imageSpacing, // Responsive spacing
                          ),
                          Image.asset(
                            'assets/images/canvascroll2.png',
                            height: containerheight,
                          ),
                          SizedBox(
                            width: imageSpacing,
                          ),
                          Image.asset(
                            'assets/images/canvascroll3.png',
                            height: containerheight,
                          ),
                          SizedBox(
                            width: imageSpacing,
                          ),
                          Image.asset(
                            'assets/images/canvascroll4.png',
                            height: containerheight,
                          ),
                          SizedBox(
                            width: imageSpacing,
                          ),
                          Image.asset(
                            'assets/images/canvascroll5.png',
                            height: containerheight,
                          ),
                          SizedBox(
                            width: imageSpacing,
                          ),
                          Image.asset(
                            'assets/images/canvascroll6.png',
                            height: containerheight,
                          ),
                          SizedBox(
                            width: imageSpacing,
                          ),
                          Image.asset(
                            'assets/images/canvascroll7.png',
                            height: containerheight,
                          ),
                          SizedBox(
                            width: imageSpacing,
                          ),
                          Image.asset(
                            'assets/images/canvascroll8.png',
                            height: containerheight,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: containerHeight1, // Responsive height
                      margin: EdgeInsets.only(
                        top: topMargin1, // Responsive top margin
                        left: sideMargin1, // Responsive side margins
                        right: sideMargin1,
                        bottom: bottomMargin1, // Responsive bottom margin
                      ),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/canva3.png'),
                          fit: BoxFit.cover, // Cover the entire container
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            'Quick Links',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.orbitron(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 203, 203, 203),
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QuickLinkContainer(
                                assetBackgroundImagePath: "QuickLink1.jpeg",
                                catagory_: 'Stones',
                                mainFolder_: 'Gold',
                                title_: 'Ladies Rings',
                              ),
                              QuickLinkContainer(
                                assetBackgroundImagePath: "QuickLink2.jpg",
                                catagory_: 'Stones',
                                mainFolder_: 'Gold',
                                title_: 'Necklace',
                              ),
                            ],
                          ),
                          //silver
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     QuickLinkContainer(
                          //       assetBackgroundImagePath: "QuickLink3.jpg",
                          //       catagory_: 'Vodharani',
                          //       mainFolder_: 'Silver',
                          //       title_: 'Silver Articles',
                          //     ),
                          //     QuickLinkContainer(
                          //       assetBackgroundImagePath: "QuickLink4.jpg",
                          //       catagory_: 'Plates',
                          //       mainFolder_: 'Silver',
                          //       title_: 'Silver Articles',
                          //     ),
                          //   ],
                          // ),
                          //silver end
                          //roseGold
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QuickLinkContainer(
                                assetBackgroundImagePath: "QuickLink11.webp",
                                catagory_: 'Stones',
                                mainFolder_: 'RoseGold',
                                title_: 'Harams',
                              ),
                              QuickLinkContainer(
                                assetBackgroundImagePath: "QuickLink7.jpg",
                                catagory_: 'Stones',
                                mainFolder_: 'RoseGold',
                                title_: 'Ladies Rings',
                              ),
                            ],
                          ),
                          //roseGold end
                          //diamond start
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QuickLinkContainer(
                                assetBackgroundImagePath: "QuickLink8.jpg",
                                catagory_: 'Stones',
                                mainFolder_: 'Diamond',
                                title_: 'Ladies Rings',
                              ),
                              QuickLinkContainer(
                                assetBackgroundImagePath: "QuickLink9.jpg",
                                catagory_: 'Stones',
                                mainFolder_: 'Diamond',
                                title_: 'Necklace',
                              ),
                            ],
                          ),
                          //diamond end
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width > 600
                          ? 300
                          : 200, // Responsive height
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width > 600
                              ? 55.0
                              : 25.0), // Responsive padding
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'About Us',
                            style: GoogleFonts.orbitron(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 35
                                  : 24, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Check out beautiful gold, silver, diamond, rose gold, and gemstone pur special style from our handpicked gold, silver, diamond, rose gold, and gemstone choices.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cinzel(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 20
                                  : 14, // Responsive font size
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.width > 600
                            ? 150
                            : 130, // Responsive height
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width > 600
                              ? 12.0
                              : 8.0, // Responsive padding
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Contact Us',
                              style: GoogleFonts.orbitron(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 32
                                        : 24, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Email: sribalajijewellers@gmail.com\nPhone: +91 9166226916\nAddress: Bangaram Kotlu Bazaar, \nCity - Jaggayyapet',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cinzel(
                                fontSize:
                                    MediaQuery.of(context).size.width > 600
                                        ? 16
                                        : 14, // Responsive font size
                                color: Colors.white.withOpacity(0.8),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      height: MediaQuery.of(context).size.width > 600
                          ? screenHeight * 0.1
                          : screenHeight * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Launch your social media link here
                            },
                            child: Material(
                              elevation:
                                  8, // Adds more elevation (shadow effect)
                              shape: const CircleBorder(), // Keeps it circular
                              color: const Color.fromARGB(255, 0, 0,
                                  0), // Adds a background color like a button
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    50), // To keep the ripple effect circular
                                onTap: () {
                                  //tap facebook
                                  final whatsappLink =
                                      'https://www.facebook.com/profile.php?id=100054242660344&mibextid=ZbWKwL';
                                  launch(whatsappLink);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? screenHeight * 0.06
                                          : screenHeight * 0.07,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? screenHeight * 0.06
                                      : screenHeight * 0.07,
                                  child: const Padding(
                                    padding: EdgeInsets.all(
                                        8.0), // Adds padding around the logo to give button-like feel
                                    child: CircleAvatar(
                                      radius: 20, // Size of the circular button
                                      backgroundImage: NetworkImage(
                                        'https://i.pinimg.com/564x/a7/26/b7/a726b78996d835c9b913932ad2a67059.jpg', // Replace with logo URL
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Launch your social media link here
                            },
                            child: Material(
                              elevation:
                                  8, // Adds more elevation (shadow effect)
                              shape: const CircleBorder(),
                              color: const Color.fromARGB(255, 0, 0,
                                  0), // Adds a background color like a button
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  // Handle tap
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? screenHeight * 0.06
                                          : screenHeight * 0.07,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? screenHeight * 0.06
                                      : screenHeight * 0.07,
                                  child: const Padding(
                                    padding: EdgeInsets.all(
                                        8.0), // Adds padding around the logo
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        'https://i.pinimg.com/736x/8f/8f/b4/8f8fb43ce828a22c91c0b59f55fb91b3.jpg', // Replace with logo URL
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Launch your social media link here
                            },
                            child: Material(
                              elevation:
                                  8, // Adds more elevation (shadow effect)
                              shape: const CircleBorder(),
                              color: const Color.fromARGB(255, 0, 0,
                                  0), // Adds a background color like a button
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  // Handle tap
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? screenHeight * 0.06
                                          : screenHeight * 0.07,
                                  width: MediaQuery.of(context).size.width > 600
                                      ? screenHeight * 0.06
                                      : screenHeight * 0.07,
                                  child: const Padding(
                                    padding: EdgeInsets.all(
                                        8.0), // Adds padding around the logo
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        'https://i.pinimg.com/736x/89/34/81/893481b49099773b537d198d284edbd2.jpg', // Replace with logo URL
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:
                          MediaQuery.of(context).size.width > 600 ? 100 : 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.width > 600
                ? 125
                : 80, // Responsive bottom position
            right: MediaQuery.of(context).size.width > 600
                ? 50
                : 10, // Responsive right position
            child: Container(
              height: MediaQuery.of(context).size.width > 600
                  ? 80
                  : 60, // Match button height dynamically
              width: MediaQuery.of(context).size.width > 600
                  ? 80
                  : 60, // Match button width dynamically
              child: RawMaterialButton(
                onPressed: () {
                  const whatsappLink =
                      'https://wa.me/919247879511?text=Hi%20Balaji%20Jewellers';
                  launch(whatsappLink);
                },
                shape: CircleBorder(),
                fillColor: Colors.white, // Background color of the button
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width > 600 ? 300 : 80,
                  minHeight: MediaQuery.of(context).size.width > 600 ? 300 : 80,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSA0W1ZrYWrI28u4z8pNVEdsD-QrbfWPn9QTs1n5amNXYEtxsrYCmsSbfjG6FuW7ZfiOU&usqp=CAU',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  container() {}
}

class CustomCarouselSlider extends StatefulWidget {
  final List<String> images;

  const CustomCarouselSlider({super.key, required this.images});

  @override
  _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final tablet = isTablet(context);

    // Responsive settings
    double carouselHeight = screenHeight * (tablet ? 0.25 : 0.23);
    double dotSize = tablet ? 8.0 : 8.0;
    double dotSpacing = tablet ? 8.0 : 5.0;
    double viewportFraction = tablet ? 0.75 : 0.8;
    double aspectRatio = tablet ? 3 / 2 : 4 / 3;
    return Column(
      children: [
        // Carousel slider
        CarouselSlider(
          options: CarouselOptions(
            height: carouselHeight, // Responsive height
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: aspectRatio, // Responsive aspect ratio
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: viewportFraction, // Responsive viewport fraction
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.images.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: double.infinity,
                  height: carouselHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(tablet ? 10.0 : 0.0),
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        // Spacer between carousel and dots
        const SizedBox(height: 20),

        // Dots for carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.map((url) {
            int index = widget.images.indexOf(url);
            return Container(
              width: dotSize,
              height: dotSize,
              margin: EdgeInsets.symmetric(horizontal: dotSpacing),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentIndex == index ? Colors.orange : Colors.grey[600],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CategoryCard extends StatefulWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tablet = isTablet(context);

    // Responsive font size
    double fontSize = tablet ? 25 : 16;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isTapped = false;
          });
          widget.onTap();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isTapped
                  ? const Color.fromARGB(0, 96, 96, 96)
                  : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              spreadRadius: isTapped ? 0 : 0,
              blurRadius: isTapped ? 0 : 0,
              offset: isTapped ? const Offset(0, 0) : const Offset(0, 3),
            ),
          ],
          color: isTapped
              ? Colors.orangeAccent
              : const Color.fromARGB(19, 145, 10, 10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 251, 247,
                        241), // Change this to your desired border color
                    width: 0, // Change this to your desired border width
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tradeWinds(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    shadows: [
                      const Shadow(
                        offset: Offset(4, 4),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExtraCategoryCard extends StatelessWidget {
  final String image1;
  final String image2;
  final VoidCallback onTapImage1;
  final VoidCallback onTapImage2;

  const ExtraCategoryCard({
    super.key,
    required this.image1,
    required this.image2,
    required this.onTapImage1,
    required this.onTapImage2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle onTap for the entire card, if needed
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.01),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 64,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                child: GestureDetector(
                  onTap: onTapImage1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      image1,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 8,
              color: Colors.grey[300],
            ),
            SizedBox(
              height: 64,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                child: GestureDetector(
                  onTap: onTapImage2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      image2,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickLinkContainer extends StatefulWidget {
  String assetBackgroundImagePath;
  String title_;
  String mainFolder_;
  String catagory_;
  QuickLinkContainer(
      {super.key,
      required this.assetBackgroundImagePath,
      required this.catagory_,
      required this.mainFolder_,
      required this.title_});

  @override
  State<QuickLinkContainer> createState() => _QuickLinkContainerState();
}

class _QuickLinkContainerState extends State<QuickLinkContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Check if the device is a tablet
    final isTablet2 = screenWidth > 600;

    // Responsive height and width for quick links
    double containerHeight2 = isTablet2 ? 270 : 150;
    double containerWidth2 = isTablet2 ? 270 : 150;
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.shortestSide >= 600
            ? MediaQuery.of(context).size.width * 0.02 // 10% for tablets
            : MediaQuery.of(context).size.width * 0.02, // 5% for phones
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommonScreen(
                title: widget.title_,
                categories: [widget.catagory_], // Wrap it in a list
                mainFolder: widget.mainFolder_,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/${widget.assetBackgroundImagePath}'),
                fit: BoxFit.cover),
            border: Border.all(
              color: Colors.white70,
              width: 0,
            ),
            // gradient: const LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [Color.fromARGB(255, 240, 231, 131), Colors.white],
            //   stops: [0.3, 1.0], // Adjust the stops as needed
            // ),
            // color: widget.color_,
          ),
          height: containerHeight2,
          width: containerWidth2,
        ),
      ),
    );
  }
}
