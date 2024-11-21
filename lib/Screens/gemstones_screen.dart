import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/Screens/common_screen.dart';

class GemStonesScreen extends StatefulWidget {
  const GemStonesScreen({super.key});

  @override
  State<GemStonesScreen> createState() => _GemStonesScreenState();
}

class _GemStonesScreenState extends State<GemStonesScreen> {
  int currentTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = '';
  final String mainFolder = 'GemStones';

  final List<String> titles = [
    'Navaratnallu',
    'Even more GemStones',
  ];

  final List<List<String>> categoriesForTitles = [
    [
      'Kempu',
      'Diamond',
      'Blue Safare',
      'Yellow Safare',
      'Hessonite',
      'Cats Eye',
      'Paral',
      'Koral',
      'Emerold',
    ],
    [
      'Rudrakshalu',
      'Spatikalu',
      'Semi Freshes',
    ],
  ];

  final Map<String, String> itemImages = {
    'Kempu': 'assets/images/Gemstone1.png',
    'Diamond': 'assets/images/Gemstone2.png',
    'Blue Safare': 'assets/images/Gemstone3.png',
    'Yellow Safare': 'assets/images/Gemstone4.png',
    'Hessonite': 'assets/images/Gemstone5.png',
    'Cats Eye': 'assets/images/Gemstone6.png',
    'Paral': 'assets/images/Gemstone7.png',
    'Koral': 'assets/images/Gemstone8.png',
    'Emerold': 'assets/images/Gemstone9.png',
    'Rudrakshalu': 'assets/images/Gemstone10.png',
    'Spatikalu': 'assets/images/Gemstone11.png',
    'Semi Freshes': 'assets/images/Gemstone12.png',
  };

  void scrollToCategory(String category) {
    final index = categoriesForTitles[currentTabIndex].indexOf(category);
    if (index != -1) {
      _scrollController.animateTo(
        index * 80.0, // Adjust for your itemHeight
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: Text(
            mainFolder,
            style: GoogleFonts.cinzel(
              textStyle: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: MediaQuery.of(context).size.width < 600 ? 21 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        leading: BackButton(
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pop(context);
          },
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
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                    categoriesForTitles: categoriesForTitles[currentTabIndex],
                  ),
                ).then((selectedCategory) {
                  if (selectedCategory != null && selectedCategory.isNotEmpty) {
                    scrollToCategory(selectedCategory);
                    setState(() {
                      this.selectedCategory = selectedCategory;
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return Container(
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
                  child: ListView.builder(
                    itemCount: titles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentTabIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: currentTabIndex == index
                                ? Colors.orange
                                : Colors.white70,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: currentTabIndex == index
                                  ? Colors.orange
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              titles[index],
                              style: GoogleFonts.mateSc(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: currentTabIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // MAIN BODY
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: categoriesForTitles[currentTabIndex].length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, itemIndex) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 30.0 : 15.0,
                          vertical: isTablet ? 8.0 : 3.0,
                        ),
                        child: Card(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: const BorderSide(color: Colors.orangeAccent, width: 0.0),
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
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20.0 : 10.0,
                                vertical: isTablet ? 10.0 : 10.0,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: isTablet ? 60 : 60,
                                    height: isTablet ? 60 : 60,
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16.0),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          itemImages[categoriesForTitles[currentTabIndex][itemIndex]]!,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          categoriesForTitles[currentTabIndex][itemIndex],
                                          style: GoogleFonts.mateSc(
                                            textStyle: TextStyle(
                                              fontSize: isTablet ? 20 : 18,
                                              fontWeight: FontWeight.normal,
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                            ),
                                          ),
                                        ),
                                      ],
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> categoriesForTitles;

  CustomSearchDelegate({required this.categoriesForTitles});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = categoriesForTitles
        .where((category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? categoriesForTitles
        : categoriesForTitles
            .where((category) => category.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }
}
