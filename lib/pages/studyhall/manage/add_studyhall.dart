import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/models/studyhall.dart';
import 'package:find_my_cube/scoped_models/main.dart';
import 'package:find_my_cube/components/studyhall_widgets/SaveButton.dart';

class AddStudyHallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddStudyHallPageState();
  }
}

class _AddStudyHallPageState extends State<AddStudyHallPage> {
  final Map<String, dynamic> _formData = {
    'name': null,
    'location': null,
    'price': null,
    'image': 'assets/fmc_logo.png'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildNameTextField(StudyHall studyHall) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'StudyHall Name'),
      initialValue: studyHall == null ? '' : studyHall.name.toString(),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Name is required and should be 5+ charecter long';
        }
      },
      onSaved: (String value) {
        _formData['name'] = value;
      },
    );
  }

  Widget _buildLocationTextField(StudyHall studyHall) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Location of Study Hall'),
      initialValue: studyHall == null ? '' : studyHall.location.toString(),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Location is required and should be 5+ charecter long';
        }
      },
      onSaved: (String value) {
        _formData['location'] = value;
      },
    );
  }

  Widget _buildPriceTextField(StudyHall studyHall) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Price'),
      initialValue: studyHall == null ? '' : studyHall.price.toString(),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price Information is required';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(Function addStudyHall, Function updateStudyHall,
      Function setSelectedStudyHall,
      [int selectedStudyHallIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedStudyHallIndex == -1) {
      addStudyHall(_formData['name'], _formData['location'], _formData['price'],
              _formData['image'])
          .then((bool result) {
        if (result) {
          Navigator.pushReplacementNamed(context, '/studyHalls')
              .then((_) => setSelectedStudyHall(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong !!'),
                  content: Text('Please try again later'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateStudyHall(_formData['name'], _formData['location'],
              _formData['price'], _formData['image'])
          .then((bool result) {
        if (result) {
          Navigator.pushReplacementNamed(context, '/studyHalls')
              .then((_) => setSelectedStudyHall(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong !!'),
                  content: Text('Please try again later'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : new Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: new InkWell(
                    child: new SaveButton(),
                    onTap: () => _submitForm(
                        model.addStudyHall,
                        model.updateStudyHall,
                        model.selectStudyHall,
                        model.selectedStudyHallIndex)));
      },
    );
  }

  Widget _buildPageContent(BuildContext context, StudyHall studyHall) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            width: targetWidth,
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                  children: <Widget>[
                    new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              _buildNameTextField(studyHall),
                              _buildLocationTextField(studyHall),
                              _buildPriceTextField(studyHall),
                              SizedBox(
                                height: 20.0,
                              ),
                              _buildSubmitButton()
                            ],
                          ),
                        ])
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedStudyHall);
        return model.selectedStudyHallIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(title: Text('Edit Study Hall Info')),
                body: pageContent,
              );
      },
    );
  }
}
