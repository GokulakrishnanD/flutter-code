import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thiran_tech_task/Models/github_repository.dart';

class GitHubApiService {
  static const String baseUrl = "https://api.github.com/search/repositories";

  Future<List<GitHubRepository>> fetchRepositories() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final dateString =
        "${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}";

    final response = await http.get(
      Uri.parse("$baseUrl?q=created:>$dateString&sort=stars&order=desc"),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> items = jsonData['items'];
      return items.map((item) => GitHubRepository.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load repositories");
    }
  }
}
