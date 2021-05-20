class Question {
  final String typeOne;
  final String imgOne;
  final String typeTwo;
  final String imgTwo;

  Question({this.typeOne, this.imgOne, this.typeTwo, this.imgTwo});

  factory Question.fromJson(Map<String, dynamic> json) {
    // Map<String, dynamic> data = json['data'];
    return Question(
      typeOne: json['quest_one_type'],
      imgOne: json['quest_one_img_src'],
      typeTwo: json['quest_two_type'],
      imgTwo: json['quest_two_img_src'],
    );
  }
}

const List sample_data = [
  {
    "id": 1,
    "question": "Mana yg lebih anda sukai?",
    "options": ["bersepeda.jpg", "jalan.jpg"],
    "answer_index": 2,
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
