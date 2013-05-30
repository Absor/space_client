part of space_client;

class LatencyCounter {
  
  Queue<num> _latencies;
  num _latencySum;
  int _amount;
  
  Map<int, int> _requests;
  int _idCounter;
  
  LatencyCounter() {
    _latencies = new ListQueue();
    _requests = new HashMap<int, int>();
    _amount = 5;
    _idCounter = 0;
    _latencySum = 0;
  }
  
  num get latency => _latencySum / _amount;
  
  int checkoutPingId() {
    int id = _idCounter++;
    _requests[id] = new DateTime.now().millisecondsSinceEpoch;
    return id;
  }
  
  void checkInPingId(int id) {
    int now = new DateTime.now().millisecondsSinceEpoch;
    _addLatency(now - _requests[id]);
    _requests.remove(id);
  }
  
  void _addLatency(num latency) {
    if (_latencies.isEmpty) _first(latency);
    _latencies.addFirst(latency);
    _latencySum += latency;
    _latencySum -= _latencies.removeLast();
  }
  
  void _first(num latency) {
    for (int i = 0; i <= _amount; i++) {
      _latencies.addFirst(latency);
    }
    _latencySum = _amount*latency;
  }
}