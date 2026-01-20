abstract class MethodClass {
  int id;
  String title;
  String subtitle;
  String index;
  bool success;
  double result;
  String message;
  int iterations;

  MethodClass({
    this.id = 0,
    this.title = "",
    this.subtitle = "",
    this.index = "",
    this.success = false,
    this.result = 0.0,
    this.message = "",
    this.iterations = 0
  });

  void initialize() {
    success = false;
    result = 0.0;
    message = "";
    iterations = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'index': index,
      'success': success,
      'result': result,
      'message': message,
      'iterations': iterations,
    };
  }

  String getResultSummary() {
    return 'Método: $title\nResultado: $result\nIteraciones: $iterations\nÉxito: $success';
  }
}
