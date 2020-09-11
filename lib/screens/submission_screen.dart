import 'package:flutter/material.dart';
import 'package:gads2020/constants.dart';
import 'package:gads2020/exceptions.dart';
import 'package:gads2020/services/servives.dart';

class SubmissionScreen extends StatefulWidget {
  static const routeName = '/submit';

  @override
  _SubmissionScreenState createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _emailNode = FocusNode();
  final _gitHubLinkNode = FocusNode();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _gitHubLinkController = TextEditingController();

  // Email regex used by the W3C.
  static final _emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  Future<bool> _shouldSubmit() {
    return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'Are you ready to submit?',
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop<bool>(false),
                  child: Text('NO'),
                  textColor: Colors.orange,
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop<bool>(true),
                  child: Text('YES'),
                  textColor: Colors.white,
                  color: Colors.orange,
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _confirmSubmission(bool status) {
    showDialog(
      context: context,
      barrierDismissible: !status,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => !status,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  status ? Icons.check_circle : Icons.warning,
                  color: status ? Colors.green[900] : Colors.red,
                  size: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  status
                      ? 'Project submitted successfully.'
                      : 'Project submission failed.',
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  status
                      ? Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false)
                      : Navigator.of(context).pop();
                },
                child: Text(status ? 'OK' : 'RETRY'),
                textColor: Colors.white,
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitProject() async {
    final httpServices = HttpServices();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final emailAddress = _emailController.text.trim();
    final gitHubLink = _gitHubLinkController.text.trim();

    _scaffoldKey.currentState.hideCurrentSnackBar();
    if (_formKey.currentState.validate() && await _shouldSubmit()) {
      showSpinner(context);
      try {
        final status = await httpServices.submitProject(
            firstName, lastName, emailAddress, gitHubLink);
        Navigator.of(context).pop();
        // _showSnackBar(message);
        _confirmSubmission(status);
      } on AppException catch (e) {
        Navigator.of(context).pop();
        _showSnackBar(e.message);
      }
    }
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _firstNameNode.addListener(() {
      setState(() {});
    });
    _lastNameNode.addListener(() {
      setState(() {});
    });
    _emailNode.addListener(() {
      setState(() {});
    });
    _gitHubLinkNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _gitHubLinkNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _gitHubLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.orange,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Image.asset(
            'assets/img/gads-00.png',
            height: 40,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Project Submission',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.orange,
                      ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.orange[200],
                      Colors.black,
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Theme(
                data: ThemeData.dark().copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  cursorColor: Colors.orange,
                  accentColor: Colors.orange,
                ),
                child: Form(
                  key: _formKey,
                  autovalidate: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                focusNode: _firstNameNode,
                                controller: _firstNameController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                    color: _firstNameNode.hasFocus
                                        ? Colors.orange
                                        : Colors.grey,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (firstName) {
                                  if (firstName.trim().isEmpty) {
                                    return 'First Name cannot be empty.';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                focusNode: _lastNameNode,
                                controller: _lastNameController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                    color: _lastNameNode.hasFocus
                                        ? Colors.orange
                                        : Colors.grey,
                                  ),
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (lastName) {
                                  if (lastName.trim().isEmpty) {
                                    return 'Last Name cannot be empty.';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          focusNode: _emailNode,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'username@email.com',
                            labelStyle: TextStyle(
                              color: _emailNode.hasFocus
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          validator: (email) {
                            if (email.trim().isEmpty) {
                              return 'Email cannot be empty.';
                            } else if (!_emailRegExp.hasMatch(email)) {
                              return 'Not a valid email address.';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          focusNode: _gitHubLinkNode,
                          controller: _gitHubLinkController,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'GitHub (link)',
                            hintText:
                                'https://github.com/username/project-name',
                            labelStyle: TextStyle(
                              color: _gitHubLinkNode.hasFocus
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          validator: (gitHubLink) {
                            gitHubLink = gitHubLink.toLowerCase().trim();

                            if (gitHubLink.trim().isEmpty) {
                              return 'GitHub (link) cannot be empty.';
                            } else if (!(gitHubLink
                                    .startsWith('https://www.github.com/') ||
                                gitHubLink.startsWith('https://github.com/'))) {
                              return 'Not a valid GitHub link';
                            }

                            var other = gitHubLink.split('github.com/');
                            var strngs = other.last.split('/');

                            if (strngs.length != 2 ||
                                strngs.last.trim().isEmpty) {
                              return 'Not a valid GitHub project link';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          onPressed: _submitProject,
                          padding: EdgeInsets.zero,
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [
                                  Colors.orange[100],
                                  Colors.orange,
                                  Colors.orange,
                                ],
                              ),
                            ),
                            child: Container(
                              width: 120,
                              height: 38,
                              alignment: Alignment.center,
                              child: Text('SUBMIT'),
                            ),
                          ),
                          color: Colors.transparent,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
