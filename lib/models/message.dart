class Message{
  bool? premium;
  String? sender;
  String? text;

  Message.fromJson(Map<String, dynamic> json) {
    premium = json['premium'];
    sender = json['sender'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['premium'] = premium;
    data['sender'] = sender;
    data['text'] = text;
    return data;
  }
}