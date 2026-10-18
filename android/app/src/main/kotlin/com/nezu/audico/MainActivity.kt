package com.nezu.audico

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "audico/notifications"
    private val notificationChannelId = "audico_scan"
    private val notificationId = 7001
    private val notificationPermissionRequest = 7002

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showScanNotification" -> {
                        showScanNotification()
                        result.success(null)
                    }
                    "hideScanNotification" -> {
                        NotificationManagerCompat.from(this).cancel(notificationId)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun showScanNotification() {
        createNotificationChannel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                notificationPermissionRequest
            )
            return
        }
        postScanNotification()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == notificationPermissionRequest && grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) {
            postScanNotification()
        }
    }

    private fun postScanNotification() {
        val stopIntent = ScanNotificationReceiver.intent(this, ScanNotificationReceiver.ACTION_STOP)
        val pauseIntent = ScanNotificationReceiver.intent(this, ScanNotificationReceiver.ACTION_PAUSE)
        val stopPendingIntent = PendingIntent.getBroadcast(
            this, 701, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val pausePendingIntent = PendingIntent.getBroadcast(
            this, 702, pauseIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val builder = NotificationCompat.Builder(this, notificationChannelId)
            .setSmallIcon(com.nezu.audico.R.mipmap.ic_launcher)
            .setContentTitle("AudiCo sedang memindai")
            .setContentText("Hujan di Kota • Audio suasana aktif")
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .addAction(com.nezu.audico.R.mipmap.ic_launcher, "Jeda", pausePendingIntent)
            .addAction(com.nezu.audico.R.mipmap.ic_launcher, "Hentikan", stopPendingIntent)
        NotificationManagerCompat.from(this).notify(notificationId, builder.build())
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                notificationChannelId,
                "AudiCo Scan",
                NotificationManager.IMPORTANCE_LOW
            ).apply { description = "Kontrol scan dan audio AudiCo" }
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }
}
