//SearchScreen
//final search_screen

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/Screens/profile.dart';
import 'package:jewellery/Screens/SearchResultScreen.dart';
import 'package:logger/logger.dart';
import 'package:photo_view/photo_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String input = "";
  Stream<QuerySnapshot>? searchResults;
  final CollectionReference searchCollection =
      FirebaseFirestore.instance.collection('Search');

  final FocusNode _searchFocusNode = FocusNode();
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    // Request focus on the FocusNode when the screen is initialized
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Dispose of the FocusNode when the screen is disposed
    _searchFocusNode.dispose();
    super.dispose();
  }

  //displaying image
  void _showImagePopup(
      BuildContext context, String imageUrl, String id, String weight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Stack(
              children: [
                PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
                Positioned(
                  top: 10, // Adjust the top position as needed
                  left: 10, // Adjust the left position as needed
                  child: Text(
                    "Id: $id",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 40, // Adjust the top position as needed
                  left: 10, // Adjust the left position as needed
                  child: Text(
                    "Weight: $weight",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  //end
  
bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width > 600;
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



    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar:  AppBar(
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
                  width: logoSize * 0.84, // 84% of logo size
                  height: logoSize * 0.84,
                ),
              ),
            ),
            // Center title
            Expanded(
              child: Center(
                child: Text(
                  "Sri Balaji Jewelers",
                  style: GoogleFonts.mateSc(
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
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://cdn-icons-png.freepik.com/512/10302/10302971.png',
                        width: profileImageSize,
                        height: profileImageSize,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
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
      body: Container(
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
    horizontal: MediaQuery.of(context).size.shortestSide >= 600
        ? MediaQuery.of(context).size.width * 0.08// 10% for tablets
        : MediaQuery.of(context).size.width * 0.05, // 5% for phones
        ),

          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.shortestSide >= 600
            ? MediaQuery.of(context).size.width * 0.01 // 4% for tablets
            : MediaQuery.of(context).size.width * 0.02, // 2% for phones
      ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              // Convert user input to lowercase
                              input = val.toLowerCase();
                            });
                          },
                          style: const TextStyle(
                              
                              color: Color.fromARGB(255, 255, 255, 255)),
                          decoration: const InputDecoration(
                            hintText: "Search for Ornaments",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 218, 218),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                          focusNode: _searchFocusNode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: searchCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    // Filter the documents based on the user input
                    final filteredDocs = snapshot.data!.docs.where((doc) {
                      final imageName =
                          doc['ImageName'].toString().toLowerCase();
                      return imageName.contains(input);
                    }).toList();
                    // logger.e('filteredDocs : $filteredDocs');
                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Text('No results found'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        return ListTile(
                          title: Text(doc['ImageName']),
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultScreen(
                                  title: doc['title'],
                                  categories: doc['catagory'],
                                  mainFolder: doc['mainFolder'],
                                  mainImageUrl: doc['imageUrl'],
                                ),
                              ),
                            );

                            print(doc['mainFolder']);
                            print(doc['title']);
                            print(doc['catagory']);
                            print(doc['imageUrl']);
                          },
                          onLongPress: () {
                            _showImagePopup(context, doc['imageUrl'], doc['id'],
                                doc['weight'].toString());
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    
    );
  }
}
