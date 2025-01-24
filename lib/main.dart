import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Brain Fart Dashboard',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme(
            primary: Color(0xFFef5122), // Primary color
            primaryContainer: Color.fromARGB(255, 255, 215, 201), // Primary container
            secondary: Color.fromARGB(255, 255, 187, 134), // Secondary color
            secondaryContainer: Color.fromARGB(255, 185, 65, 0), // Secondary container
            surface: Color(0xFFFFFFFF), // Surface color
            background: Color(0xFFF0F0F0), // Background color
            error: Color(0xFFd32f2f), // Error color
            onPrimary: Color(0xFFFFFFFF), // Text color on primary
            onSecondary: Color(0xFFFFFFFF), // Text color on secondary
            onSurface: Color(0xFF000000), // Text color on surface
            onBackground: Color(0xFF000000), // Text color on background
            onError: Color(0xFFFFFFFF), // Text color on error
            brightness: Brightness.light, // Set brightness to light
          ),
        ),
        home: SplashScreen(), 
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}


// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = Placeholder(); 
        break;
      case 4:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.backpack_outlined),
                      label: Text('E.D.C.'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.check_box_outlined),
                      label: Text('Tasks'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.payments_outlined),
                      label: Text('Payments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      label: Text('Calendar'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}



class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text ('Your stagename is...'),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

// ...
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}

// Add the SplashScreen class
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0; // Initial opacity

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to the home page after 2 seconds
    Timer(Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0; // Change opacity to 0 for fade out
      });
      // Navigate to the home page after the fade out
      Timer(Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 500), // Duration of the fade out
              child: SizedBox(
                width: 200, // Set the desired width
                height: 200, // Set the desired height
                child: Image.asset('images/BF_logo.png'), // Display the logo
              ),
            ),
            SizedBox(height: 20), // Space between logo and loading indicator
            AnimatedOpacity(
              opacity: _opacity, // Match the fade out opacity
              duration: Duration(milliseconds: 500), // Match the fade out duration
              child: SizedBox(
                width: 20, // Set the desired width for the loading indicator
                height: 20, // Set the desired height for the loading indicator
                child: CircularProgressIndicator(), // Loading indicator
              ),
            ),
          ],
        ),
      ),
    );
  }
}