import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:find_my_cube/models/studyhall.dart';
import 'package:find_my_cube/models/user.dart';

class CommonModel extends Model {
  List<StudyHall> _studyHalls = [];
  User _authenticatedUser;
  int _selStudyHallIndex;
  bool _isLoading = false;

  Future<Null> addStudyHall(
      String name, String location, double price, String image) {
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
    return http
        .post('https://fmc-experiment.firebaseio.com/studyHalls.json',
        body: json.encode(studyHallData))
        .then((http.Response response) {
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
    });
  }
}

class StudyHallsModel extends CommonModel {
  bool _showFavorites = false;

  List<StudyHall> get allStudyHalls {
    return List.from(_studyHalls);
  }

  List<StudyHall> get displayedStudyHalls {
    if (_showFavorites) {
      return List.from(
          _studyHalls.where((StudyHall studyHall) => studyHall.isFavorite).toList());
    }
    return List.from(_studyHalls);
  }

  int get selectedStudyHallIndex {
    return _selStudyHallIndex;
  }

  StudyHall get selectedStudyHall {
    if (selectedStudyHallIndex == null) {
      return null;
    }
    return _studyHalls[selectedStudyHallIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<Null> updateStudyHall(
      String name, String location, double price, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String,dynamic> updatedData = {
      'name':name,
      'location' : location,
      'price':price,
      'image' : 'https://dy98q4zwk7hnp.cloudfront.net/1970-Dodge-Charger-Muscle%20&%20Pony%20Cars--Car-100742588-9ae6c36edbcb264f0db07f565cc1ac76.jpg?w=1280&h=720&r=thumbnail&s=1',
      'userEmail' : selectedStudyHall.userEmail,
      'userId' : selectedStudyHall.userId
    };
    return http.put('https://fmc-experiment.firebaseio.com/studyHalls/${selectedStudyHall.id}.json',body: json.encode(updatedData)).then((http.Response response){
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
    });
  }

  void deleteStudyHall() {
    _isLoading = true;
    final deletedStudyHallId = selectedStudyHall.id;
    _studyHalls.removeAt(selectedStudyHallIndex);
    _selStudyHallIndex = null;
    notifyListeners();
    http.delete('https://fmc-experiment.firebaseio.com/studyHalls/${deletedStudyHallId}.json')
        .then((http.Response response){
      _isLoading = false;
      notifyListeners();
    });

  }

  Future<Null> fetchStudyHalls() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://fmc-experiment.firebaseio.com/studyHalls.json')
        .then((http.Response response) {
      final List<StudyHall> fetchedStudyHallsList = [];
      final Map<String, dynamic> studyHallListData =
      json.decode(response.body);
      if(studyHallListData == null){
        _isLoading = false;
        notifyListeners();
        return;
      }
      studyHallListData
          .forEach((String studyHallId, dynamic studyHallData) {
        final StudyHall studyHall = StudyHall(
          id: studyHallId,
          name: studyHallData['name'],
          location: studyHallData['location'],
          price: studyHallData['price'],
          image: studyHallData['image'],
          userEmail: studyHallData['userEmail'],
          userId: studyHallData['userId'],
        );
        fetchedStudyHallsList.add(studyHall);
      });
      _studyHalls = fetchedStudyHallsList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void selectStudyHall(int index) {
    _selStudyHallIndex = index;
    notifyListeners();
  }

  void toggleStudyHallFavoriteStatus() {
    final bool isCurrentlyFavorite = _studyHalls[selectedStudyHallIndex].isFavorite;
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
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends CommonModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'datta', email: email, password: password);
  }
}

class UtilityModel extends  CommonModel {
  bool get isLoading {
    return _isLoading;
  }
}