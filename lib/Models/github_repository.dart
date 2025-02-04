class GitHubRepository {
  final String name;
  final String description;
  final int stars;
  final String owner;
  final String avatarUrl;

  GitHubRepository({
    required this.name,
    required this.description,
    required this.stars,
    required this.owner,
    required this.avatarUrl,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      stars: json['stargazers_count'] ?? 0,
      owner: json['owner']['login'] ?? 'Unknown',
      avatarUrl: json['owner']['avatar_url'] ?? '',
    );
  }
}
