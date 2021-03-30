import 'package:flutter/material.dart';
import 'src/models/route_argument.dart';
import 'src/screens/Categorie.dart';
import 'src/screens/Categories.dart';
import 'src/screens/languages.dart';
import 'src/screens/signin.dart';
import 'src/screens/signup.dart';
import 'src/screens/splashScreen.dart';
import 'src/screens/tabs.dart';
import 'src/screens/utilitie.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/SignIn':
        return MaterialPageRoute(builder: (_) => SignInWidget()); 
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());  
      case '/Tabs':
        return MaterialPageRoute(builder: (_) => TabsWidget(currentTab: args,));    
      case '/Utilities':
        return MaterialPageRoute(builder: (_) => UtilitieWidget(routeArgument: args as RouteArgument,));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Categories':
        return MaterialPageRoute(builder: (_) => CategoriesWidget());
      case '/Categorie':
        return MaterialPageRoute(builder: (_) => CategorieWidget(routeArgument: args as  RouteArgument,));

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
