import 'dart:convert';
import 'dart:io';

import 'package:gads2020/exceptions.dart';
import 'package:gads2020/models/models.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  final _baseUrl = 'https://gadsapi.herokuapp.com/';

  Future<List<Leader>> getLeaders(LeaderType type) async {
    var url = _baseUrl;
    if (type == LeaderType.LearningLeader) {
      url += 'api/hours/';
    } else if (type == LeaderType.SkillIQLeader) {
      url += 'api/skilliq/';
    }

    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200 && response.body != null) {
        if (json.decode(response.body) is Map) {
          throw AppException(json.decode(response.body)['message']);
        } else {
          final List<dynamic> list = json.decode(response.body);
          final List<Map<String, dynamic>> listMap = list
              .map<Map<String, dynamic>>(
                  (data) => Map<String, dynamic>.from(data))
              .toList();
          return listMap.map<Leader>((map) => Leader.fromJson(map)).toList();
        }
      } else {
        throw AppException('Data not found.');
      }
    } on SocketException {
      throw AppException('No Internet connection.');
    }
  }

  Future<bool> submitProject(String firstName, String lastName,
      String emailAddress, String gitHubLink) async {
    // final client = HttpClient();
    final url =
        'https://docs.google.com/forms/d/e/1FAIpQLSf9d1TcNU6zc6KR8bSEM41Z1g1zl35cwZr2xyjIhaMAz8WChQ/formResponse';
    // final uri = Uri.parse(url);

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          // 'User-Agent': client.userAgent,
          // 'Host': uri.host,
          // 'Accept': '*/*',
          // 'Accept-Encoding': 'gzip, deflate, br',
        },
        body: {
          'entry.1824927963': emailAddress,
          'entry.1877115667': firstName,
          'entry.2006916086': lastName,
          'entry.284483984': gitHubLink,
        },
      );
      return response.statusCode == 200;
    } on SocketException {
      throw AppException('No Internet connection.');
    }
  }
}
