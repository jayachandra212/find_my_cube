import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import 'dart:convert';
import 'dart:async';

import 'package:find_my_cube/models/studyhall.dart';
import 'package:find_my_cube/models/user.dart';
import 'package:find_my_cube/utils/fmc_constants.dart';

class CommonModel extends Model {
  List<StudyHall> _studyHalls = [];
  User _authenticatedUser;
  String _selStudyHallId;
  bool _isLoading = false;

  Future<bool> addStudyHall(
      String name, String location, double price, String image) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> studyHallData = {
      'name': name,
      'location': location,
      'price': price,
      'image':
          'https://dy98q4zwk7hnp.cloudfront.net/1970-Dodge-Charger-Muscle%20&%20Pony%20Cars--Car-100742588-9ae6c36edbcb264f0db07f565cc1ac76.jpg?w=1280&h=720&r=thumbnail&s=1',
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://fmc-experiment.firebaseio.com/studyHalls.json?auth=${_authenticatedUser.token}',
          body: json.encode(studyHallData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final StudyHall newStudyHall = StudyHall(
          id: responseData['name'],
          name: name,
          location: location,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _studyHalls.add(newStudyHall);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class StudyHallsModel extends CommonModel {
  bool _showFavorites = false;

  List<StudyHall> get allStudyHalls {
    return List.from(_studyHalls);
  }

  List<StudyHall> get displayedStudyHalls {
    if (_showFavorites) {
      return List.from(_studyHalls
          .where((StudyHall studyHall) => studyHall.isFavorite)
          .toList());
    }
    return List.from(_studyHalls);
  }

  int get selectedStudyHallIndex {
    return _studyHalls.indexWhere((StudyHall studyHall) {
      return studyHall.id == _selStudyHallId;
    });
  }

  String get selectedStudyHallId {
    return _selStudyHallId;
  }

  StudyHall get selectedStudyHall {
    if (selectedStudyHallId == null) {
      return null;
    }
    return _studyHalls.firstWhere((StudyHall studyHall) {
      return studyHall.id == _selStudyHallId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> updateStudyHall(
      String name, String location, double price, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedData = {
      'name': name,
      'location': location,
      'price': price,
      'image':
          'https://dy98q4zwk7hnp.cloudfront.net/1970-Dodge-Charger-Muscle%20&%20Pony%20Cars--Car-100742588-9ae6c36edbcb264f0db07f565cc1ac76.jpg?w=1280&h=720&r=thumbnail&s=1',
      'userEmail': selectedStudyHall.userEmail,
      'userId': selectedStudyHall.userId
    };
    return http
        .put(
            'https://fmc-experiment.firebaseio.com/studyHalls/${selectedStudyHall.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updatedData))
        .then((http.Response response) {
      _isLoading = false;
      final StudyHall updatedStudyHall = StudyHall(
          id: selectedStudyHall.id,
          name: name,
          location: location,
          price: price,
          image: image,
          userEmail: selectedStudyHall.userEmail,
          userId: selectedStudyHall.userId);
      _studyHalls[selectedStudyHallIndex] = updatedStudyHall;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteStudyHall() {
    _isLoading = true;
    final deletedStudyHallId = selectedStudyHall.id;
    _studyHalls.removeAt(selectedStudyHallIndex);
    _selStudyHallId = null;
    notifyListeners();
    return http
        .delete(
            'https://fmc-experiment.firebaseio.com/studyHalls/${deletedStudyHallId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<dynamic> fetchStudyHalls({onlyUserSpecific = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://fmc-experiment.firebaseio.com/studyHalls.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      final List<StudyHall> fetchedStudyHallsList = [];
      final Map<String, dynamic> studyHallListData = json.decode(response.body);
      if (studyHallListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      studyHallListData.forEach((String studyHallId, dynamic studyHallData) {
        final StudyHall studyHall = StudyHall(
            id: studyHallId,
            name: studyHallData['name'],
            location: studyHallData['location'],
            price: studyHallData['price'],
            image: studyHallData['image'],
            userEmail: studyHallData['userEmail'],
            userId: studyHallData['userId'],
            isFavorite: studyHallData['usersWishList'] == null
                ? false
                : (studyHallData['usersWishList'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));
        fetchedStudyHallsList.add(studyHall);
      });
      _studyHalls = onlyUserSpecific
          ? fetchedStudyHallsList.where((StudyHall studyHall) {
              return studyHall.userId == _authenticatedUser.id;
            }).toList()
          : fetchedStudyHallsList;
      _isLoading = false;
      notifyListeners();
      _selStudyHallId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void selectStudyHall(String studyHallId) {
    _selStudyHallId = studyHallId;
    notifyListeners();
  }

  void toggleStudyHallFavoriteStatus() async {
    final bool isCurrentlyFavorite =
        _studyHalls[selectedStudyHallIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final StudyHall updateStudyHall = StudyHall(
        id: selectedStudyHall.id,
        name: selectedStudyHall.name,
        location: selectedStudyHall.location,
        price: selectedStudyHall.price,
        image: selectedStudyHall.image,
        userEmail: selectedStudyHall.userEmail,
        userId: selectedStudyHall.userId,
        isFavorite: newFavoriteStatus);
    _studyHalls[selectedStudyHallIndex] = updateStudyHall;
    notifyListeners();

    http.Response response;

    if (newFavoriteStatus) {
      response = await http.put(
          'https://fmc-experiment.firebaseio.com/studyHalls/${selectedStudyHall.id}/usersWishList/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://fmc-experiment.firebaseio.com/studyHalls/${selectedStudyHall.id}/usersWishList/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final StudyHall updateStudyHall = StudyHall(
          id: selectedStudyHall.id,
          name: selectedStudyHall.name,
          location: selectedStudyHall.location,
          price: selectedStudyHall.price,
          image: selectedStudyHall.image,
          userEmail: selectedStudyHall.userEmail,
          userId: selectedStudyHall.userId,
          isFavorite: !newFavoriteStatus);
      _studyHalls[selectedStudyHallIndex] = updateStudyHall;
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends CommonModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), () {
      logout();
      _userSubject.add(false);
    });
  }

  Future<Map<String, dynamic>> authenticate(
      String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=' +
            FMCConstants.apikey,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    String us = responseData['displayName'];
    print(us);
    bool hasError = true;
    String message = 'Something went wrong!!';

    if (responseData.containsKey('idToken')) {
      bool emailVerified =
          await isEmailVerified(responseData['idToken'], email);
      print("Email-Verified");
      print(emailVerified);
      if (emailVerified) {
        hasError = false;
        message = 'Authentication Succeeded';
        _authenticatedUser = User(
            id: responseData['localId'],
            email: email,
            token: responseData['idToken']);
        setAuthTimeout(int.parse(responseData['expiresIn']));
        _userSubject.add(true);
        final DateTime now = DateTime.now();
        final DateTime expiryTime =
            now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", responseData['idToken']);
        prefs.setString("userEmail", email);
        prefs.setString("userId", responseData['localId']);
        prefs.setString("expiryTime", expiryTime.toIso8601String());
      } else {
        message = 'Please verify your email!!';
      }
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email already exists!!';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email does not exists!!';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Password is invalid!!';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<bool> isEmailVerified(String idToken, String email) async {
    final Map<String, dynamic> inputData = {'idToken': idToken};
    bool result = false;
    http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=' +
            FMCConstants.apikey,
        body: json.encode(inputData),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData.containsKey('users')) {
      List<dynamic> usersData = responseData['users'];
      Map<String, dynamic> emailData =
          usersData.firstWhere((u) => u['email'] == email);
      if (emailData.containsKey("emailVerified"))
        result = emailData['emailVerified'];
    }
    return result;
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token");
    final String expiryTimeString = prefs.getString("expiryTime");
    if (token != null) {
      final DateTime now = DateTime.now();
      final DateTime parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.get("userEmail");
      final String userId = prefs.get("userId");
      final int tokenLifeSpan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifeSpan);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> signUpStudent(
      String email, String password, String displayName) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'displayName': displayName,
      'returnSecureToken': true
    };
    print("SignUpInfo");
    print(authData);
    http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=' +
            FMCConstants.apikey,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    String us = responseData['displayName'];
    print(us);
    bool hasError = true;
    String message = 'Something went wrong!!';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Account Creation Succeeded';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", responseData['idToken']);
      prefs.setString("userEmail", email);
      prefs.setString("userId", responseData['localId']);
      prefs.setString("expiryTime", expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email already exists!!';
    } else if (responseData['error']['message'] == 'WEAK_PASSWORD') {
      message = 'Password should be at least 6 characters!!';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> signUpManager(
      Map<String, dynamic> managerSignUpInfo) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': managerSignUpInfo['email'],
      'password': managerSignUpInfo['password'],
      'displayName': managerSignUpInfo['displayName'],
      'returnSecureToken': true
    };
    print("SignUpInfo");
    print(authData);
    http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=' +
            FMCConstants.apikey,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    String us = responseData['displayName'];
    print(us);
    bool hasError = true;
    String message = 'Something went wrong!!';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Account Creation Succeeded';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: managerSignUpInfo['email'],
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", responseData['idToken']);
      prefs.setString("userEmail", managerSignUpInfo['email']);
      prefs.setString("userId", responseData['localId']);
      prefs.setString("expiryTime", expiryTime.toIso8601String());
      bool result = await addStudyHall(
          managerSignUpInfo['studyHallName'],
          managerSignUpInfo['studyHallAddress'],
          double.parse(managerSignUpInfo['studyHallPrice']),
          "https://dy98q4zwk7hnp.cloudfront.net/1970-Dodge-Charger-Muscle%20&%20Pony%20Cars--Car-100742588-9ae6c36edbcb264f0db07f565cc1ac76.jpg?w=1280&h=720&r=thumbnail&s=1");
      if (result) {
        message = 'SHAS';
      } else {
        message = 'SHAF';
      }
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email already exists!!';
    } else if (responseData['error']['message'] == 'WEAK_PASSWORD') {
      message = 'Password should be at least 6 characters!!';
    }
    _isLoading = false;
    notifyListeners();
    print("messgae" + message);
    return {'success': !hasError, 'message': message};
  }
}

class UtilityModel extends CommonModel {
  bool get isLoading {
    return _isLoading;
  }
}
