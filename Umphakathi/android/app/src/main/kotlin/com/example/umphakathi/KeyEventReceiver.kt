package com.echoless.the_meet_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.view.KeyEvent
import java.lang.ref.WeakReference

class KeyEventReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "KeyEventReceiver"
        private var isRegistered = false
        private var receiver: KeyEventReceiver? = null
        private var serviceRef: WeakReference<PanicButtonService>? = null
        
        fun register(context: Context, service: PanicButtonService? = null) {
            if (isRegistered && receiver != null) {
                // Already registered, just update the service reference
                serviceRef = if (service != null) WeakReference(service) else null
                Log.d(TAG, "KeyEventReceiver already registered, updated service reference")
                return
            }
            
            try {
                val filter = IntentFilter().apply {
                    addAction(Intent.ACTION_SCREEN_ON)
                    addAction(Intent.ACTION_SCREEN_OFF)
                    addAction(Intent.ACTION_CLOSE_SYSTEM_DIALOGS) // Home button
                    
                    // Register for MEDIA_BUTTON intents, which include volume buttons on some devices
                    addAction(Intent.ACTION_MEDIA_BUTTON)
                    
                    // Add volume button specific actions
                    addAction("android.media.VOLUME_CHANGED_ACTION")
                    
                    priority = IntentFilter.SYSTEM_HIGH_PRIORITY
                }

                receiver = KeyEventReceiver()
                serviceRef = if (service != null) WeakReference(service) else null
                  context.applicationContext.registerReceiver(
                    receiver,
                    filter,
                    Context.RECEIVER_NOT_EXPORTED
                )
                
                isRegistered = true
                Log.d(TAG, "KeyEventReceiver registered successfully with service: ${service != null}")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to register KeyEventReceiver: ${e.message}")
            }
        }

        fun unregister(context: Context) {
            if (!isRegistered || receiver == null) return
            
            try {
                context.applicationContext.unregisterReceiver(receiver)
                isRegistered = false
                receiver = null
                serviceRef = null
                Log.d(TAG, "KeyEventReceiver unregistered")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to unregister KeyEventReceiver: ${e.message}")            }
        }
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "🔍 KeyEventReceiver: Received action: $action")

        when (action) {
            Intent.ACTION_SCREEN_ON -> {
                Log.d(TAG, "🔍 Screen turned ON")
                // When screen turns on, make sure our service is still active and properly configured
                if (PanicButtonService.isRunning) {
                    Log.d(TAG, "🔍 Panic button service is still running with screen on, ensuring monitoring is active")
                    // Notify Flutter of state if needed
                    VolumeButtonPlugin.getInstance()?.notifyServiceStateChanged(true)
                }
            }
            Intent.ACTION_SCREEN_OFF -> {
                Log.d(TAG, "🔍 Screen turned OFF - ensuring wake lock is active")
                
                // This is critical for maintaining detection when screen is off
                val service = serviceRef?.get()
                if (service != null) {
                    // Make sure our service has an active wake lock when screen turns off
                    Log.d(TAG, "🔍 Re-ensuring wake lock is active for screen off state")
                    
                    // Call service method to reacquire wake lock if needed
                    try {
                        service.javaClass.getDeclaredMethod("acquireWakeLock").apply {
                            isAccessible = true
                            invoke(service)
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Failed to reacquire wake lock: ${e.message}")
                    }
                }
            }
            Intent.ACTION_MEDIA_BUTTON -> {
                Log.d(TAG, "🔍 Media button received")
                val keyEvent = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT, KeyEvent::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT)
                }
                
                keyEvent?.let {
                    Log.d(TAG, "🔍 Handling key event: ${it.keyCode}, action: ${it.action}")
                    handleKeyEvent(it)
                }
            }
            "android.media.VOLUME_CHANGED_ACTION" -> {
                // Direct handling of volume change broadcasts
                val keyCode = when (intent.getIntExtra("android.media.EXTRA_VOLUME_STREAM_TYPE", -1)) {
                    0 -> KeyEvent.KEYCODE_VOLUME_UP  // Assuming up for now, would need to check old/new value
                    1 -> KeyEvent.KEYCODE_VOLUME_DOWN
                    else -> 0
                }
                
                if (keyCode != 0) {
                    Log.d(TAG, "🚨 Volume change detected from broadcast, forwarding as key: $keyCode")
                    val service = serviceRef?.get()
                    service?.processKeyEvent(keyCode, KeyEvent.ACTION_DOWN)
                }
            }
            Intent.ACTION_CLOSE_SYSTEM_DIALOGS -> {
                val reason = intent.getStringExtra("reason")
                Log.d(TAG, "🔍 System dialogs closed, reason: $reason")
            }
        }
    }
      // Handle volume key events
    private fun handleKeyEvent(event: KeyEvent) {
        val keyCode = event.keyCode
        val action = event.action
        
        Log.d(TAG, "🎯 Key event received: keyCode=$keyCode, action=$action")
        
        // Check if this is a volume button or other potential panic key
        if (PanicButtonService.isRunning && (
                keyCode == KeyEvent.KEYCODE_VOLUME_UP || 
                keyCode == KeyEvent.KEYCODE_VOLUME_DOWN ||
                keyCode == KeyEvent.KEYCODE_CAMERA ||
                keyCode == KeyEvent.KEYCODE_POWER
            )) {
            
            Log.d(TAG, "🚨 DETECTED: Hardware button ($keyCode) while service running")
            
            // Forward to service
            val service = serviceRef?.get()
            if (service != null) {
                service.processKeyEvent(keyCode, action)
            } else {
                Log.d(TAG, "Service reference is null, sending event directly")
                // Try direct event sending as fallback
                when (keyCode) {
                    KeyEvent.KEYCODE_VOLUME_UP -> PanicButtonService.sendPanicEvent("volume_up", "volume")
                    KeyEvent.KEYCODE_VOLUME_DOWN -> PanicButtonService.sendPanicEvent("volume_down", "volume")
                    KeyEvent.KEYCODE_CAMERA -> PanicButtonService.sendPanicEvent("camera", "hardware")
                    KeyEvent.KEYCODE_POWER -> PanicButtonService.sendPanicEvent("power", "hardware")
                }
            }
            
            // Also send directly to VolumeButtonPlugin to handle case where service ref is lost
            when {
                keyCode == KeyEvent.KEYCODE_VOLUME_UP && action == KeyEvent.ACTION_DOWN -> {
                    VolumeButtonPlugin.sendButtonEvent("volume_up", "volume")
                }
                keyCode == KeyEvent.KEYCODE_VOLUME_DOWN && action == KeyEvent.ACTION_DOWN -> {
                    VolumeButtonPlugin.sendButtonEvent("volume_down", "volume")
                }
            }
        }
    }
}
