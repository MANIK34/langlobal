
class SourceCartonConditions{

  var containerConditionID;
  String containerConditionText;

  SourceCartonConditions({required this.containerConditionID, required this.containerConditionText});

  factory SourceCartonConditions.fromJson(Map<String, dynamic> json) {
    return SourceCartonConditions(
      containerConditionID: json['containerConditionID'],
      containerConditionText: json['containerConditionText'].toString(),
    );
  }
}