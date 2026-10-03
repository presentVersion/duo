class Milestone {
  final int targetDays;
  final String title;
  final String description;
  final int rewardFreezes;
  final String videoAsset;
  final String iconAsset;
  bool isClaimed;

  Milestone({
    required this.targetDays,
    required this.title,
    required this.description,
    required this.rewardFreezes,
    required this.videoAsset,
    required this.iconAsset,
    this.isClaimed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetDays': targetDays,
      'title': title,
      'description': description,
      'rewardFreezes': rewardFreezes,
      'videoAsset': videoAsset,
      'iconAsset': iconAsset,
      'isClaimed': isClaimed,
    };
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      targetDays: json['targetDays'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      rewardFreezes: json['rewardFreezes'] as int,
      videoAsset: json['videoAsset'] as String,
      iconAsset: json['iconAsset'] as String,
      isClaimed: (json['isClaimed'] as bool?) ?? false,
    );
  }
}
