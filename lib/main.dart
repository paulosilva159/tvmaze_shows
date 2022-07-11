import 'package:flutter/material.dart';
import 'package:jobsity_challenge/global_provider.dart';
import 'package:jobsity_challenge/presentation/screens/authentication/authentication_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await SharedPreferences.getInstance();

  runApp(
    GlobalProvider(
      storage: storage,
      builder: (_) => const TVMaze(),
    ),
  );
}

class TVMaze extends StatelessWidget {
  const TVMaze({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AuthenticationScreen.routeName,
      onGenerateRoute: Provider.of<RouteFactory>(context, listen: false),
    );
  }
}
