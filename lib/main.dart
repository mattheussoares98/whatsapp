import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/configurations_page.dart';
import 'package:whatsapp/pages/home_page.dart';
import 'package:whatsapp/pages/login_page.dart';
import 'package:whatsapp/pages/register_page.dart';
import 'package:whatsapp/provider/user_data_provider.dart';
import 'package:whatsapp/provider/login_user_provider.dart';
import 'package:whatsapp/provider/user_image_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';

void main() {
  final ThemeData theme = ThemeData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => LoginUserProvider()),
        ChangeNotifierProvider(create: (_) => UserImageProvider()),
      ],
      child: MaterialApp(
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.green[900],
            primary: Colors.green,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.green[900],
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.register: (context) => const RegisterPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.configurations: (context) => const ConfigurationsPage(),
        },
      ),
    ),
  );
}


// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: _title,
//       home: MyStatefulWidget(),
//     );
//   }
// }

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   bool shouldPop = true;
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return shouldPop;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter WillPopScope demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               OutlinedButton(
//                 child: const Text('Push'),
//                 onPressed: () {
//                   Navigator.of(context).push<void>(
//                     MaterialPageRoute<void>(
//                       builder: (BuildContext context) {
//                         return const MyStatefulWidget();
//                       },
//                     ),
//                   );
//                 },
//               ),
//               OutlinedButton(
//                 child: Text('shouldPop: $shouldPop'),
//                 onPressed: () {
//                   setState(
//                     () {
//                       shouldPop = !shouldPop;
//                     },
//                   );
//                 },
//               ),
//               const Text('Push to a new screen, then tap on shouldPop '
//                   'button to toggle its value. Press the back '
//                   'button in the appBar to check its behavior '
//                   'for different values of shouldPop'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
