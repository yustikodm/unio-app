import 'package:Unio/src/screens/account.dart';
import 'package:Unio/src/screens/advice.dart';
import 'package:Unio/src/screens/detail.dart';
import 'package:Unio/src/screens/directory.dart';
import 'package:Unio/src/screens/on_boarding.dart';
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
      case '/Setting':
        return MaterialPageRoute(builder: (_) => AccountWidget());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Detail':
        return MaterialPageRoute(
            builder: (_) => DetailWidget(
                  routeArgument: args as RouteArgument,
                ));
      case '/Advice':
        return MaterialPageRoute(
            builder: (_) => AdviceWidget(
                  routeArgument: args as RouteArgument,
                ));
      case '/Tabs':
        return MaterialPageRoute(
            builder: (_) => TabsWidget(
                  currentTab: args,
                ));
      case '/OnBoarding':
        return MaterialPageRoute(builder: (_) => OnBoardingWidget());
      case '/Favorites':
        return MaterialPageRoute(
            builder: (_) => TabsWidget(
                  currentTab: 4,
                  routeArgument: args as RouteArgument,
                ));
      case '/Utilities':
        return MaterialPageRoute(
            builder: (_) => UtilitieWidget(
                  routeArgument: args as RouteArgument,
                ));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Categories':
        return MaterialPageRoute(builder: (_) => CategoriesWidget());
      case '/Categorie':
        return MaterialPageRoute(
            builder: (_) => CategorieWidget(
                  routeArgument: args as RouteArgument,
                ));
      case '/Directory':
        return MaterialPageRoute(
            builder: (_) => DirectoryWidget(
                  routeArgument: args as RouteArgument,
                ));

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
