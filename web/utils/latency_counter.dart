part of space_client;

class LatencyCounter {
  
  Queue<num> _latencies;
  num _latencySum;
  int _amount;
  
  Map<int, int> _requests;
  int _idCounter;
  
  num twoWayLatency;
  num oneWayLatency;
  
  LatencyCounter() {
    _latencies = new ListQueue();
    _requests = new HashMap<int, int>();
    _amount = 5;
    _idCounter = 0;
    _latencySum = 0;
    twoWayLatency = 0;
    oneWayLatency = 0;
  }
    
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
    
    twoWayLatency = _latencySum / _amount / 1000;
    oneWayLatency = twoWayLatency / 2;
  }
  
  void _first(num latency) {
    for (int i = 0; i <= _amount; i++) {
      _latencies.addFirst(latency);
    }
    _latencySum = _amount*latency;
  }
}