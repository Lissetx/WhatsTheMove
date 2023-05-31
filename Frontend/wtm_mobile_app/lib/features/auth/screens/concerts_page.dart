import 'package:flutter/material.dart';
import 'package:wtm_mobile_app/main.dart';
import 'package:wtm_mobile_app/providers/auth_provider.dart';
import 'package:wtm_mobile_app/features/auth/screens/interested_page.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConcertsScreen extends StatefulWidget {
  static const String routeName = '/home';
  const ConcertsScreen({Key? key}) : super(key: key);
  @override
  _ConcertsScreenState createState() => _ConcertsScreenState();
}

class _ConcertsScreenState extends State<ConcertsScreen> {
  List<dynamic> concerts = [];
  List<dynamic> filteredConcerts = [];

  Future<void> fetchConcerts() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5053/api/concerts'));
    if (response.statusCode == 200) {
      setState(() {
        concerts = jsonDecode(response.body);
        filteredConcerts = concerts;
      });
    } else {
      // Handle error
      print('Failed to fetch concerts');
    }
  }

  void filterConcerts(String searchTerm) {
    setState(() {
      filteredConcerts = concerts.where((concert) {
        final title = concert['title'].toLowerCase();
        return title.contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchConcerts();
  }

  void navigateToInterestedPage(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;
    if (userId != null) {
      Navigator.pushNamed(context, InterestedScreen.routeName);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Authentication Required'),
          content: Text('You must be logged in to use this feature.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concerts'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              navigateToInterestedPage(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterConcerts(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredConcerts.length,
              itemBuilder: (context, index) {
                final concert = filteredConcerts[index];
                final title = concert['title'];
                final id = concert['_id'];
                final imageLink = 'https:' +
                    concert['image_link']
                        .replaceAll('medium_avatar', 'huge_avatar');

                return ListTile(
                  title: Text(title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ConcertDetailsScreen(id: id, imageLink: imageLink),
                      ),
                    );
                  },
                  // Wrap the ListTile with a Container to use the imageLink as a background image
                  tileColor: Colors.grey[300],
                  // Set the height and width of the Container using SizedBox
                  contentPadding: EdgeInsets.all(8),
                  leading: SizedBox(
                    height: 80,
                    width: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageLink),
                          fit: BoxFit.fill,
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
  }
}

class ConcertDetailsScreen extends StatelessWidget {
  final String id;
  final String imageLink;

  ConcertDetailsScreen({required this.id, required this.imageLink});

  Future<Map<String, dynamic>> fetchConcertDetails() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5053/api/concerts/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      print('Failed to fetch concert details');
      return {};
    }
  }

  Future<void> markInterested(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;
    if (userId == null) {
      // Display a message if the user is not logged in
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Authentication Required'),
          content: Text('You must be logged in to use this feature.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final requestBody = {
      'userId': userId,
      'concertId': id,
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5053/api/concerts/interested'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Successfully marked as interested
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Interested'),
          content: Text('You have marked your interest in this concert.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Handle error
      print('Failed to mark as interested');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchConcertDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to load concert details');
        } else {
          final concertDetails = snapshot.data!;
          final title = concertDetails['title'];
          final readableDate = concertDetails['readable_date'];
          final artists = concertDetails['artists'];
          final location = concertDetails['location'];
          final ticketLink = concertDetails['ticket_link'];
          final venue = concertDetails['venue'];
          final imageLink = 'https:' +
              concertDetails['image_link']
                  .replaceAll('medium_avatar', 'huge_avatar');

          return Scaffold(
            appBar: AppBar(
              title: Text('Concert Details'),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(imageLink),
                  Text(title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Artists: ${artists.join(", ")}'),
                  SizedBox(height: 10),
                  Text('Location: $location'),
                  SizedBox(height: 10),
                  Text('Venue: $venue'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      markInterested(
                          context); // Call the function when the button is pressed
                    },
                    child: Text('Mark Interested'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final url = concertDetails['ticket_link'];
                      if (concertDetails['ticket_link'] != null &&
                          await launcher.canLaunch(url)) {
                        // Remove the trailing question mark if present
                        final sanitizedUrl = url.replaceAll('?', '');
                        await launcher.launch(sanitizedUrl);
                      } else {
                           showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Ticket Unavailable'),
                              content: Text(
                                  'Tickets are not available for this concert. Check back later.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Buy Tickets'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
