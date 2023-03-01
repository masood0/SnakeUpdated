
class LoadSnakeData{
  final String snakeName;
  final String snakeVenom;
  final String imageUrl;
  final String wikUrl;
  final String ranking;
  const LoadSnakeData({
    required this.snakeName,
    required this.snakeVenom,
    required this.imageUrl,
    required this.wikUrl,
    required this.ranking,

  });

  static LoadSnakeData fromJson(json)=>LoadSnakeData(
      snakeName:json['username'],
      snakeVenom: json['email'],
      imageUrl: json['url'],
    wikUrl:json['wikUrl'],
    ranking:json['ranking'],
  );


}

