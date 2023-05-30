import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as launcher;

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

  Future<void> fetchConcerts() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5053/api/concerts'));
    if (response.statusCode == 200) {
      setState(() {
        concerts = jsonDecode(response.body);
      });
    } else {
      // Handle error
      print('Failed to fetch concerts');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchConcerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concerts'),
      ),
      body: ListView.builder(
        itemCount: concerts.length,
        itemBuilder: (context, index) {
          final concert = concerts[index];
          final title = concert['title'];
          final id = concert['_id'];
          return ListTile(
            title: Text(title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConcertDetailsScreen(id: id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConcertDetailsScreen extends StatelessWidget {
  final String id;

  ConcertDetailsScreen({required this.id});

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

          return Scaffold(
            appBar: AppBar(
              title: Text('Concert Details'),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(readableDate),
                  SizedBox(height: 10),
                  Text('Artists: ${artists.join(", ")}'),
                  SizedBox(height: 10),
                  Text('Location: $location'),
                  SizedBox(height: 10),
                  Text('Venue: $venue'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final url = concertDetails['ticket_link'];
                      if (url != null && await launcher.canLaunch(url)) {
                        // Remove the trailing question mark if present
                        final sanitizedUrl = url.replaceAll('?', '');
                        await launcher.launch(sanitizedUrl);
                      } else {
                        throw 'Could not launch $url';
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
