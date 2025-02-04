import 'package:flutter/material.dart';
import 'package:thiran_tech_task/Service/github_api_service.dart';
import '../Models/github_repository.dart';

class GitHubRepoScreen extends StatefulWidget {
  const GitHubRepoScreen({super.key});

  @override
  _GitHubRepoScreenState createState() => _GitHubRepoScreenState();
}

class _GitHubRepoScreenState extends State<GitHubRepoScreen> {
  final GitHubApiService _apiService = GitHubApiService();
  late Future<List<GitHubRepository>> _futureRepositories;

  @override
  void initState() {
    super.initState();
    _futureRepositories = _apiService.fetchRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Starred GitHub Repos")),
      body: FutureBuilder<List<GitHubRepository>>(
        future: _futureRepositories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No repositories found."));
          }

          final repositories = snapshot.data!;
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              final repo = repositories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(repo.avatarUrl),
                ),
                title: Text(repo.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(repo.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(repo.stars.toString()),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
