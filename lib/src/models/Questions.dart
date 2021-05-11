class Question {
  final int id, answer;
  final String question;
  final List<String> options;

  Question({this.id, this.question, this.answer, this.options});
}

const List sample_data = [
  {
    "id": 1,
    "question": "Mana yg lebih anda sukai?",
    "options": ["bersepeda.jpg", "jalan.jpg"],
    "answer_index": 1,
  },
  {
    "id": 2,
    "question": "Mana yg lebih anda sukai?",
    "options": ["2.makan.jpg", "2.minum.jpg"],
    "answer_index": 2,
  },
  {
    "id": 3,
    "question": "Mana yg lebih anda sukai?",
    "options": ["3.membaca.jpg", "3.menulis.jpg"],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "Mana yg lebih anda sukai?",
    "options": ["4.mobil.jpg", "4.motor.jpg"],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "Mana yg lebih anda sukai?",
    "options": ["5.olahraga.jpg", "5..tidur.jpg"],
    "answer_index": 2,
  },
];
