import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtm_mobile_app/features/auth/screens/concerts_page.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:wtm_mobile_app/providers/auth_provider.dart';

class InterestedScreen extends StatefulWidget {
  static const String routeName = '/interested';

  const InterestedScreen({Key? key}) : super(key: key);

  @override
  State<InterestedScreen> createState() => _InterestedScreenState();
}

class _InterestedScreenState extends State<InterestedScreen> {
  List<dynamic> concerts = [];

  Future<void> fetchInterestedConcerts(String userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5053/api/concerts/interested/$userId'),
    );
    if (response.statusCode == 200) {
      setState(() {
        concerts = jsonDecode(response.body);
      });
    } else {
      //display error
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch interested concerts ' + response.statusCode.toString() ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ));
    }
  }

  Future<void> markNotInterested(String concertId, String userId) async {
    final requestBody = {
      'userId': userId,
      'concertId': concertId,
    };

    final response = await http.patch(
      Uri.parse('http://10.0.2.2:5053/api/concerts/uninterested'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Successfully marked as not interested
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Not Interested'),
          content: Text('You have marked this concert as not interested.'),
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
      // Refresh the list of interested concerts
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchInterestedConcerts(authProvider.userId!);
    } else {
      // Handle error
      print('Failed to mark as not interested');
    }
  }

  void viewConcertDetails(BuildContext context, String concertId, String imageLink) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConcertDetailsScreen(id: concertId, imageLink: imageLink),
      ),
    );
  }

  @override
void initState() {
  super.initState();
  // Delay the execution using a post-frame callback to ensure the widget is fully initialized
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;
    if (userId != null ) {
      fetchInterestedConcerts(userId);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Not Logged In'),
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
  });
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.userId;
    if (userId == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Not Logged In'),
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
    } else {
      fetchInterestedConcerts(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interested Concerts'),
      ),
      body: ListView.builder(
        itemCount: concerts.length,
        itemBuilder: (context, index) {
          final concert = concerts[index];
          final concertId = concert['_id'];
          final imageLink = 'https:' + concert['image_link'].replaceAll('medium_avatar', 'huge_avatar');;

          return ListTile(
            leading: Image.network(imageLink),
            title: Text(concert['title']),
            subtitle: Text(concert['location']),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                markNotInterested(concertId, authProvider.userId!);
              },
            ),
            onTap: () {
              viewConcertDetails(context, concertId, imageLink);
            },
          );
        },
      ),
    );
  }
}
