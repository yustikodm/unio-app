class OnBoarding {
  String image;
  String description;

  OnBoarding({this.image, this.description});
}

class OnBoardingList {
  List<OnBoarding> _list;

  List<OnBoarding> get list => _list;

  OnBoardingList() {
    _list = [
      new OnBoarding(
          image: 'img/onboarding1.png',
          description:
              'Find information on the field of study, scholarships and universities of your dreams domestically and abroad.'),
      new OnBoarding(
          image: 'img/onboarding2.png',
          description:
              'get information about articles, places to live, tips and tricks for studying abroad easily.'),
      //new OnBoarding(image: 'images/onboarding1.png', description: 'So many books, so little time.'),
      //new OnBoarding(image: 'images/onboarding2.png', description: 'A room without books is like a body without a soul.'),
    ];
  }
}
