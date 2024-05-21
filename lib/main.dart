import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main(){

  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Project',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const homeScreen(),
    );
  }
}
String formatDate(String dateString) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);

  return formattedDate;
}
String formatTime(String dateString) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object into the desired time format
  String formattedTime = DateFormat.jm().format(dateTime); // 'jm' format represents time in "h:mm a" format

  return formattedTime;
}
String formatRelativeTime(String dateString) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Get the current time
  DateTime now = DateTime.now();

  // Calculate the difference between the current time and the input time
  Duration difference = now.difference(dateTime);

  // Check if the difference is less than 1 minute
  if (difference.inMinutes < 1) {
    return 'just now';
  }

  // Check if the difference is less than 1 hour
  else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  }

  // If the difference is more than 60 minutes
  else {
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;
    return '$hours hr $minutes min ago';
  }
}
class homeScreen extends StatefulWidget{
  const homeScreen({super.key});


  @override
  State<homeScreen> createState(){
    return homeScreenState();
  }
}
int _currentSlide = 0;
class homeScreenState extends State<homeScreen>{
  List<dynamic> users = [];
  List<dynamic> technology = [];
  List<dynamic> health = [];
  List<dynamic> business = [];
  List<dynamic> science = [];
  List<dynamic> entertainment = [];
  List<dynamic> sports = [];
  List<dynamic> general = [];
  List<dynamic> filteredUsersList = [];
  dynamic data7;
  dynamic data8;
  dynamic data9;
  dynamic data10;
  dynamic data11;
  dynamic data12;
  dynamic data13;
  dynamic data14;
  bool _onActive = false;
  var searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    await fetchUsers();
    fetchNewsByCategory('technology');
    fetchNewsByCategory('health');
    fetchNewsByCategory('business');
    fetchNewsByCategory('science');
    fetchNewsByCategory('entertainment');
    fetchNewsByCategory('sports');
    fetchNewsByCategory('general');
  }
  Future<void> fetchNewsByCategory(String category) async {
    String apiKey = "04b3c2a5150f6fad92568125a5a8e7f7";
    const apiUrl = "http://api.mediastack.com/v1/news";
    const country = "in"; // India

    try {
      final response = await http.get(Uri.parse('$apiUrl?access_key=$apiKey&countries=$country&categories=$category'));
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);

        // Check if the response contains data
        if (json['data'] != null) {
          setState(() {
            // Assigning the data to the appropriate category variable
            switch (category) {
              case 'technology':
                technology = List<dynamic>.from(json['data']);
                break;
              case 'health':
                health = List<dynamic>.from(json['data']);
                break;
              case 'business':
                business = List<dynamic>.from(json['data']);
                break;
              case 'science':
                science = List<dynamic>.from(json['data']);
                break;
              case 'entertainment':
                entertainment = List<dynamic>.from(json['data']);
                break;
              case 'sports':
                sports = List<dynamic>.from(json['data']);
                break;
              case 'general':
                general = List<dynamic>.from(json['data']);
                break;
              default:
                break;
            }
          });
          // print('Completed fetching $category news');
        } else {
          throw Exception("No data found for $category category");
        }
      } else {
        throw Exception('Failed to fetch $category news: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching $category news: $e');
    }
  }
  Future<void> fetchUsers() async {
    String apiKey = "04b3c2a5150f6fad92568125a5a8e7f7";
    const apiUrl = "http://api.mediastack.com/v1/news";
    const country = "in"; // India

    try {
      final response = await http.get(Uri.parse('$apiUrl?access_key=$apiKey&countries=$country'));
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);

        // Check if the response is a list or a map
        if (json['data'] is List) {
          final List<dynamic> responseData = json['data'];
          setState(() {
            users = responseData;
            data7 = users.length > 6 ? users[6] : null;
            data8 = users.length > 7 ? users[7] : null;
            data9 = users.length > 8 ? users[8] : null;
            data10 = users.length > 9 ? users[9] : null;// Check if there's data at index 7
            data11 = users.length > 10 ? users[10] : null;
            data12 = users.length > 11 ? users[11] : null;
            data13 = users.length > 12 ? users[12] : null;
            data14 = users.length > 13 ? users[13] : null;
          });
        } else if (json['data'] is Map) {
          final Map<String, dynamic> responseData = json['data'];
          setState(() {
            users = [responseData]; // Convert map to list with a single element
            data7 = responseData; // Assign data7 to the map
            data8 = responseData;
            data9 = responseData;
            data10 = responseData;
            data11 = responseData;
            data12 = responseData;
            data13 = responseData;
            data14 = responseData;
          });
        } else {
          throw Exception("Unexpected data format");
        }
        // print('completed');
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching users: $e');
    }
  }

  void searchNews(String query) {
    List<dynamic> filteredUsers = users.where((user) {
      // Assuming each user has a 'title' field to search in
      return user['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Now you have the filtered list of users based on the search query
    // You can use this filtered list to update your UI, display search results, etc.
    // For example, you might want to update a ListView with the filtered results.
    // You can update the state with setState() to trigger a rebuild of your UI.
    setState(() {
      // Update the state with the filtered list
      // For example, you might have a state variable called filteredUsersList
      filteredUsersList = filteredUsers;
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context){
    // var check7 = users[7];
    return DefaultTabController(
      length: _headertabs.length,
      child: Center(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              leading: !_onActive ?
              IconButton(
                icon: const Icon(Icons.menu,color: Colors.black87,size:26),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ): null,
            title: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(!_onActive)
                        Row(
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                        children: [
                                          TextSpan(text: 'NEWS',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'Roboto')),
                                          TextSpan(text:' PL',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20)),
                                        ]
                                    ),
                                  ),
                                  const SizedBox(width: 2,),
                                  const FaIcon(FontAwesomeIcons.play,size: 17,color: Colors.amber,),
                                  // Icon(Icons.play_arrow_outlined,size: 28,color: Colors.amber,),
                                  const Text('Y',style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20))
                                ],
                              )
                            ]
                        ), !_onActive ?
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            InkWell(
                              child: const Icon(Icons.search,color: Colors.black87,size:26),
                              onTap: (){
                                setState(() {
                                  if(_onActive == false){
                                    _onActive = true;
                                  }else {
                                    _onActive = false;
                                  }
                                  // print(_onActive);
                                });
                              },),
                            const SizedBox(width: 15,),
                            InkWell(
                                child: const Icon(Icons.notifications_none,size: 24,color: Colors.black87,),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>notificationScreen()));
                                },
                            )
                          ]
                      ) :
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: searchController,
                          onChanged: (value) {
                            // Trigger search operation here
                            searchNews(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search News',
                            hintStyle: const TextStyle(fontSize: 15),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close,color: Colors.black87,size: 21),
                              onPressed: () {
                                searchController.clear();
                              },
                            ),
                            prefixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  _onActive = false;
                                });
                              },
                              icon: const Icon(Icons.arrow_back_outlined,size: 21,color: Colors.black87,)
                            ),
                            enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent
                              )
                            )
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
            bottom: !_onActive ?
            const TabBar(
              padding: EdgeInsets.only(right: 0,left: 0),
              tabs: _headertabs,
              isScrollable: true,
            ): null
          ),
          drawer: !_onActive ? _drawer() : null,
          body: TabBarView(
            children: [

              Tab(child: (_onActive) ?
              ListView.builder(
                itemCount: filteredUsersList.length,
                itemBuilder: (context, index) {
                  // Here, you can customize how each item in the filteredUsersList is displayed
                  return ListTile(
                    title: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(filteredUsersList[index],data7, data8),));
                      },
                        child: Text(filteredUsersList[index]['title'])
                    ),
                    // Other widgets to display additional user information
                  );
                },
              ) :
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: Colors.black.withOpacity(.05),
                  child: data7 != null ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 18),
                          child:
                          Row(
                            children: [
                              // CircleAvatar(
                              //   radius: 23,
                              //   backgroundImage: AssetImage('assets/images/image.jpg'),
                              // ),
                              // SizedBox(width: 12,),
                              // Expanded(
                              //   child: TextField(
                              //       controller: searchController,
                              //       onChanged: (value) {
                              //         // Trigger search operation here
                              //         searchNews(value);
                              //       },
                              //       decoration: InputDecoration(
                              //           hintText: 'Search News',
                              //           hintStyle: TextStyle(fontSize: 14),
                              //           fillColor: Colors.white,
                              //           filled: true,
                              //           contentPadding: EdgeInsets.symmetric(vertical: 6,horizontal: 14),
                              //           enabledBorder: OutlineInputBorder(
                              //             borderSide: BorderSide(
                              //               width: 1,
                              //               color: Colors.black26,
                              //             ),
                              //             borderRadius: BorderRadius.circular(50),
                              //           )
                              //       )
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        CarouselSlider(
                          options: CarouselOptions(
                            height: 210,
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0,
                            pauseAutoPlayOnManualNavigate: true,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentSlide = index; // Update the current slide index
                              });
                            },
                          ),
                          items: users.take(6).map((data) {
                            return Builder(
                              builder: (BuildContext context) {
                                // final user = users[index];
                                // final title = user['title'];
                                return InkWell(
                                  onTap: () async {
                                    // String url = data['url'];
                                    // if (url != null && url.isNotEmpty) {
                                    //   try {
                                    //     await launch(url, forceSafariVC: false, forceWebView: false);
                                    //   } catch (e) {
                                    //     print('Error launching URL: $e');
                                    //   }
                                    // } else {
                                    //   print('Error: URL is null or empty');
                                    // }
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data, data7, data8),));

                                  },
                                  child: Hero(
                                    tag: 'detailnews',
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            image: DecorationImage(
                                                image: data['image'] != null
                                                    ? NetworkImage(data['image']!) as ImageProvider
                                                    : const AssetImage('assets/images/noimage.png'),
                                                repeat: ImageRepeat.noRepeat,
                                                fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        Positioned(
                                            top: 10,
                                            left: 20,
                                            child: Container(
                                                padding: const EdgeInsets.only(left: 12,right: 12,top: 5,bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: InkWell(
                                                    onTap:(){
                                                      setState(() {
                                                        // print(data['image']!);
                                                      });
                                                      },
                                                    child: Text(data?['category']!.toUpperCase(),style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w500,),)
                                                )
                                            )
                                        ),
                                        Positioned(
                                            right: 20,
                                            top: 10,
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
                                              decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius: BorderRadius.circular(50)
                                              ),
                                              child: const Row(
                                                  children: [
                                                    FaIcon(FontAwesomeIcons.solidHeart,color: Colors.white,size: 16,),
                                                    // SizedBox(width: 4,),
                                                    Text('',style: TextStyle(color: Colors.white,fontSize: 15),),
                                                  ]
                                              ),
                                            )
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left:15,
                                          right:15,
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8))
                                            ),
                                            width: MediaQuery.of(context).size.width, // Make the container full width
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
                                              children: [
                                                Text(
                                                  data?['title']!,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    height: 1.3,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  // overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    const FaIcon(FontAwesomeIcons.clock,color: Colors.white,size: 13,),
                                                    const SizedBox(width: 8,),
                                                    Text(formatDate(data?['published_at']!),style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: users.asMap().entries.take(6).map((entry) {
                            return GestureDetector(
                              // onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 7,
                                height: 7,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentSlide == entry.key ? Colors.deepPurple : Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: const Border(
                                      left: BorderSide(
                                        width: 4,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: const Text('Popular News',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),)
                              ),
                              // Text('View all',style: TextStyle(color: Colors.black87,fontSize: 15),),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:6,left: 15,right: 15),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  // String url = data7['url'];
                                  // if (url.isNotEmpty) {
                                  //   try {
                                  //     await launch(url, forceSafariVC: false, forceWebView: false);
                                  //   } catch (e) {
                                  //     print('Error launching URL: $e');
                                  //   }
                                  // } else {
                                  //   print('Error: URL is null or empty');
                                  // }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data7, data8, data9),));
                                },
                                child: Hero(
                                  tag: 'detailnews',
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Text(data7['title'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 12,),
                                            if(data7['image'] != null && _isValidUrl(data7['image']))
                                            Expanded(
                                              flex:2,
                                              child: Image(
                                                image: data7['image'] != null ? NetworkImage(data7['image']) as ImageProvider :
                                                const AssetImage('assets/images/noimage.jpg'),
                                                width: 80,height: 80,fit:BoxFit.cover,),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  borderRadius: BorderRadius.circular(6)
                                              ),
                                              child: Text(data7['category'],style: const TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.w500,
                                              ),),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 8,),
                                                Text(formatDate(data7['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ],
                                            ),
                                            Row(
                                                children: [
                                                  const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                  const SizedBox(width: 5,),
                                                  Text(data7['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                                ]
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14,),
                              InkWell(
                                onTap: () {
                                  // String url = data8['url']!;
                                  // if (url != null && url.isNotEmpty) {
                                  //   try {
                                  //     await launch(url, forceSafariVC: false, forceWebView: false);
                                  //   } catch (e) {
                                  //     print('Error launching URL: $e');
                                  //   }
                                  // } else {
                                  //   print('Error: URL is null or empty');
                                  // }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data8, data7, data9),));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(data8['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12,),
                                          if(data8['image'] != null && _isValidUrl(data8['image']))
                                          Expanded(
                                            flex: 2,
                                            child: Image(
                                              image: data8['image'] != null ? NetworkImage(data8['image']) as ImageProvider :
                                              const AssetImage('assets/images/noimage.jpg'),
                                              width: 80,height: 80,fit:BoxFit.cover,),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(data8['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                              const SizedBox(width: 8,),
                                              Text(formatDate(data8['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                            ],
                                          ),
                                          Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 5,),
                                                Text(data8['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14,),
                              InkWell(
                                onTap: () {
                                  // String url = data9['url']!;
                                  // if (url != null && url.isNotEmpty) {
                                  //   try {
                                  //     await launch(url, forceSafariVC: false, forceWebView: false);
                                  //   } catch (e) {
                                  //     print('Error launching URL: $e');
                                  //   }
                                  // } else {
                                  //   print('Error: URL is null or empty');
                                  // }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data9, data8, data7),));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(data9['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12,),
                                          if(data9['image'] != null && _isValidUrl(data9['image']))
                                          Expanded(
                                            flex: 2,
                                            child: Image(
                                              image: data9['image'] != null ? NetworkImage(data9['image']) as ImageProvider :
                                              const AssetImage('assets/images/noimage.jpg'),
                                              width: 80,height: 80,fit:BoxFit.cover,),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(data9['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                              const SizedBox(width: 8,),
                                              Text(formatDate(data9['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                            ],
                                          ),
                                          Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 5,),
                                                Text(data9['country'],
                                                  style: const TextStyle(color: Colors.black54,
                                                      fontSize: 14),
                                                ),
                                              ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14,),
                              InkWell(
                                onTap: () {
                                  // String url = data10['url']!;
                                  // if (url != null && url.isNotEmpty) {
                                  //   try {
                                  //     await launch(url, forceSafariVC: false, forceWebView: false);
                                  //   } catch (e) {
                                  //     print('Error launching URL: $e');
                                  //   }
                                  // } else {
                                  //   print('Error: URL is null or empty');
                                  // }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data10, data9, data8),));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(data10['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12,),
                                          if(data10['image'] != null && _isValidUrl(data10['image']))
                                          Expanded(
                                            flex: 2,
                                            child: Image(
                                              image: data10['image'] != null ? NetworkImage(data10['image']) as ImageProvider :
                                              const AssetImage('assets/images/noimage.jpg'),
                                              width: 80,height: 80,fit:BoxFit.cover,),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(data10['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                              const SizedBox(width: 8,),
                                              Text(formatDate(data10['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                            ],
                                          ),
                                          Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 5,),
                                                Text(data10['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,bottom:15,top:25),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 7),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: const Border(
                                    left: BorderSide(
                                      width: 4,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: const Text('Recent News',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:6,left: 15,right: 15),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data11, data10, data9),));
                                },
                                child: Hero(
                                  tag: 'detailnews',
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Text(data11['title'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,fontWeight: FontWeight.w500),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 12,),
                                            if(data11['image'] != null && _isValidUrl(data11['image']))
                                            Expanded(
                                              flex:2,
                                              child: Image(
                                                image: data11['image'] != null ? NetworkImage(data11['image']) as ImageProvider :
                                                const AssetImage('assets/images/noimage.jpg'),
                                                width: 80,height: 80,fit:BoxFit.cover,),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  borderRadius: BorderRadius.circular(6)
                                              ),
                                              child: Text(data11['category'],style: const TextStyle(
                                                color: Colors.white,fontWeight: FontWeight.w500,
                                              ),),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 8,),
                                                Text(formatDate(data11['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ],
                                            ),
                                            Row(
                                                children: [
                                                  const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                  const SizedBox(width: 5,),
                                                  Text(data11['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                                ]
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14,),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data12, data11, data10),));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(data12['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12,),
                                          if(data12['image'] != null && _isValidUrl(data12['image']))
                                          Expanded(
                                            flex: 2,
                                            child: Image(
                                              image: data12['image'] != null ? NetworkImage(data12['image']) as ImageProvider :
                                              const AssetImage('assets/images/noimage.jpg'),
                                              width: 80,height: 80,fit:BoxFit.cover,),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(data12['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                              const SizedBox(width: 8,),
                                              Text(formatDate(data12['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                            ],
                                          ),
                                          Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 5,),
                                                Text(data12['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14,),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data13, data12, data11),));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(data13['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12,),
                                          if(data13['image'] != null && _isValidUrl(data13['image']))
                                          Expanded(
                                            flex: 2,
                                            child: Image(
                                              image: data13['image'] != null ? NetworkImage(data13['image']) as ImageProvider :
                                              const AssetImage('assets/images/noimage.jpg'),
                                              width: 80,height: 80,fit:BoxFit.cover,),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(data13['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                              const SizedBox(width: 8,),
                                              Text(formatDate(data13['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                            ],
                                          ),
                                          Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 5,),
                                                Text(data13['country'],
                                                  style: const TextStyle(color: Colors.black54,
                                                      fontSize: 14),
                                                ),
                                              ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14,),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(data14, data13, data12),));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(data14['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,fontWeight: FontWeight.w500),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12,),
                                          if(data14['image'] != null && _isValidUrl(data14['image']))
                                          Expanded(
                                            flex: 2,
                                            child: Image(
                                              image: data14['image'] != null ? NetworkImage(data14['image']) as ImageProvider :
                                              const AssetImage('assets/images/noimage.jpg'),
                                              width: 80,height: 80,fit:BoxFit.cover,),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(data14['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                              const SizedBox(width: 8,),
                                              Text(formatDate(data14['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                            ],
                                          ),
                                          Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 5,),
                                                Text(data14['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ]
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ) : Container(
                    color: Colors.white,
                    child: const Column(
                      children: [
                        Text('LOADING...',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                      ],
                    ),
                  )
                ),
              )),
              Tab(
                child: ListView.builder(
                  itemCount: business.length,
                  itemBuilder: (context, index) {
                    final user = business[index];
                    final title = user['title'];
                    final image = user['image'];
                    return Container(
                      padding: const EdgeInsets.only(top:16,left: 16,right: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.05),
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(
                              business[index],
                            business[0],business[1]
                          ),));
                        },
                        child: Hero(
                          tag: 'detailnews',
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                                children: [
                                  if(image !=null && _isValidUrl(image))
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          ),
                                          child: Image(
                                            image: image != null ? NetworkImage(image) as ImageProvider : const AssetImage('assets/images/noimage.png'),
                                            height: 160,
                                            // color: Colors.amber,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 6),
                                    child: Text(
                                      title,
                                      style: const TextStyle(fontSize:16,fontWeight:FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 8),
                                    child: Text(
                                      user['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FaIcon(FontAwesomeIcons.clock,color: Colors.black.withOpacity(.4),size: 15,),
                                            const SizedBox(width: 6,),
                                            Text(
                                              formatDate(user['published_at']),
                                              style: TextStyle(fontSize: 14,color:Colors.black.withOpacity(.4)),
                                            ),
                                          ],
                                        ),
                                        FaIcon(FontAwesomeIcons.solidHeart,color: Colors.black.withOpacity(.4),size: 15,),
                                      ],
                                    ),
                                  )
                                ]
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Tab(
                child: ListView.builder(
                  itemCount: sports.length,
                  itemBuilder: (context, index) {
                    final user = sports[index];
                    final title = user['title'];
                    return Container(
                      padding: const EdgeInsets.only(top:16,left: 16,right: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.05),
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(sports[index],sports[0],sports[1]),));
                        },
                        child: Hero(
                          tag: 'detailnews',
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                                children: [
                                  if(sports[index]['image'] != null && _isValidUrl(sports[index]['image']))
                                    Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                          ),
                                          child: Image(
                                            image: NetworkImage(sports[index]['image']) as ImageProvider,
                                            height: 160,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 6),
                                    child: Text(
                                      title,
                                      style: const TextStyle(fontSize:16,fontWeight:FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 8),
                                    child: Text(
                                      user['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FaIcon(FontAwesomeIcons.clock,color: Colors.black.withOpacity(.4),size: 15,),
                                            const SizedBox(width: 6,),
                                            Text(
                                              formatDate(user['published_at']),
                                              style: TextStyle(fontSize: 14,color:Colors.black.withOpacity(.4)),
                                            ),
                                          ],
                                        ),
                                        FaIcon(FontAwesomeIcons.solidHeart,color: Colors.black.withOpacity(.4),size: 15,),
                                      ],
                                    ),
                                  )
                                ]
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Tab(
                child: ListView.builder(
                  itemCount: general.length,
                  itemBuilder: (context, index) {
                    final user = general[index];
                    final title = user['title'];
                    final image = user['image'];
                    return Container(
                      padding: const EdgeInsets.only(top:16,left: 16,right: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.05),
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => detailNews(general[index],general[0],general[1]),));
                        },
                        child: Hero(
                          tag: 'detailnews',
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                                children: [
                                  if(image != null && _isValidUrl(image))
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          ),
                                          child: Image(
                                            image: image != null ? NetworkImage(image) as ImageProvider : const AssetImage('assets/images/noimage.png'),
                                            height: 160,
                                            // color: Colors.amber,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 6),
                                    child: Text(
                                      title,
                                      style: const TextStyle(fontSize:16,fontWeight:FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 8),
                                    child: Text(
                                      user['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FaIcon(FontAwesomeIcons.clock,color: Colors.black.withOpacity(.4),size: 15,),
                                            const SizedBox(width: 6,),
                                            Text(
                                              formatDate(user['published_at']),
                                              style: TextStyle(fontSize: 14,color:Colors.black.withOpacity(.4)),
                                            ),
                                          ],
                                        ),
                                        FaIcon(FontAwesomeIcons.solidHeart,color: Colors.black.withOpacity(.4),size: 15,),
                                      ],
                                    ),
                                  )
                                ]
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
          // bottomNavigationBar: NavigationBar(
          //   selectedIndex: _selectingIndex,
          //   backgroundColor: Colors.white,
          //   destinations: _homeNavbarItems,
          //   onDestinationSelected: (index){
          //     setState(() {
          //       _selectingIndex = index;
          //     });
          //   },
          // )
        ),
      ),
    );
  }
}
Widget _drawer() => Drawer(
  child: Scaffold(
    appBar: AppBar(
      title: const Text(''),
    ),
    body: Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                    children: [
                      TextSpan(text: 'NEWS',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto')),
                      TextSpan(text:' PL',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.amber,
                              fontWeight: FontWeight.w800,
                              fontSize: 20)),
                    ]
                ),
              ),
              const SizedBox(width: 2,),
              const FaIcon(FontAwesomeIcons.play,size: 17,color: Colors.amber,),
              // Icon(Icons.play_arrow_outlined,size: 28,color: Colors.amber,),
              const Text('Y',style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.amber,
                  fontWeight: FontWeight.w800,
                  fontSize: 20))
            ],
          ),
          const SizedBox(height: 6,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Copyright © 2024 | All Right Reserved',style: TextStyle(fontSize: 13))
            ],
          )
        ],
      ),
    ),
  )
);
bool _isValidUrl(String url) {
  Uri? uri = Uri.tryParse(url);
  if (uri != null && uri.scheme.isNotEmpty && uri.host.isNotEmpty) {
    return true;
  }
  return false;
}
class detailNews extends StatelessWidget{
  final Map<String, dynamic> newsData;
  final Map<String, dynamic> business;
  final Map<String, dynamic> businesstwo;
  detailNews(this.newsData, this.business, this.businesstwo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !(newsData['image'] != null && _isValidUrl(newsData['image']))
          ? AppBar(
          title: const Text('DETAILS',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
        ): null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            if(newsData['image'] != null && _isValidUrl(newsData['image']))
            SliverAppBar(
              expandedHeight: 240.0,
              floating: false,
              pinned: false,
              stretch: true,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    children: [
                      newsData['image'] != null && _isValidUrl(newsData['image'])
                          ? Image(
                        image: NetworkImage(newsData['image']),
                        fit: BoxFit.cover,
                        height: 290,
                        repeat: ImageRepeat.noRepeat,
                      )
                          : Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                      ),
                      Container(
                        color: Colors.black.withOpacity(.2),
                        height: 290,
                      )
                    ],
                  )),
            ),
          ];
        },
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.black.withOpacity(.05),
            child: Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Text(newsData['category'].toUpperCase(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                      ),
                      const Row(
                        children: [
                          FaIcon(FontAwesomeIcons.heart,size: 24,),
                          SizedBox(width: 26,),
                          FaIcon(FontAwesomeIcons.bookmark,size: 21,),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.calendarDays,size: 18,color: Colors.black.withOpacity(.6),),
                      const SizedBox(width: 8,),
                      Text(formatDate(newsData['published_at']!),style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 14),),
                      const SizedBox(width: 20,),
                      FaIcon(FontAwesomeIcons.solidClock,size: 14,color: Colors.black.withOpacity(.6),),
                      const SizedBox(width: 8,),
                      Text(formatRelativeTime(newsData['published_at']!),style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 14),),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    children: [
                      Expanded(child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  width: 3,
                                  color: Colors.deepPurple
                                )
                            )
                        ),
                        child: Text(newsData['title'],
                          style: const TextStyle(
                            fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),),
                      ))
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.solidNewspaper,size: 17,color: Colors.black.withOpacity(.7),),
                      const SizedBox(width: 8,),
                      Expanded(child: Text(newsData['source'],style: TextStyle(color: Colors.black.withOpacity(.7),fontSize: 14),)),
                      ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: newsData['description'],style: TextStyle(fontSize: 18,height: 1.8,color: Colors.black.withOpacity(.8)),),
                              ]
                            ),
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: () async {
                      String url = newsData['url'];
                      if (url.isNotEmpty) {
                        try {
                          await launch(url, forceSafariVC: false, forceWebView: false);
                        } catch (e) {
                          // print('Error launching URL: $e');
                        }
                      } else {
                        // print('Error: URL is null or empty');
                      }
                    },
                      child: Text(newsData['url'],style: const TextStyle(fontSize: 16,color: Colors.deepPurple),)),
                  const SizedBox(height: 80,),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: const Border(
                                bottom: BorderSide(
                                  width: 4,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: const Text('You might also like',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),)
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 24,),
                      InkWell(
                        onTap: () async {
                          String url = business['url'];
                          if (url.isNotEmpty) {
                            try {
                              await launch(url, forceSafariVC: false, forceWebView: false);
                            } catch (e) {
                              // print('Error launching URL: $e');
                            }
                          } else {
                            // print('Error: URL is null or empty');
                          }

                        },
                        child: Hero(
                          tag: 'detailnews',
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if(business['image'] != null && _isValidUrl(business['image']))
                                    Expanded(
                                      flex:2,
                                      child: Image(
                                        image: business['image'] != null ? NetworkImage(business['image']) as ImageProvider :
                                        const AssetImage('assets/images/noimage.jpg'),
                                        width: 80,height: 110,fit:BoxFit.cover,),
                                    ),
                                    const SizedBox(width: 12,),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(business['title'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,fontWeight: FontWeight.w500),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8,),
                                          Container(
                                            padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Text(business['category'],style: const TextStyle(
                                              color: Colors.white,fontWeight: FontWeight.w500,
                                            ),),
                                          ),
                                          const SizedBox(height: 8,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                                  const SizedBox(width: 8,),
                                                  Text(formatDate(business['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                                ],
                                              ),
                                              Row(
                                                  children: [
                                                    const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                    const SizedBox(width: 5,),
                                                    Text(business['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                                  ]
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14,),
                      InkWell(
                        onTap: () async {
                          String url = businesstwo['url'];
                          if (url.isNotEmpty) {
                            try {
                              await launch(url, forceSafariVC: false, forceWebView: false);
                            } catch (e) {
                              // print('Error launching URL: $e');
                            }
                          } else {
                            // print('Error: URL is null or empty');
                          }

                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if(businesstwo['image'] != null && _isValidUrl(businesstwo['image']))
                                  Expanded(
                                    flex:2,
                                    child: Image(
                                      image: businesstwo['image'] != null ? NetworkImage(businesstwo['image']) as ImageProvider :
                                      const AssetImage('assets/images/noimage.jpg'),
                                      width: 80,height: 110,fit:BoxFit.cover,),
                                  ),
                                  const SizedBox(width: 12,),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(businesstwo['title'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,fontWeight: FontWeight.w500),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8,),
                                        Container(
                                          padding: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                          decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius: BorderRadius.circular(6)
                                          ),
                                          child: Text(businesstwo['category'],style: const TextStyle(
                                            color: Colors.white,fontWeight: FontWeight.w500,
                                          ),),
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const FaIcon(FontAwesomeIcons.clock,color: Colors.black54,size: 14,),
                                                const SizedBox(width: 8,),
                                                Text(formatDate(businesstwo['published_at']),style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                              ],
                                            ),
                                            Row(
                                                children: [
                                                  const FaIcon(FontAwesomeIcons.globe,color: Colors.black54,size: 14,),
                                                  const SizedBox(width: 5,),
                                                  Text(businesstwo['country'],style: const TextStyle(color: Colors.black54,fontSize: 14),),
                                                ]
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 14,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
class newGround extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _sliderData.length,
      itemBuilder: (context, index) {
        final user = _sliderData[index];
        final title = user['mainHead'];
        return ListTile(
          title: Text(title!, style: const TextStyle(color: Colors.black)),
        );
      },
    );
  }
}
class secondAlgodata extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _sliderData.length,
      itemBuilder: (context, index) {
        final user = _sliderData[index];
        final title = user['text'];
        return ListTile(
          title: Text(title!, style: const TextStyle(color: Colors.black)),
        );
      },
    );
  }
}
var _sliderData = [
  {
    'image': 'assets/images/slider1.webp',
    'text': 'Politics',
    'like' : '120',
    'mainHead' : "Congress' Yatra has created 'big media buzz'.",
    'date' : '20 April 2024',
  },
  {
    'image': 'assets/images/slider2.webp',
    'text': 'Entertainment',
    'like' : '70',
    'mainHead' : "New Delhi World Book Fair 2024: Going beyond literature",
    'date' : '17 November 2023',
  },
  {
    'image': 'assets/images/slider3.webp',
    'text': 'Sports',
    'like' : '53',
    'mainHead' : "Security stepped up in Kashmir ahead of PM Modi's",
    'date' : '9 July 2023',
  },
  {
    'image': 'assets/images/slider4.webp',
    'text': 'Travel',
    'like' : '225',
    'mainHead' : "After Kamal Nath, rumours of Congress veteran",
    'date' : '24 January 2023',
  },
];
const _headertabs = [
  Tab(text: 'Explore'),
  Tab(text: 'Business',),
  Tab(text: 'Sports',),
  Tab(text: 'Uncategorized',),
];
const _homeNavbarItems = [
  NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home'
  ),
  NavigationDestination(
      icon: Icon(Icons.video_collection_outlined),
      selectedIcon: Icon(Icons.video_collection),
      label: 'Videos'
  ),
  NavigationDestination(
    icon: Icon(Icons.category_outlined),
    selectedIcon: Icon(Icons.category),
    label: 'Categories',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_2_outlined),
    selectedIcon: Icon(Icons.person_2),
    label: 'Profile',
  ),
];
class notificationScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text('Notifications',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 18),),
            Text('Clear all',style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w500),)
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black.withOpacity(0.05),
        width: double.infinity,
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.notifications_off_outlined,size: 80,color: Colors.black54,),
              SizedBox(height: 10,),
              Text('No notifications found!',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
              SizedBox(height: 3,),
              Text("You haven't received any notifications yet. Make sure you have turned on the notifications from the settings.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}