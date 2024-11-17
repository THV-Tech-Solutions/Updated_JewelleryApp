import 'package:flutter/material.dart';
import 'package:jewellery/Screens/common_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RoseGoldScreen extends StatefulWidget {
  const RoseGoldScreen({super.key});

  @override
  _RoseGoldScreenState createState() => _RoseGoldScreenState();
}

class _RoseGoldScreenState extends State<RoseGoldScreen> {
  bool isCategorySelected = false;
  String selectedCategory = '';
  final TextEditingController searchController = TextEditingController();
  List<String> filteredTitles = [];
  final ScrollController _scrollController = ScrollController();

  final String mainFolder = 'RoseGold';

  final List<String> titles = [
    'Ladies Rings',
    'Gents Rings',
    'Necklace',
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
  ];

  final List<List<String>> categoriesForTitles = [
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Chains'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Ladies', 'Gents'],
    ['Ladies', 'Gents'],
    ['Short Length', 'Long Length'],
    ['DD Balls Chains'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Stones', 'Plain'],
    ['Chandra Haralu'],
  ];

  @override
  void initState() {
    super.initState();
    filteredTitles = List.from(titles); // Initialize with all categories
  }

  void filterCategories(String query) {
    setState(() {
      filteredTitles = titles
          .where((title) => title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void scrollToCategory(String category) {
    final index = filteredTitles.indexOf(category);
    if (index != -1) {
      final itemHeight =
          MediaQuery.of(context).size.height * 0.12; // Dynamic height
      _scrollController.animateTo(
        index * itemHeight,
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
        elevation: 0,
        title: Center(
          child: Text(
            mainFolder,
            style: GoogleFonts.cinzel(
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
                  delegate: CustomSearchDelegate(titles: titles),
                ).then((selectedCategory) {
                  if (selectedCategory != null) {
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
            child: ListView.separated(
              controller: _scrollController,
              itemCount: filteredTitles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index < filteredTitles.length) {
                  final category = filteredTitles[index];
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
                            color: Colors.orangeAccent,width: 0.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (index >= titles.length) return; // Safeguard
                          setState(() {
                            selectedCategory = titles[index];
                            isCategorySelected = true;
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              setState(() {
                                isCategorySelected = false;
                              });
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommonScreen(
                                  title: titles[index],
                                  categories: categoriesForTitles[index],
                                  mainFolder: mainFolder,
                                ),
                              ),
                            );
                          });
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
                              Container(
                                width: isTablet ? 60 : 60,
                                height: isTablet ? 60 : 60,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16.0),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/RoseGold${index + 1}.png',
                                    ),
                                    onError: (_, __) => const AssetImage(
                                        'assets/images/default.png'),
                                    fit: BoxFit.contain,
                                  ),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 255, 255, 255),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      titles[index],
                                      style: GoogleFonts.mateSc(
                                        textStyle: TextStyle(
                                          fontSize: isTablet
                                              ? 20
                                              : 18,
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
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> titles;

  CustomSearchDelegate({required this.titles});

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
    final suggestionList = titles
        .where((title) => title.toLowerCase().contains(query.toLowerCase()))
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
        ? titles
        : titles
            .where((title) => title.toLowerCase().contains(query.toLowerCase()))
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