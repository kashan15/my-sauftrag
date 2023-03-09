import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';

class MyClass with ChannelEventHandler{
  @override
  void onMessageReceived(BaseChannel channel, BaseMessage);
}