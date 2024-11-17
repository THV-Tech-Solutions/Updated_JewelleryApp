import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/Screens/common_screen.dart';

class SilverScreen extends StatefulWidget {
  const SilverScreen({super.key});

  @override
  State<SilverScreen> createState() => _SilverScreenState();
}

class _SilverScreenState extends State<SilverScreen> {
  final String mainFolder = 'Silver';
  int currentTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = '';
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();


  final List<String> titles = [
    'Silver Articles',
    'Sterling Silver',
    'Temple Items'
  ];
  final List<List<String>> categoriesForTitles = [
    [
      'Plates',
      'Glasses',
      'Stand Kundhulu',
      'Pancha Patra',
      'Vodharani',
      'AshtaLakshmi Chombu',
      'Plain Chambu',
      'Vigraharalu',
      'Simhasanalu',
      'Short Kundhulu',
      'Agarabathi Stand',
      'Pula Butta',
      'Powder Box',
      'Pattilu',
      'Kadiyalu',
      'Molathallu',
      'Gantalu',
      'Harathi Stands',
      'Pens',
      'Jugs',
      'Bindhalu',
      'Chains',
      'Flowers',
      'Photo Frames',
      'Seta Gopuram',
      'Kiritalu',
      'Bowls',
      'Kunkama Barani',
      'Thamalapakulu',
      'Arati Chetlu',
      'Kobbari Chetlu',
      'Dinner Sets',
      'Eyes', /* ... Add your items here ... */
    ],
    [
      
      'Gents Rings',
      'Ladies Rings',
      'Necllace',
      'Chains',
      'Harams',
      'Bangles',
      'Chowker Lockets',
      'Chain Lockets',
      'Vadranam',
      'Aravanki',
      'Bracelets',
      'Kadiyalu',
      'Nallapursalu',
      'DD Balls Chains',
      'Black Beats',
      'Jukalu',
      'Buttalu',
      'Diddulu',
      'Chandh Bali',
      'Saniya Rings',
      'Matilu',
      'Champaswaralu',
      'Chevi Chutlu',
      'Chandra Haralu',
            /* ... Add your items here ... */
    ],
    [
      'Kireetalu',
      'Hasthalu',
      'Vakshasthalam',
      'Kaallu',
      'Nagum Podagalu',
      'paadhalu',
      'kallu',
      'Makarathoranalu',
      'Petalu',
      'Simhasanalu',
      /* ... Add your items here ... */
    ],
  ];

