part of space_client;

class ConnectionManager {
  
  WorldController _wc;
  LatencyCounter _lc;
  MessageChecker _mc;
  WebSocket _ws;
  int _playerId;
      
  ConnectionManager(this._wc) {
    _lc = new LatencyCounter();
    _mc = new MessageChecker();
    _connect();
  }
  
  _connect() {
    print("client connecting to server");
    _ws = new WebSocket("ws://127.0.0.1:8080");
    _ws.onError.listen((e) => print("error"));
    _ws.onClose.listen((e) => print("client closed"));
    _ws.onOpen.listen((e) {
      _requestId();
      new Timer.periodic(new Duration(milliseconds:500), (t) {
        _ping();
      });
    });
    _ws.onMessage.listen((MessageEvent event) {
      _onMessage(event.data);
    });
  }
  
  void _onMessage(var rawData) {
    JsonObject data;
    try {
      data = new JsonObject.fromJsonString(rawData);
    } catch (error) {
      print("Error parsing JSON: $rawData");
    }
    print(data);

    Type messageType = _mc.getMessageType(data);
    switch (messageType) {
      case UpdateMessage:
        for (String idS in data.u.keys) {
          int id = int.parse(idS);
          if (id != _playerId) {
            _wc.internetPlayerUpdate(id, data.u[idS], _lc.oneWayLatency);
          }
        }
        break;
      case PingMessage:
        _lc.checkInPingId(data.p);
        break;
      case JoinMessage:
        for (String idS in data.j.keys) {
          int id = int.parse(idS);
          if (id == _playerId) _wc.localPlayerJoin(id);
          else _wc.internetPlayerJoin(id);
        }
        break;
      case IdMessage:
        _playerId = data.i;
        new Timer.periodic(new Duration(milliseconds:100), (t) => _sendInput());
        break;
      case MalformedMessage:
        print("Bad data received: $data");
        break;
    }
  }
  
  void _ping() {
    _ws.send(stringify({"p":_lc.checkoutPingId()}));
  }
  
  void _requestId() {
    _ws.send(stringify({"j":0}));
  }
  
  void _sendInput() {
    _ws.send(stringify({"u":_wc.playerInput}));
  }
}