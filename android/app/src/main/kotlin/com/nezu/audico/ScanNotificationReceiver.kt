package com.nezu.audico

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationManagerCompat

class ScanNotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_STOP) {
            NotificationManagerCompat.from(context).cancel(7001)
        }
        // TODO: connect notification actions to Flutter/audio service state.
    }

    companion object {
        const val ACTION_STOP = "com.nezu.audico.STOP_SCAN"
        const val ACTION_PAUSE = "com.nezu.audico.PAUSE_SCAN"

        fun intent(context: Context, action: String): Intent =
            Intent(context, ScanNotificationReceiver::class.java).setAction(action)
    }
}
