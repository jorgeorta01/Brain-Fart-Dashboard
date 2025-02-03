import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:webview_windows/webview_windows.dart';

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
          primaryColor: Color.fromARGB(255, 216, 105, 68),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFF1744E),
            primary: Color(0xFFF1744E),
            secondary: Color(0xFFB65A3D),
          ),
          navigationRailTheme: NavigationRailThemeData(
            backgroundColor: Color.fromARGB(255, 218, 111, 87),
            unselectedIconTheme: IconThemeData(color: Colors.white),
            selectedIconTheme:
                IconThemeData(color: Color.fromARGB(255, 218, 111, 87)),
          ),
        ),
        home: LoadingScreen(),
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
        page = WelcomePage();
        // break;
      case 1:
        page = Placeholder();
        // break;
      case 2:
        page = Placeholder();
        // break;
      case 3:
        page = Placeholder();
        // break;
      case 4:
        page = Placeholder();
        // break;
      case 5:
        page = ParcelsPage();
        // break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: ClipRRect(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text(
                        'Home',
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? Color.fromARGB(
                                  255, 218, 111, 87) // Selected color
                              : Colors.white, // Unselected color
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.backpack),
                      label: Text(
                        'E.D.C.',
                        style: TextStyle(
                          color: selectedIndex == 1
                              ? Color.fromARGB(
                                  255, 218, 111, 87) // Selected color
                              : Colors.white, // Unselected color
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.check_box),
                      label: Text(
                        'To Do',
                        style: TextStyle(
                          color: selectedIndex == 2
                              ? Color.fromARGB(
                                  255, 218, 111, 87) // Selected color
                              : Colors.white, // Unselected color
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.payments),
                      label: Text(
                        'Payments',
                        style: TextStyle(
                          color: selectedIndex == 3
                              ? Color.fromARGB(
                                  255, 218, 111, 87) // Selected color
                              : Colors.white, // Unselected color
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month),
                      label: Text(
                        'Calendar',
                        style: TextStyle(
                          color: selectedIndex == 4
                              ? Color.fromARGB(
                                  255, 218, 111, 87) // Selected color
                              : Colors.white, // Unselected color
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.mail),
                      label: Text(
                        'Parcel Monitor',
                        style: TextStyle(
                          color: selectedIndex == 5
                              ? Color.fromARGB(
                                  255, 218, 111, 87) // Selected color
                              : Colors.white, // Unselected color
                        ),
                      ),
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
    });
  }
}

//This is the Welcome Page.

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    // Update time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Clean up timer when widget is disposed
    super.dispose();
  }

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d').format(_currentTime),
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  DateFormat('h:mm a').format(_currentTime),
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 20.0),
                      child: Text(
                        "Hello, User",
                        style: TextStyle(
                            fontSize: 24), // Set the font size for the time
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// This is the ParcelsPage.

class ParcelsPage extends StatefulWidget {
  @override
  State<ParcelsPage> createState() => _ParcelsPageState();
}

class _ParcelsPageState extends State<ParcelsPage> {
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      await _controller.initialize();
      final widgetUrl = Uri.parse('https://parcelsapp.com/widget').replace(
        queryParameters: {
          'textButton' : 'Trace',
          'fontButton': 'Roboto',
          'fontSizeButton' : '16px',
          // 'trackingNumber' : '', //Don't care lololol
          // 'backgroundColorButton': 'FFF1744E', //Doesn't work
          // 'borderButton' : '', //Don't care lololol
          'borderRadiusButton': '12',
          // 'colorButton': 'FFFFFF',
          // 'placeholder': '',
          // 'borderRadiusInput': '8',
          'borderInput' : '1px solid #808080',
          // 'widgetWrapBorder': '',
          'widgetWrapBorderRadius': '12'

        },
      ).toString();

      await _controller.loadUrl(widgetUrl);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing webview: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parcel Monitor',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _controller.value.isInitialized
                  ? Webview(_controller) // Note: Webview, not WebView
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
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

//LoadingScreen widget
class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('images/BF_logo.png'),
          ),
        ),
      ),
    );
  }
}
