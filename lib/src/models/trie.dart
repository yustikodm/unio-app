class Trie {
  Node root;

  Trie() {
    root = new Node('/0');
  }

  // insert a word to the trie
  void insert(String word, String rootWord) {
    Node curr = root;
    int index = word.indexOf(" ");
    String nextWord = index != -1 ? word.substring(index + 1, word.length) : '';
    String wNoSpace = word.replaceAll(new RegExp(r"\s+"), "");

    for (int i = 0; i < wNoSpace.length; i++) {
      String char = wNoSpace[i];
      if (curr.children[char] == null) curr.children[char] = new Node(char);
      curr.children[char].addWord(rootWord);
      curr = curr.children[char];
    }

    curr.isWord = true;

    // if (nextWord.isNotEmpty) {
    //   insert(nextWord, rootWord);
    // }
  }

  // search word in a trie that starts with ...
  List<String> startsWith(String prefix) {
    String wNoSpace = prefix.replaceAll(new RegExp(r"\s+"), "");
    Node node = getNode(wNoSpace);
    List<String> list = node != null ? node.getSizedWords(5) : [];
    return list;
  }

  // helper functions to get a node
  Node getNode(String word) {
    // print(word);
    Node curr = root;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (curr.children[char] == null && !curr.isWord) return null;
      curr = curr.children[char];
    }
    return curr;
  }
}

class Node {
  final String char;

  bool isWord = false;
  bool hasNextWord = false;
  Map children = new Map();
  List<String> words = [];

  Node(this.char);

  void addWord(String word) {
    words.add(word);
  }

  List<String> getSizedWords(int size) {
    List<String> _w = [];
    for (int i = 0; i < size; i++) {
      _w.add(words[i]);
    }
    return _w;
  }
}
