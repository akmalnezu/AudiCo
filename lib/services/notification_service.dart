import 'package:flutter/services.dart';

class NotificationService {
  static const _channel = MethodChannel('audico/notifications');

  Future<void> showScanNotification() => _channel.invokeMethod('showScanNotification');
  Future<void> hideScanNotification() => _channel.invokeMethod('hideScanNotification');
}
