class TImages{
  //App Logcs
  static const String darkAppLogo = 'assets/images/user.png';
  static const String lightAppLogo = 'assets/images/user.png';
  static const String user = "assets/images/user.png";
  static const String imageOne = "assets/images/1.svg";
  static const String imageTwo = "assets/images/2.svg";
  static const String imageThree = "assets/images/3.svg";
  static const String imageFour = "assets/images/4.svg";

  static String getImage(int index) {
    switch (index) {
      case 0:
        return imageOne;
      case 1:
        return imageTwo;
      case 2:
        return imageThree;
      case 3:
        return imageFour;
      default:
        return '';
    }
  }
}