class DailyTask {
  final int? id;
  final String date;
  final String text;
  final int color;
  final int? timeMinutes;
  final int? status; // null: غير محددة، 0: غير مكتملة، 1: مكتملة
  final bool repeatDaily;
  final int createdAt;

  const DailyTask({this.id, required this.date, required this.text, required this.color, this.timeMinutes, this.status, this.repeatDaily = false, required this.createdAt});
  DailyTask copyWith({int? id, String? date, String? text, int? color, Object? timeMinutes = _keep, Object? status = _keep, bool? repeatDaily, int? createdAt}) => DailyTask(id: id ?? this.id, date: date ?? this.date, text: text ?? this.text, color: color ?? this.color, timeMinutes: timeMinutes == _keep ? this.timeMinutes : timeMinutes as int?, status: status == _keep ? this.status : status as int?, repeatDaily: repeatDaily ?? this.repeatDaily, createdAt: createdAt ?? this.createdAt);
  Map<String, Object?> toMap() => {'id': id, 'date': date, 'text': text, 'color': color, 'time_minutes': timeMinutes, 'status': status, 'repeat_daily': repeatDaily ? 1 : 0, 'created_at': createdAt};
  factory DailyTask.fromMap(Map<String, Object?> m) => DailyTask(id: m['id'] as int?, date: m['date'] as String, text: m['text'] as String, color: m['color'] as int, timeMinutes: m['time_minutes'] as int?, status: m['status'] as int?, repeatDaily: (m['repeat_daily'] as int? ?? 0) == 1, createdAt: m['created_at'] as int);
}
const _keep = Object();