  final List<List<String>> itemImages = [
    [
      'SilverArticles1.png',
      'SilverArticles2.png',
      'SilverArticles3.png',
      'SilverArticles4.png',
      'SilverArticles5.png',
      'SilverArticles6.png',
      'SilverArticles7.png',
      'SilverArticles8.png',
      'SilverArticles9.png',
      'SilverArticles10.png',
      'SilverArticles11.png',
      'SilverArticles12.png',
      'SilverArticles13.png',
      'SilverArticles14.png',
      'SilverArticles15.png',
      'SilverArticles16.png',
      'SilverArticles17.png',
      'SilverArticles18.png',
      'SilverArticles19.png',
      'SilverArticles20.png',
      'SilverArticles21.png',
      'SilverArticles22.png',
      'SilverArticles23.png',
      'SilverArticles24.png',
      'SilverArticles25.png',
      'SilverArticles26.png',
      'SilverArticles27.png',
      'SilverArticles28.png',
      'SilverArticles29.png',
      'SilverArticles30.png',
      'SilverArticles31.png',
      'SilverArticles32.png',
      'SilverArticles33.png',
      /* ... Add your image paths here ... */
    ],
    [
      
      
      'SterlingSilver34.png',
      'SterlingSilver35.png',
      'SterlingSilver36.png',
      'SterlingSilver37.png',
      'SterlingSilver38.png',
      'SterlingSilver39.png',
      'SterlingSilver40.png',
      'SterlingSilver41.png',
      'SterlingSilver42.png',
      'SterlingSilver43.png',
      'SterlingSilver44.png',
      'SterlingSilver45.png',
      'SterlingSilver46.png',
      'SterlingSilver47.png',
      'SterlingSilver48.png',
      'SterlingSilver49.png',
      'SterlingSilver50.png',
      'SterlingSilver51.png',
      'SterlingSilver52.png',
      'SterlingSilver53.png',
      'SterlingSilver54.png',
      'SterlingSilver55.png',
      'SterlingSilver56.png',
      'SterlingSilver57.png',
      'SterlingSilver49.png',
      'SterlingSilver50.png',
      'SterlingSilver51.png',
      'SterlingSilver52.png',
      'SterlingSilver53.png',
      'SterlingSilver54.png',
      'SterlingSilver55.png',
      'SterlingSilver56.png',
      'SterlingSilver57.png',
      'SterlingSilver56.png',
      'SterlingSilver57.png',
      /* ... Add your image paths here ... */
    ],
    [
      'TempleItems58.png',
      'TempleItems59.png',
      'TempleItems60.png',
      'TempleItems61.png',
      'TempleItems62.png',
      'TempleItems63.png',
      'TempleItems64.png',
      'TempleItems65.png',
      'TempleItems66.png',
      'TempleItems67.png',
      

      /* ... Add your image paths here ... */
    ],
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToCategory(String category) {
    final index = categoriesForTitles[currentTabIndex].indexOf(category);
    if (index != -1) {
      _scrollController.animateTo(
        index.toDouble() * 95.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: Text(
            mainFolder,
            style:GoogleFonts.cinzel(
              textStyle: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: MediaQuery.of(context).size.width < 600
                    ? 21
                    : 30, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 30,
              ),
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                    categoriesForTitles: categoriesForTitles[currentTabIndex],
                  ),
                ).then(
                  (selectedCategory) {
                    if (selectedCategory != null &&
                        selectedCategory.isNotEmpty) {
                      scrollToCategory(selectedCategory);
                      setState(() {
                        this.selectedCategory = selectedCategory;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 58, 40, 0)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
        child: Column(
          children: [
            // CUSTOM TABBAR
           Container(
  margin: const EdgeInsets.all(10),
  width: double.infinity,
  height: 60,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Even distribution of the items
    children: List.generate(titles.length, (index) {
      // Get the screen width to apply conditional values for mobile/tablet
      double screenWidth = MediaQuery.of(context).size.width;

      // Define margin and padding based on screen width
      double horizontalMargin = screenWidth < 600 ? 5.0 : 15.0; // Smaller margin on mobile
      double horizontalPadding = screenWidth < 600 ? screenWidth * 0.04 : screenWidth * 0.05; // Less padding on mobile

      return Flexible(
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentTabIndex = index;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin), // Adjust margin based on screen size
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding), // Adjust padding based on screen size
            decoration: BoxDecoration(
              color: currentTabIndex == index
                  ? const Color.fromARGB(255, 209, 209, 209)
                  : const Color.fromARGB(179, 0, 0, 0),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: currentTabIndex == index
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 255, 255, 255),
                width: 1,
              ),
            ),
            child: Center(  // Centers the text
              child: Text(
                 textAlign: TextAlign.center,
                titles[index],
                style: GoogleFonts.mateSc(
                  textStyle: TextStyle(
                    fontSize: screenWidth < 600 ? screenWidth * 0.035 : screenWidth * 0.02,
                    fontWeight: FontWeight.w500,
                    color: currentTabIndex == index
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }),
  ),
),

            // MAIN BODY
            Expanded(
              child: AnimatedList(
                key: _listKey,
                controller: _scrollController,
                initialItemCount: categoriesForTitles[currentTabIndex].length,
               itemBuilder: (context, itemIndex, animation) {
  // Ensure that itemIndex does not exceed the bounds of the itemImages list
  int maxItemIndex = categoriesForTitles[currentTabIndex].length - 1;
  if (itemIndex > maxItemIndex) return SizedBox(); // Prevent building out-of-bounds items
  
  return LayoutBuilder(
    
    builder: (context, constraints) {
      final isTablet = constraints.maxWidth > 600;
      return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width < 600
                          ? 15.0
                          : 30.0, // Horizontal padding for mobile vs tablet
                      vertical: MediaQuery.of(context).size.width < 600
                          ? 3.0
                          : 8.0, // Vertical padding for mobile vs tablet
                    ),
        child: Card(
          color: const Color.fromARGB(255, 0, 0, 0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(
              color: Colors.orangeAccent,
              width: 0.0,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonScreen(
                    title: titles[currentTabIndex],
                    categories: [
                      categoriesForTitles[currentTabIndex][itemIndex]
                    ],
                    mainFolder: mainFolder,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 
                            MediaQuery.of(context).size.width < 600
                                ? 10.0
                                : 20.0,
                                vertical: MediaQuery.of(context).size.width < 600
                                ? 10.0
                                : 10.0,
                          ),
              child: Row(
                children: [
                  // Check if the image exists before trying to use it
                  itemIndex < itemImages[currentTabIndex].length
                      ? Container(
                            width: isTablet ? 60 : 60, // Responsive width
                                height: isTablet ? 60 : 60, // Responsive height
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/${itemImages[currentTabIndex][itemIndex]}',
                              ),
                              fit: BoxFit.cover,
                              
                            ),
                             border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 255, 255, 255),
                                    width: 1.0,
                                  ),
                          ),
                        )
                      : SizedBox(), // Return an empty box if no image is available
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      categoriesForTitles[currentTabIndex][itemIndex],
                       style: GoogleFonts.mateSc(
                                        textStyle: TextStyle(
                                          fontSize: isTablet
                                              ? 20
                                              : 18, // Responsive font size
                                          fontWeight: FontWeight.normal,
                                          color: const Color.fromARGB(255, 255, 255, 255),
                                        ),
                      ),
                    ),
                  ),
                   const Icon(
                                Icons.double_arrow,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
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

class CustomSearchDelegate extends SearchDelegate<String?> {
  final List<String> categoriesForTitles;

  CustomSearchDelegate({required this.categoriesForTitles});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = categoriesForTitles
        .where((category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = categoriesForTitles
        .where((category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
          },
        );
      },
    );
  }
}
