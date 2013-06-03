part of space_client;

class MessageChecker {
  Type getMessageType(JsonObject data) {
    try {
      if (data.u != null) {
        return UpdateMessage;
      }
    } catch (error) {}
    try {
      if (data.p != null) {
        return PingMessage;
      }
    } catch (error) {}
    try {
      if (data.j != null) {
        return JoinMessage;
      }
    } catch (error) {}
    try {
      if (data.i != null) {
        return IdMessage;
      }
    } catch (error) {}
    return MalformedMessage;
  }
}