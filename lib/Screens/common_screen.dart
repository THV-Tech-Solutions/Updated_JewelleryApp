//final_Common_Screen

//final_common_screen

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewellery/HelperFunctions/Toast.dart';
import 'package:logger/logger.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonScreen extends StatefulWidget {
  final String mainFolder;
  final String title;
  final List<String> categories;

  const CommonScreen(
      {super.key,
      required this.title,
      required this.categories,
      required this.mainFolder});

  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen>
    with SingleTickerProviderStateMixin {
  static String selectedCategory = '';
  String generatedId = '';
  final firestore = FirebaseFirestore.instance;
  late int selectedTabIndex; // Track the selected tab index
  final storage = FirebaseStorage.instance;
  Map<String, List<DocumentReference>> imageUrlsByCategory =
      {}; // Store fetched image URLs

  late TabController tabController; // Declare TabController
  List<String> selectedImages = []; // Track selected images
  bool isSelectionMode = false; //Track Multiple images select option
  int currentCount = 0;
  double weight = 0;
  Map<String, dynamic> imageUrlCache = {};
  List<SelectedItem> selectedItems = [];
  List<String> isInWishlist = [];
  bool isLoading = false;
  var logger = Logger();
  bool ifMove = false;

  String? _Admin;
  String? userPhoneNumber;
  String? userName;
  bool isAdmin = false;
  String? isMove = '';
  int catagoryImagescount = 0;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories[0];
    _loadImagesForCategory(selectedCategory);
    tabController = TabController(
      length: widget.categories.length,
      vsync: this, // Provide the SingleTickerProviderStateMixin
    );
    tabController.addListener(_handleTabChange); // Listen to tab changes
    getUserDataFromSharedPreferences();
    // var Height = MediaQuery.of(context).size.height - 100;
    // var Width = MediaQuery.of(context).size.width - 100;
    // print("height : $Height");
    // print("width : $Width");
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _Admin = prefs.getString('Admin');
      userPhoneNumber = prefs.getString('userPhoneNumber');
      userName = prefs.getString('userName');
      isMove = prefs.getString('isMove');
      print("isMove : $isMove");

      print("$userPhoneNumber $userName $_Admin");
      if (_Admin == 'Admin' || _Admin == 'Admin2' || _Admin != null) {
        setState(() {
          isAdmin = true;
          print(isAdmin);
        });
      }

      if (isMove == 'true') {
        setState(() {
          ifMove = true;
          print("ifMove : $ifMove");
        });
      }
      else{
        setState(() {
          ifMove = false;
          print("ifMove : $ifMove");
        });
      }
    });
  }

  void _loadImagesForCategory(String category) async {
    try {
      final QuerySnapshot categoryQuery = await FirebaseFirestore.instance
          .collection(widget.mainFolder)
          .doc(widget.title)
          .collection(category) // Use the provided category argument
          .where('imageUrl', isNotEqualTo: null)
          .orderBy('TimeStamp', descending: true)
          .get();

      final List<DocumentReference> refs = categoryQuery.docs
          .map((doc) => doc.reference)
          .where((ref) => ref != null)
          .toList();

      setState(() {
        imageUrlsByCategory[category] = refs.cast<DocumentReference>();
        print("START");
        print(imageUrlsByCategory[category]);
        print("FINISH ");
      });
    } catch (e) {
      logger.e('Error fetching images', error: e);
    }
  }

  void _handleTabChange() {
    setState(() {
      selectedCategory =
          widget.categories[tabController.index]; // Update selected category
      print(selectedCategory);
    });

    if (!imageUrlsByCategory.containsKey(selectedCategory)) {
      _loadImagesForCategory(selectedCategory);
    }
  }

  @override
  void dispose() {
    tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  void _showImagePopup(
      BuildContext context, String imageUrl, String id, String weight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400,
            height: 400, // Specify the height here
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Weight: $weight",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Id: $id",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> fetchTotalFromCatagory() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference docRef = firestore
        .collection('Calculation')
        .doc(widget.mainFolder)
        .collection(widget.title)
        .doc(selectedCategory)
        .collection('numberOfDocuments')
        .doc('numberOfDocuments');

    try {
      await firestore.runTransaction((transaction) async {
        // Get the current document
        DocumentSnapshot docSnapshot = await transaction.get(docRef);

        // Check if the document exists
        if (docSnapshot.exists) {
          // Access the "numberOfDocuments" field
          currentCount = docSnapshot['numberOfDocuments'];
        } else {
          // If the document doesn't exist, create it with a count of 1
          transaction.set(docRef, {'numberOfDocuments': 1});
        }
      });

      print('numberOfDocuments feteched from Firestore.');
    } catch (error) {
      print('Error updating numberOfDocuments: $error');
    }

    return currentCount;
  }

  Future<void> _uploadImageToFirebase(String imageUrls) async {
    int total = await fetchTotalFromCatagory();
    print("fetched total from firestore $total");
    // Generate a new ID with updated image count

    await showNumberInputDialog(context, "Enter Weight");

    String generatedId = await _generateId(total + 1);

    String formattedWeight = weight.toStringAsFixed(3);

    print(selectedCategory);
    final storageRef = storage.ref().child(
        '${widget.mainFolder}/${widget.title}/$selectedCategory/${widget.mainFolder + widget.title + selectedCategory + generatedId}');
    try {
      final uploadTask = storageRef.putFile(File(imageUrls));
      await uploadTask.whenComplete(() async {
        logger.i('Image uploaded successfully');

        // Get the download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();

        // Store the image reference in Firestore
        await firestore
            .collection(widget.mainFolder)
            .doc(widget.title)
            .collection(selectedCategory)
            .add({
          'mainFolder': widget.mainFolder,
          'title': widget.title,
          'catagory': selectedCategory,
          'imageUrl': imageUrl,
          'id': generatedId,
          'weight': formattedWeight,
          'ImageName':
              widget.mainFolder + widget.title + selectedCategory + generatedId,
          'TimeStamp': Timestamp.now(),
        });

        // Reload the images for the current category
        _loadImagesForCategory(selectedCategory);

        // Update image count for the selected category
        await firestore
            .collection('Calculation')
            .doc(widget.mainFolder)
            .collection(widget.title)
            .doc(selectedCategory)
            .collection('numberOfDocuments')
            .doc('numberOfDocuments')
            .update({
          'numberOfDocuments': FieldValue.increment(1),
        }).then((value) {
          print('TotalChanddha updated in Firestore.');
        }).catchError((error) {
          print('Error');
        });

        //saving data in search collection
        await firestore.collection('Search').add({
          'mainFolder': widget.mainFolder,
          'title': widget.title,
          'catagory': selectedCategory,
          'imageUrl': imageUrl,
          'id': generatedId,
          'weight': formattedWeight,
          'ImageName':
              widget.mainFolder + widget.title + selectedCategory + generatedId,
          'TimeStamp': Timestamp.now(),
        }).then((value) {
          print(' updated  search collection in Firestore.');
        }).catchError((error) {
          print('Error while updaing search collection in firestore');
        });
      });
    } catch (e) {
      logger.e('Error uploading image', error: e);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<String> _generateId(int total) async {
    print("total in generate ud : $total");
    String mainFolderFirstLetter = widget.mainFolder.substring(0, 1);
    String titleFirstLetter =
        widget.title.split(' ').map((word) => word.substring(0, 1)).join('');
    String categoryFirstLetter = selectedCategory.substring(0, 1);

    String id =
        '$mainFolderFirstLetter$titleFirstLetter$categoryFirstLetter$total';
    print("id : $id");
    return id;
  }

  Future<void> _shareSelectedImages() async {
    if (selectedImages.isNotEmpty) {
      final List<String> imageFiles = [];

      for (final imageRef in selectedImages) {
        final filePath = await _downloadImage(imageRef);
        if (filePath.isNotEmpty) {
          imageFiles.add(filePath);
        }
      }

      if (imageFiles.isNotEmpty) {
        Share.shareFiles(imageFiles);
      } else {
        // Handle the case when no images could be downloaded.
        print('No images to share.');
      }
    }
    setState(() {
      isLoading = false;
      selectedImages.clear();
      isSelectionMode = false;
    });
  }

  Future<String> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }

    return ''; // Return an empty string if there's an error
  }

  Future<void> _customShare(double numberOfImages) async {
    if (numberOfImages <= 0) {
      // Handle invalid input, e.g., show an error message to the user.
      return;
    }

    try {
      final List<String> imageUrls =
          await _fetchImageUrlsFromFirestore(numberOfImages);

      if (imageUrls.isNotEmpty) {
        final List<String> imageFiles = [];

        for (final imageUrl in imageUrls) {
          final filePath = await _downloadImage(imageUrl);
          imageFiles.add(filePath);
        }

        Share.shareFiles(imageFiles);
      } else {
        Fluttertoast.showToast(
          msg: "No Images found in Database",
          toastLength: Toast.LENGTH_SHORT, // Duration for the toast message
          gravity: ToastGravity.BOTTOM, // Position of the toast message
          backgroundColor: Colors.red, // Background color of the toast
          textColor: Colors.white, // Text color of the toast
          fontSize: 16.0, // Font size of the toast text
        );
      }
    } catch (e) {
      // Handle any errors that occur during sharing or fetching images.
      print('Error sharing images: $e');
      rethrow; // Rethrow the error to be caught by the FutureBuilder
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> _fetchImageUrlsFromFirestore(
      double numberOfImages) async {
    final List<String> imageUrls = [];

    try {
      final folderName =
          '${widget.mainFolder}/${widget.title}/$selectedCategory';
      final collectionRef = firestore
          .collection(widget.mainFolder)
          .doc(widget.title)
          .collection(selectedCategory);

      final querySnapshot = await collectionRef
          .orderBy('TimeStamp', descending: true)
          .limit(numberOfImages.toInt())
          .get();

      for (final docSnapshot in querySnapshot.docs) {
        final imageUrl = docSnapshot.get('imageUrl') as String;
        imageUrls.add(imageUrl);
      }
    } catch (e) {
      // Handle any errors that occur during Firestore access.
      // You can show an error message or take other appropriate actions.
      print('Error fetching images from Firestore: $e');
    }

    return imageUrls;
  }

  Future<void> showNumberInputDialog(BuildContext context, String name) async {
    setState(() {
      isLoading = false;
    });

    double? InputNumber;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get the screen width to make it responsive
        double width = MediaQuery.of(context).size.width;
        double dialogWidth = width < 600
            ? width * 0.85
            : width * 0.5; // Adjust width for mobile vs tablet
        double fontSize =
            width < 600 ? 18 : 22; // Adjust font size based on device size

        return Dialog(
          backgroundColor:
              Colors.transparent, // Transparent background for dialog
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Rounded corners for the dialog
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0), // Black
                  Color.fromARGB(139, 96, 67, 6), // Dark Gold
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0), // Circular border
            ),
            width: dialogWidth,
            padding: EdgeInsets.all(width < 600
                ? 16.0
                : 24.0), // Adjust padding for mobile vs tablet
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white, // Light title text
                    fontSize: fontSize, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Input field with a dark background and light text
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white), // Input text color
                  decoration: InputDecoration(
                    labelText: 'Number',
                    labelStyle:
                        TextStyle(color: Colors.white60), // Light label color
                    filled: true,
                    fillColor: const Color.fromARGB(
                        255, 6, 6, 6), // Dark background for input
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Circular border before selection
                      borderSide: BorderSide(
                          color: Colors
                              .transparent), // Transparent border before selection
                    ),
                    // When focused, show a border
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1), // White border when focused
                    ),
                    // No border when not focused (optional, using transparent border above)
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Rounded corners before focus
                      borderSide: BorderSide(
                          color: Colors
                              .transparent), // No visible border before selection
                    ),
                    // Optional: Disabled border if the field is disabled
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                      borderSide: BorderSide(
                          color: Colors
                              .transparent), // No visible border if disabled
                    ),
                  ),
                  onChanged: (value) {
                    InputNumber = double.tryParse(value);
                  },
                ),

                SizedBox(height: 20),

                // Buttons (Cancel and OK)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey[700], // Dark button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 10), // Space between buttons on larger screens
                    // OK button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (InputNumber != null) {
                            setState(() {
                              isLoading = true;
                            });

                            switch (name) {
                              case "Enter Number":
                                _customShare(InputNumber!);
                                break;
                              case "Enter Weight":
                                weight = InputNumber!;
                                break;
                              case "Enter New Weight":
                                String formattedWeight =
                                    InputNumber!.toStringAsFixed(3);
                                _editWeight(formattedWeight);

                                break;
                              default:
                                break;
                            }
                            Navigator.of(context).pop();
                          }else{
                            ToastMessage.toast_('Enter valid weight.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Highlighted color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> toggleWishlist(imageUrl, id, weight) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final collection = firestore
          .collection('Wishlist')
          .doc(userPhoneNumber)
          .collection('Wishlist');

      final existingDoc = await collection
          .where('imageUrl', isEqualTo: imageUrl)
          .limit(1)
          .get();

      if (existingDoc.docs.isNotEmpty) {
        // Item exists in the wishlist, remove it
        await collection.doc(existingDoc.docs.first.id).delete();
        setState(() {
          isInWishlist.remove(imageUrl); // Remove from the list
        });
      } else {
        // Item does not exist in the wishlist, add it
        await collection.add({
          'imageUrl': imageUrl,
          'id': id,
          'weight': weight,
        });
        setState(() {
          isInWishlist.add(imageUrl); // Add to the list
        });
      }
    } catch (e) {
      print('Error toggling wishlist: $e');
    }
  }

  Future<int> _countImagesInCategory(String category) async {
    // Count the number of images in the specified category
    final imageUrls = imageUrlsByCategory[category];
    return imageUrls?.length ?? 0;
  }

  Future<void>? restoreFromRecycleBin() async {
    final recyclemainCollection = firestore.collection('RecycleBin');
    final recycleBinCollection =
        recyclemainCollection.doc('RecycleBin').collection('RecycleBin');

    for (final imageUrl in selectedImages) {
      try {
        final existingDoc = await recycleBinCollection
            .where('imageUrl', isEqualTo: imageUrl)
            .limit(1)
            .get();
        print('outside');
        if (existingDoc.docs.isNotEmpty) {
          print('inside');
          print(existingDoc);
          final docData = existingDoc.docs.first.data();
          print('docData L: $docData');

          final mainFolder = docData['mainFolder'] as String;
          final title = docData['title'] as String;
          final catagory = docData['catagory'] as String;
          print('data from doc : $mainFolder $title $catagory');

          final mainCollection = firestore.collection(mainFolder);
          final collection = mainCollection.doc(title).collection(catagory);

          // Move the item back to the original collection
          await collection.add(docData);
          await recycleBinCollection.doc(existingDoc.docs.first.id).delete();
        } else {
          print('Error Restoring item from Recycle Bin: Item not found');
        }
      } catch (e) {
        print('Error Restoring item from Recycle Bin: $e');
      }
    }
    setState(() {
      _loadImagesForCategory(selectedCategory);
      isLoading = false;
    });
    Fluttertoast.showToast(
      msg: "Images Restored Successfully!",
      toastLength: Toast.LENGTH_SHORT, // Duration for the toast message
      gravity: ToastGravity.BOTTOM, // Position of the toast message
      backgroundColor: Colors.red, // Background color of the toast
      textColor: Colors.white, // Text color of the toast
      fontSize: 16.0, // Font size of the toast text
    );
  }

  //refresh the screen by navigating to same screen again;
  void refreshScreen(BuildContext context) {
    print("refresh screen");
    try {

      print('mainFolder: ${widget.mainFolder}');
      print('title: ${widget.title}');
      print('catagory : ${widget.categories}');

      // Use a Future to delay the navigation
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommonScreen(
              title: widget.title,
              categories: widget.categories,
              mainFolder: widget.mainFolder,
            ),
          ),
        );
      });
    } catch (e) {
      print("error in refresh screen $e");
    }
  }

  void refreshBuild() {
    print("refresh Build");
    setState(() {
      // Trigger the rebuild
    });
  }

  void _editWeight(String newWeight) async {
    final collection = firestore.collection(widget.mainFolder);
    final path = collection.doc(widget.title).collection(selectedCategory);

    // Create a copy of the list to avoid concurrent modification
    final imagesToEdit = List<String>.from(selectedImages);

    for (final imageUrl in imagesToEdit) {
      try {
        final existingDoc =
            await path.where('imageUrl', isEqualTo: imageUrl).limit(1).get();

        if (existingDoc.docs.isNotEmpty) {
          final docData = existingDoc.docs.first.data();
          final oldWeight = docData['weight'] as String;
          print('oldWeight : $oldWeight');

          path
              .doc(existingDoc.docs.first.id)
              .set({'weight': newWeight}, SetOptions(merge: true));
          setState(() {
            // _loadImagesForCategory(selectedCategory);
            isSelectionMode = false;
            selectedImages.clear();
            isLoading = false;
          });
        }
        Fluttertoast.showToast(
          msg: "Weight edited successfully",
          toastLength: Toast.LENGTH_SHORT, // Duration for the toast message
          gravity: ToastGravity.BOTTOM, // Position of the toast message
          backgroundColor: Colors.red, // Background color of the toast
          textColor: Colors.white, // Text color of the toast
          fontSize: 16.0, // Font size of the toast text
        );

        refreshScreen(context);
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT, // Duration for the toast message
          gravity: ToastGravity.BOTTOM, // Position of the toast message
          backgroundColor: Colors.red, // Background color of the toast
          textColor: Colors.white, // Text color of the toast
          fontSize: 16.0, // Font size of the toast text
        );
      }
    }
  }

  void _moveImagesToOtherCategory() async {
    final collection_ = FirebaseFirestore.instance.collection('tempCollection');
    final path_ =
        collection_.doc('tempCollection').collection('tempCollection');

    final newCollection_ = firestore.collection(widget.mainFolder);
    final newpath_ =
        newCollection_.doc(widget.title).collection(selectedCategory);

    final documents = await path_.get();

    for (final document in documents.docs) {
      try {
        final documentData = document.data();
        final docId = document.id;
        print('document Data : $documentData');
        // Update the fields in the document
        await path_.doc(docId).set(
          {
            'mainFolder': widget.mainFolder,
            'title': widget.title,
            'catagory': selectedCategory
          },
        );

// Verify the updated data
        final updatedDocument = await path_.doc(docId).get();
        final updatedDocumentData = updatedDocument.data();
        print('Updated document data: $updatedDocumentData');

        // Delete the document from the original location
        await path_.doc(docId).delete();
        print('Deleted document with ID: $docId');

        // Add the updated document to the new location
        await newpath_.doc(docId).set(documentData);
        print('Added document to new location with ID: $docId');
      } catch (e) {
        print('Error updating or moving document: $e');
      }
      //making paste button false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('isMove', 'false');
      setState(() {
        _loadImagesForCategory(selectedCategory);
        isLoading = false;
        ifMove = false;
      });
      Fluttertoast.showToast(
        msg: "Images Moved Successfully!",
        toastLength: Toast.LENGTH_SHORT, // Duration for the toast message
        gravity: ToastGravity.BOTTOM, // Position of the toast message
        backgroundColor: Colors.red, // Background color of the toast
        textColor: Colors.white, // Text color of the toast
        fontSize: 16.0, // Font size of the toast text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.categories.length,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          leading: BackButton(
            color: Colors
                .white, // White color for BackButton to fit the dark theme
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black, // Dark background color for the AppBar
          title: Text(
            widget.title, // Display only the selectedCategory
            style: GoogleFonts.rowdies(
              textStyle: TextStyle(
                color: Colors
                    .white, // White text for contrast against dark background
                fontSize: MediaQuery.of(context).size.shortestSide < 600
                    ? 18
                    : 22, // Adjust font size based on screen size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                if (isSelectionMode) {
                  setState(() {
                    isLoading = true;
                  });
                  _shareSelectedImages();
                } else {
                  Fluttertoast.showToast(
                    msg: "Oops, No image selected to share",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              icon: const Icon(
                FontAwesomeIcons.share,
                color: Colors.green,
                size: 30,
              ),
            ),
            if (_Admin == 'Admin') ...[
              if (isSelectionMode) ...[
                IconButton(
                  onPressed: () async {
                    if (selectedImages.length > 1) {
                      Fluttertoast.showToast(
                        msg:
                            "You selected ${selectedImages.length} images. Please select only 1 image to edit the weight",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else if (selectedImages.length == 1) {
                      showNumberInputDialog(context, "Enter New Weight");
                    } else {
                      print('error');
                    }
                  },
                  icon: const Icon(
                    FontAwesomeIcons.penToSquare,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ],
            if (isAdmin) ...[
              PopupMenuButton<String>(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                offset: const Offset(40, 0),
                color: Colors.black, // Dark background for the popup menu
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    if (widget.mainFolder != 'RecycleBin') ...[
                      PopupMenuItem<String>(
                        value: 'custom_share',
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            showNumberInputDialog(context, "Enter Number");
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.link,
                                  color: Colors
                                      .green, // Green icon for custom share
                                  size:
                                      MediaQuery.of(context).size.shortestSide <
                                              600
                                          ? 20
                                          : 24, // Responsive icon size
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Custom Share',
                                  style: TextStyle(
                                    color: Colors
                                        .green, // Green text for custom share
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 14
                                        : 16, // Responsive text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);

                            showDeleteConfirmationDialog('RecycleBin',
                                'RecycleBin', 'RecycleBin', 'Delete');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red, // Red icon for delete
                                  size:
                                      MediaQuery.of(context).size.shortestSide <
                                              600
                                          ? 20
                                          : 24, // Responsive icon size
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red, // Red text for delete
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 14
                                        : 16, // Responsive text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Move',
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);

                            showDeleteConfirmationDialog('tempCollection',
                                'tempCollection', 'tempCollection', 'Move');
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('isMove', 'true');
                            print("isMove : $isMove");
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.route,
                                  color: Colors.red, // Red icon for Move
                                  size:
                                      MediaQuery.of(context).size.shortestSide <
                                              600
                                          ? 20
                                          : 24, // Responsive icon size
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Move',
                                  style: TextStyle(
                                    color: Colors.red, // Red text for Move
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 14
                                        : 16, // Responsive text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_Admin == 'Admin') ...[
                      if (widget.mainFolder != 'RecycleBin') ...[
                        PopupMenuItem<String>(
                          value: 'Recycle Bin',
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CommonScreen(
                                    title: 'RecycleBin',
                                    categories: ['RecycleBin'],
                                    mainFolder: 'RecycleBin',
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.dumpster,
                                    color:
                                        Colors.red, // Red icon for Recycle Bin
                                    size: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 20
                                        : 24, // Responsive icon size
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Recycle Bin',
                                    style: TextStyle(
                                      color: Colors
                                          .red, // Red text for Recycle Bin
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .shortestSide <
                                              600
                                          ? 14
                                          : 16, // Responsive text size
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget.mainFolder == 'RecycleBin') ...[
                        PopupMenuItem<String>(
                          value: 'Restore Images',
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await restoreFromRecycleBin();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.recycle,
                                    color:
                                        Colors.green, // Green icon for Restore
                                    size: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 20
                                        : 24, // Responsive icon size
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Restore Images',
                                    style: TextStyle(
                                      color: Colors
                                          .green, // Green text for Restore
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .shortestSide <
                                              600
                                          ? 14
                                          : 16, // Responsive text size
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ];
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white, // White icon for dark theme
                  size: 30,
                ),
              ),
            ],
          ],
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 101, 70, 1)
              ], // Black to Gold gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width < 600
                              ? 20
                              : 80), // Reduced margin for better fit on mobile
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 70, 46, 16),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Get the screen width to adapt to mobile/tablet devices
                          double width = constraints.maxWidth;

                          // Adjust TabBar settings based on screen width
                          double tabFontSize = width < 600
                              ? 14
                              : 18; // Smaller font for mobile, larger for tablet/desktop
                          double tabPadding = width < 600
                              ? 8
                              : 16; // Adjust padding for smaller screens

                          return TabBar(
                            controller: tabController,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            indicatorColor:
                                Colors.transparent, // Removes default underline
                            indicatorSize: TabBarIndicatorSize
                                .tab, // Ensures the indicator covers the entire tab
                            labelColor:
                                const Color.fromARGB(255, 253, 253, 253),
                            unselectedLabelColor:
                                const Color.fromARGB(255, 255, 187, 0),
                            tabs: widget.categories.map((category) {
                              return FutureBuilder<int>(
                                future: _countImagesInCategory(category),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Tab(
                                      text: "$category Loading...",
                                    );
                                  } else if (snapshot.hasError) {
                                    return Tab(
                                      text: "$category Error",
                                    );
                                  } else {
                                    catagoryImagescount = snapshot.data ?? 10;
                                    if (catagoryImagescount == 0) {
                                      catagoryImagescount += 6;
                                    }

                                    // Create the tab with dynamically adjusted font size and text
                                    return Tab(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                tabPadding), // Add horizontal padding
                                        child: Text(
                                          "$category ${catagoryImagescount.toString()}",
                                          style: TextStyle(
                                            fontSize:
                                                tabFontSize, // Responsive font size
                                            fontWeight: FontWeight
                                                .bold, // Optional: Make text bold
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: widget.categories.map((category) {
                          final imageUrls = imageUrlsByCategory[category] ?? [];
                          return imageUrls.isEmpty
                              ? Center(
                                  // Show a message when there are no images in the wishlist
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Adjust font size based on screen width
                                      Text(
                                        'No images found!',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  600
                                              ? 18
                                              : 24, // Font size for mobile vs tablet
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context)
                                                    .size
                                                    .width <
                                                600
                                            ? 10
                                            : 20, // Adjust height for spacing based on device
                                      ),
                                      Text(
                                        'Admin please add images to this category',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  600
                                              ? 16
                                              : 20, // Font size for mobile vs tablet
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : buildGridView(
                                  imageUrls); // Return the result of buildGridView
                        }).toList(), // Convert the mapped results to a list
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: SpinKitCircle(
                  size: 120,
                  itemBuilder: (context, index) {
                    final colors = [Colors.orangeAccent, Colors.black];
                    final color = colors[index % colors.length];

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: color,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width < 600
                  ? 20
                  : 30), // Adjust bottom padding based on screen size
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Move Button - Only shown if `ifMove` is true
              if (ifMove)
                FloatingActionButton(
                  backgroundColor:
                      Colors.deepOrangeAccent, // Dark accent for move button
                  onPressed: () async {
                    _moveImagesToOtherCategory();

                  },
                  child: const Icon(FontAwesomeIcons.paste,
                      color: Colors.white), // White icon for contrast
                ),

              // Spacer between buttons, adjust size for tablet view
              SizedBox(
                  height: MediaQuery.of(context).size.width < 600
                      ? 16
                      : 24), // Adjust spacing for different screen sizes

              // WhatsApp Button - Custom shaped
              FloatingActionButton(
                backgroundColor: Colors.green, // WhatsApp green color
                onPressed: () {
                  final whatsappLink =
                      'https://wa.me/919247879511?text=Hi%2C%20Balaji%20Jewellers%2C%20I%20am%20$userName%20and%20interested%20in%20your%20catalogue';
                  launch(whatsappLink);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width < 600
                      ? 56.0
                      : 100.0, // Adjust width for mobile vs tablet
                  height: MediaQuery.of(context).size.width < 600
                      ? 56.0
                      : 100.0, // Adjust height for mobile vs tablet
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.black, // Black background for the container
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // To ensure rounded corners
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSA0W1ZrYWrI28u4z8pNVEdsD-QrbfWPn9QTs1n5amNXYEtxsrYCmsSbfjG6FuW7ZfiOU&usqp=CAU", // WhatsApp logo URL
                      width: double
                          .infinity, // Make the image take up the full width
                      height: double
                          .infinity, // Make the image take up the full height
                      fit: BoxFit
                          .cover, // Ensures the image covers the entire space without distorting
                    ),
                  ),
                ),
              ),

              // Spacer between buttons, adjust size for tablet view
              SizedBox(
                  height: MediaQuery.of(context).size.width < 600
                      ? 16
                      : 24), // Adjust spacing for different screen sizes

              // Upload Button - Only shown if `isAdmin` is true
              if (isAdmin)
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(
                      255, 145, 102, 0), // Blue color for upload button
                  onPressed: () async {
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      _uploadImageToFirebase(pickedImage.path);
                    }
                  },
                  child: const Icon(FontAwesomeIcons.plus,
                      color: Colors.white), // White icon for contrast
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView(List<DocumentReference<Object?>> imageUrls) {
    int itemCount = isAdmin
        ? imageUrls.length
        : imageUrls.length <= 50
            ? imageUrls.length
            : 50;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the number of columns dynamically based on screen width
        int crossAxisCount = constraints.maxWidth < 600
            ? 2 // Mobile phones
            : constraints.maxWidth < 900
                ? 3 // Small tablets
                : 4; // Larger tablets and above

        double childAspectRatio = constraints.maxWidth < 600
            ? 0.7 // Taller items for smaller screens
            : 0.75; // Wider items for larger screens

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: MediaQuery.of(context).size.width < 600 ? 5 : 8,
            crossAxisSpacing: MediaQuery.of(context).size.width < 600 ? 5 : 8,

            childAspectRatio: childAspectRatio, // Maintain proper aspect ratio
          ),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, index) {
            final documentReference = imageUrls[index];

            return FutureBuilder<Map<String, dynamic>>(
              future: _getImageUrlFromReference(documentReference),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // Show shimmer while loading
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 200, // Adjust the height as needed
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading image');
                } else {
                  final data = snapshot.data;
                  final imageUrl = data?['imageUrl'];
                  final id = data?['id'];
                  final weight = data?['weight'];
                  final isSelected = selectedImages.contains(imageUrl);
                  final isInWish = isInWishlist.contains(imageUrl);

                  return Container(
                    child: Card(
                      color: const Color.fromARGB(115, 0, 0, 0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelectionMode) {
                              if (!isSelected) {
                                selectedImages.add(imageUrl!);
                              } else {
                                selectedImages.remove(imageUrl);
                                if (selectedImages.isEmpty) {
                                  isSelectionMode = false;
                                }
                              }
                            } else {
                              _showImagePopup(context, imageUrl!, id, weight);
                            }
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            isSelectionMode = !isSelectionMode;
                            if (!isSelected) {
                              selectedImages.add(imageUrl!);
                            }
                          });
                        },
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        (MediaQuery.of(context).size.width < 600
                                            ? 0.22
                                            : 0.2),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: const Color.fromARGB(
                                              113, 0, 0, 0),
                                          highlightColor: const Color.fromARGB(
                                              255, 58, 33, 12),
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 32,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      "Weight : $weight",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(172, 255, 255, 255),
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    600
                                                ? 14
                                                : 18,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Id : $id',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(
                                                173, 255, 255, 255),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            toggleWishlist(imageUrl, id,
                                                weight.toString());
                                          },
                                          icon: Icon(
                                            isInWish
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 30,
                                            color: isInWish
                                                ? Colors.red
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Future<void>? showDeleteConfirmationDialog(
      String main, String title, String catagory, String name) {
    print("show DeleteConfirmation");
    final firestore = FirebaseFirestore.instance;
    final mainCollection = firestore.collection(widget.mainFolder);
    final collection =
        mainCollection.doc(widget.title).collection(selectedCategory);

    final recyclemainCollection = firestore.collection(main);
    final recycleBinCollection =
        recyclemainCollection.doc(title).collection(catagory);

    final imagesToRemove = selectedImages
        .toList(); // Making a copy of selectedImages for efficiency

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get the screen width to make it responsive
        double width = MediaQuery.of(context).size.width;
        double dialogWidth = width < 600
            ? width * 0.85
            : width * 0.5; // Larger width for tablets
        double fontSize = width < 600 ? 18 : 22; // Larger font size for tablets

        return Dialog(
          backgroundColor: Colors.black, // Dark background for the dialog
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Rounded corners for the dialog
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(139, 96, 67, 6)
                ], // Black to Gold gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            width: dialogWidth, // Adjust width based on device size
            padding: EdgeInsets.all(36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  '$name Selected Items?',
                  style: TextStyle(
                    color: Colors.white, // Light color for title
                    fontSize: fontSize, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Content text
                Text(
                  'Are you sure you want to $name the selected items?',
                  style: TextStyle(
                    color: Colors.white60, // Light color for content text
                    fontSize:
                        fontSize - 4, // Slightly smaller font size for content
                  ),
                ),
                SizedBox(height: 20),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700], // Dark button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // OK button
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        // Implement move to recycle bin logic here
                        for (var imageUrl in imagesToRemove) {
                          try {
                            final existingDoc = await collection
                                .where('imageUrl', isEqualTo: imageUrl)
                                .limit(1)
                                .get();

                            if (existingDoc.docs.isNotEmpty) {
                              // Move the item to the recycle bin
                              if (widget.mainFolder != 'RecycleBin') {
                                await recycleBinCollection
                                    .add(existingDoc.docs.first.data());
                              }
                              await collection
                                  .doc(existingDoc.docs.first.id)
                                  .delete();
                              imageUrlCache.remove(
                                  existingDoc.docs.first.reference.path);
                            } else {
                              print('Error Moving images to Recycle Bin: ');
                            }
                          } catch (e) {
                            print('Error Moving images to Recycle Bin: $e');
                          }
                        }
                        setState(() {
                          isLoading = false;
                          selectedImages.clear();
                        });

                        Fluttertoast.showToast(
                          msg: "Images $name Successfully!",
                          toastLength: Toast
                              .LENGTH_SHORT, // Duration for the toast message
                          gravity: ToastGravity
                              .BOTTOM, // Position of the toast message
                          backgroundColor:
                              Colors.red, // Background color of the toast
                          textColor: Colors.white, // Text color of the toast
                          fontSize: 16.0, // Font size of the toast text
                        );

                        //refresh screen
                        // refreshBuild();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, // Highlighted button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return null;
  }

  Future<Map<String, dynamic>> _getImageUrlFromReference(
      DocumentReference reference) async {
    final String refPath = reference.path;

    // Check if the image URL is already cached
    if (imageUrlCache.containsKey(refPath)) {
      return imageUrlCache[refPath];
    }

    try {
      final snapshot = await reference.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        print(data);
        if (data.isNotEmpty && data.containsKey('imageUrl')) {
          final imageUrl = data['imageUrl'] as String;
          final Id = data['id'] as String;
          final weight = data['weight'] as String; // Cast to String if needed
          try {
            final querySnapshot = await FirebaseFirestore.instance
                .collection('Wishlist')
                .doc(userPhoneNumber)
                .collection('Wishlist')
                .where('imageUrl', isEqualTo: imageUrl)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              // If there are any documents with the same imageUrl, it's in the Wishlist
              isInWishlist.add(imageUrl);
            }

            // If there are any documents with the same imageUrl, it's in the Wishlist
          } catch (e) {
            print('Error checking imageUrl in Wishlist: $e');
            // Handle the error case accordingly
          }

          // Store the fetched image URL in the cache
          imageUrlCache[refPath] = {
            'imageUrl': imageUrl,
            'id': Id,
            'weight': weight, // Convert to String if needed
          };

          return imageUrlCache[refPath];
        }
      }
    } catch (e) {
      print('Error fetching image URL: $e');
    }

    return {}; // Return an empty map or handle the error case accordingly
  }
}

class SelectedItem {
  final String imageUrls;
  bool isSelected;

  SelectedItem(this.imageUrls, {this.isSelected = false});
}
