package com.echoless.the_meet_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import android.view.KeyEvent
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.MethodChannel

class PanicButtonService : Service() {
    private val TAG = "PanicButtonService"
    private val CHANNEL_ID = "PanicButtonChannel"
    private val NOTIFICATION_ID = 101
    private var wakeLock: PowerManager.WakeLock? = null
    
    companion object {
        var isRunning = false
        const val KEY_LISTENING = "is_listening"
        private const val ACTION_STOP = "com.echoless.the_meet_app.STOP_SERVICE"
        
        // For key events from hardware buttons
        fun sendPanicEvent(action: String, type: String) {
            Log.d("PanicButtonService", "Service sending panic event: $action")
            
            // Use the plugin to send events
            VolumeButtonPlugin.sendButtonEvent(action, type)
        }
    }

    // Create a class that intercepts key events globally
    // This service will work with KeyEventReceiver to detect volume buttons
    // We need this to be a separate class since services can't directly receive key events
    fun processKeyEvent(keyCode: Int, action: Int) {
        if (action == KeyEvent.ACTION_DOWN) {
            when (keyCode) {
                KeyEvent.KEYCODE_VOLUME_UP -> {
                    Log.d(TAG, "🚨 SERVICE DETECTED: Volume UP pressed during SafeWalk monitoring")
                    sendPanicEvent("volume_up", "volume")
                }
                KeyEvent.KEYCODE_VOLUME_DOWN -> {
                    Log.d(TAG, "🚨 SERVICE DETECTED: Volume DOWN pressed during SafeWalk monitoring")
                    sendPanicEvent("volume_down", "volume")
                }
            }        }
    }
    
    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate - initializing panic button service")
        createNotificationChannel()
        
        // Register volume key receiver
        KeyEventReceiver.register(this, this)
        
        // Make sure we have a wake lock
        acquireWakeLock()
        
        // Service is now running        isRunning = true
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "🚀 Service onStartCommand - intent: ${intent?.action}, extras: ${intent?.extras}")
        
        when (intent?.action) {
            ACTION_STOP -> {
                Log.d(TAG, "🛑 Received stop action, stopping service")
                stopForegroundAndCleanup(true)
                return START_NOT_STICKY
            }
        }

        val isListening = intent?.getBooleanExtra(KEY_LISTENING, false) ?: false
          if (isListening) {
            Log.d(TAG, "🟢 Starting foreground service for panic button detection")
            
            try {
                // Start as foreground service with notification to prevent system kills
                startForeground(NOTIFICATION_ID, createNotification(
                    "SafeWalk Protection Active", 
                    "Monitoring for panic buttons - even when screen is off"
                ))
                
                // Make sure wake lock is acquired for screen off detection
                acquireWakeLock()
                
                // Refresh key event receiver registration with reference to this service
                KeyEventReceiver.register(this, this)
                
                // Set global running flag
                isRunning = true
                
                // Notify Flutter about service state change
                notifyFlutterAboutServiceState(true)
                
                // Signal that we want service restarted if killed
                Log.d(TAG, "✅ Foreground service started successfully")
                return START_REDELIVER_INTENT
            } catch (e: SecurityException) {
                // This can happen if the required foreground service permissions are not granted
                Log.e(TAG, "SecurityException when starting foreground service: ${e.message}")
                Log.e(TAG, "Missing permissions for foreground service with location type")
                
                // Clean up and stop
                releaseWakeLock()
                isRunning = false
                KeyEventReceiver.unregister(this)
                stopSelf()
                
                // Notify Flutter about the failure
                notifyFlutterAboutServiceState(false)
                
                return START_NOT_STICKY
            } catch (e: Exception) {
                // Handle other exceptions
                Log.e(TAG, "Exception when starting foreground service: ${e.message}")
                e.printStackTrace()
                
                // Clean up and stop
                releaseWakeLock()
                isRunning = false
                KeyEventReceiver.unregister(this)
                stopSelf()
                
                // Notify Flutter about the failure
                notifyFlutterAboutServiceState(false)
                
                return START_NOT_STICKY
            }
        } else {
            Log.d(TAG, "🛑 Stopping foreground service for panic button detection")
            stopForegroundAndCleanup(false)
            return START_NOT_STICKY
        }
    }
    
    private fun stopForegroundAndCleanup(notifyFlutter: Boolean) {
        // Unregister key event receiver
        KeyEventReceiver.unregister(this)
        
        // Release wake lock
        releaseWakeLock()
        
        // Stop foreground service
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        
        // Stop the service itself
        stopSelf()
        
        // Update running status
        isRunning = false
        
        // Notify Flutter if requested
        if (notifyFlutter) {
            notifyFlutterAboutServiceState(false)
        }
        
        Log.d(TAG, "✅ Foreground service stopped successfully")
    }
    
    // Notify Flutter about service state changes
    private fun notifyFlutterAboutServiceState(isActive: Boolean) {
        try {
            Log.d(TAG, "Notifying Flutter that service is ${if (isActive) "active" else "stopped"}")
            val plugin = VolumeButtonPlugin.getInstance()
            plugin?.notifyServiceStateChanged(isActive)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to notify Flutter about service state: ${e.message}")
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(CHANNEL_ID, "SafeWalk Protection", importance).apply {
                description = "Monitors panic buttons for SafeWalk protection"
                setSound(null, null)
                enableVibration(false)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
            Log.d(TAG, "Created notification channel for foreground service")
        }
    }
    
    private fun createNotification(title: String, message: String): Notification {
        val stopIntent = Intent(this, PanicButtonService::class.java).apply {
            action = ACTION_STOP
        }
        
        val stopPendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getService(
                this, 0, stopIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        } else {
            PendingIntent.getService(
                this, 0, stopIntent, PendingIntent.FLAG_UPDATE_CURRENT
            )
        }
        
        // Create launcher intent for app
        val packageManager = packageManager
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val activityPendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getActivity(
                this, 1, launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        } else {
            PendingIntent.getActivity(
                this, 1, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT
            )
        }
        
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            NotificationCompat.Builder(this)
        }
        
        return builder
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(android.R.drawable.ic_secure)
            .setOngoing(true)
            .setContentIntent(activityPendingIntent)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopPendingIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setSilent(true)
            .build()
    }

    // Acquire proper wake lock to keep CPU running while screen is off
    private fun acquireWakeLock() {
        if (wakeLock == null || !wakeLock!!.isHeld) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "TheMeetApp:PanicButtonWakeLock"
            )
            wakeLock?.setReferenceCounted(false)
            wakeLock?.acquire(60*60*1000L) // 1 hour timeout for safety
            Log.d(TAG, "Acquired partial wake lock for background detection")
        }
    }
    
    // Release wake lock when service stops
    private fun releaseWakeLock() {
        if (wakeLock != null && wakeLock!!.isHeld) {
            wakeLock?.release()
            Log.d(TAG, "Released wake lock")
        }
    }

    override fun onBind(intent: Intent?): IBinder? {        return null
    }
    
    override fun onDestroy() {
        Log.d(TAG, "Service onDestroy")
        releaseWakeLock()
        isRunning = false
        try {
            KeyEventReceiver.unregister(this)
            Log.d(TAG, "KeyEventReceiver unregistered in onDestroy")
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering KeyEventReceiver: ${e.message}")
        }
        super.onDestroy()
    }
}
