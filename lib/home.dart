import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:social_x/utils/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> newsData = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    try {
      final apiCall = ApiCall();
      final data = await apiCall.api();
      setState(() {
        newsData = data;
      });
    } catch (e) {
      print("Error fetching news data: $e");
    }
  }

  Widget buildImageWidget(String? imageUrl) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        width: 60,
        height: 60,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red,
          );
        },
      );
    } else {
      return const Icon(
        Icons.image,
        size: 60,
        color: Colors.lightBlueAccent,
      );
    }
  }

  String getTimeAgo(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  void handleSearch(String query) {
    setState(() {
      searchText = query;
    });
  }

  List<dynamic> getFilteredNews() {
    if (searchText.isEmpty) {
      return newsData;
    } else {
      return newsData.where((news) {
        final title = news["title"].toString().toLowerCase();
        final description = news["description"].toString().toLowerCase();
        return title.contains(searchText.toLowerCase()) ||
            description.contains(searchText.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNews = getFilteredNews();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: handleSearch,
            decoration: const InputDecoration(
                hintText: 'Search in feed',
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.blue,
                ),
                hintStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  FirebaseAuth.instance.signOut();
                });
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: filteredNews.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Colors.white12)),
                elevation: 5.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            getTimeAgo(filteredNews[index]["publishedAt"]),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            filteredNews[index]["source"]["name"],
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        filteredNews[index]["title"],
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: ReadMoreText(
                        filteredNews[index]["description"],
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        lessStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        style: const TextStyle(color: Colors.lightBlue),
                      ),
                      trailing:
                          buildImageWidget(filteredNews[index]['urlToImage']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
