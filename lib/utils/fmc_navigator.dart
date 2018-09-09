import 'package:flutter/material.dart';

class FMCNavigator {

  static void goToSearch(BuildContext context) {
    Navigator.pushNamed(context, "/search");
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/authenticate");
  }

  static void goToSignUpOptions(BuildContext context) {
    Navigator.pushNamed(context, "/signUpOptions");
  }

  static void goToSignUpStudent(BuildContext context) {
    Navigator.pushNamed(context, "/signUpStudent");
  }

  static void goToSignUpManager(BuildContext context) {
    Navigator.pushNamed(context, "/signUpManager");
  }

  static void goToStudyHallsList(BuildContext context) {
    Navigator.pushNamed(context, "/studyHalls");
  }

  static void goToManageStudyHalls(BuildContext context) {
    Navigator.pushNamed(context, "/manageStudyHalls");
  }
}
