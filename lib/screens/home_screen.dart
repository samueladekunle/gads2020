import 'package:flutter/material.dart';
import 'package:gads2020/exceptions.dart';
import 'package:gads2020/models/models.dart';
import 'package:gads2020/screens/submission_screen.dart';
import 'package:gads2020/services/servives.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<Leader>> _listOfLeaders;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _fetchListOfLeaders() async {
    final httpServices = HttpServices();
    try {
      final listOfLeaders = await Future.wait([
        httpServices.getLeaders(LeaderType.LearningLeader),
        httpServices.getLeaders(LeaderType.SkillIQLeader)
      ]);
      if (listOfLeaders != null) {
        setState(() => _listOfLeaders = listOfLeaders);
      }
    } on AppException catch (e) {
      _showSnackBar(e.message);
    }
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(days: 1),
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: _fetchListOfLeaders,
        ),
      ),
    );
  }

  Widget _buildListView(List<Leader> leaders) {
    return RefreshIndicator(
      onRefresh: _fetchListOfLeaders,
      child: ListView.separated(
        itemBuilder: (context, index) {
          final leader = leaders[index];

          var subtitle = '';
          if (leader.hours != null) {
            subtitle += '${leader.hours} learning hours';
          } else if (leader.score != null) {
            subtitle += '${leader.score} skill IQ score';
          }
          subtitle += ', ${leader.country}';

          return ListTile(
            leading: Image.network(leader.badgeUrl),
            title: Text(leader.name),
            subtitle: Text(
              subtitle,
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 0,
          color: Colors.grey,
        ),
        itemCount: leaders.length,
      ),
    );
  }

  Widget _buildBody() {
    if (_listOfLeaders == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return TabBarView(
        children: [
          _buildListView(_listOfLeaders[0]),
          _buildListView(_listOfLeaders[1]),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchListOfLeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.black,
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('LEADERBOARD'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(SubmissionScreen.routeName);
                },
                textColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
            bottom: TabBar(
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              labelPadding: EdgeInsets.all(10),
              indicatorWeight: 5,
              indicatorColor: Colors.white,
              tabs: [
                Text(
                  'Learning Leaders',
                ),
                Text(
                  'Skill IQ Leaders',
                ),
              ],
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }
}
