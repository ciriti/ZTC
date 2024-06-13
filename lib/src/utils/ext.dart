extension IntBytes on int {
  List<int> toBytes() {
    var bytes = <int>[];
    for (int i = 0; i < 8; i++) {
      bytes.add((this >> (i * 8)) & 0xFF);
    }
    return bytes;
  }
}

extension BytesInt on List<int> {
  int toInt() {
    int value = 0;
    for (int i = 0; i < 8; i++) {
      value |= (this[i] & 0xFF) << (i * 8);
    }
    return value;
  }
}

bool isTimestampExpired(int timestamp, int validitySeconds) {
  final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return (currentTime - timestamp) > validitySeconds;
}
