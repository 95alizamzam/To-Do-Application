class obtained_data {
  List<taskModel> mydata = [];
  obtained_data.fromJson(List<Map<String, dynamic>> json) {
    json.forEach((element) {
      mydata.add(taskModel.fromJson(element));
    });
  }
}

class taskModel {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  taskModel.fromJson(Map<String, dynamic> element) {
    id = element['id'];
    title = element['title'];
    note = element['note'];
    isCompleted = element['iscompleted'];
    date = element['date'];
    startTime = element['starttime'];
    endTime = element['endtime'];
    color = element['color'];
    remind = element['remind'];
    repeat = element['repeat'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }
}
