package com.echoless.the_meet_app

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Plugin to handle volume button detection both in foreground and background
 */
class VolumeButtonPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    // Static channel so service can access it
    companion object {
        private const val TAG = "VolumeButtonPlugin"
        private const val CHANNEL_NAME = "com.echoless.the_meet_app/volume_buttons"
        
        // Store instance for static access from services
        @Volatile
        private var instance: VolumeButtonPlugin? = null
        
        // Method to get singleton instance
        fun getInstance(): VolumeButtonPlugin? = instance
        
        // Main activity listening state
        var isListening = false
        
        // Send event from service to Flutter
        fun sendButtonEvent(action: String, type: String) {
            instance?.sendButtonEventToFlutter(action, type)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Plugin attached to engine")
        
        applicationContext = flutterPluginBinding.applicationContext
        setupChannel(flutterPluginBinding.binaryMessenger)
        
        // Store instance for static access
        instance = this
    }

    private fun setupChannel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        Log.d(TAG, "Method channel setup complete")
    }    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d(TAG, "Method call received: ${call.method}")
        
        when (call.method) {
            "startListening" -> {
                isListening = true
                startPanicDetection()
                result.success(true)
                Log.d(TAG, "Started listening for button presses")
            }
            "stopListening" -> {
                isListening = false
                stopPanicDetection()
                result.success(true)
                Log.d(TAG, "Stopped listening for button presses")
            }
            "isServiceRunning" -> {
                val isRunning = PanicButtonService.isRunning
                result.success(isRunning)
                Log.d(TAG, "Checking if service running: $isRunning")
            }
            "requestNotificationPermissions" -> {
                // This would be better handled in the main activity
                result.success(true)
            }
            "simulateButtonPress" -> {
                val action = call.argument<String>("action") ?: "volume_up"
                val type = call.argument<String>("type") ?: "volume"
                val source = call.argument<String>("source") ?: "test"
                
                Log.d(TAG, "🧪 Simulating button press from Flutter: $action")
                simulateButtonPress(action, type, source)
                result.success(true)
            }
            else -> {
                result.notImplemented()
                Log.d(TAG, "Method not implemented: ${call.method}")
            }
        }
    }    private fun startPanicDetection() {
        try {
            val serviceIntent = Intent(applicationContext, PanicButtonService::class.java)
            serviceIntent.putExtra(PanicButtonService.KEY_LISTENING, true)
            
            Log.d(TAG, "Starting foreground service")
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                applicationContext.startForegroundService(serviceIntent)
            } else {
                applicationContext.startService(serviceIntent)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error starting service: ${e.message}")
        }
    }

    private fun stopPanicDetection() {
        try {
            val serviceIntent = Intent(applicationContext, PanicButtonService::class.java)
            serviceIntent.putExtra(PanicButtonService.KEY_LISTENING, false)
            applicationContext.stopService(serviceIntent)
            Log.d(TAG, "Stopping foreground service")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping service: ${e.message}")
        }
    }

    // Notify Flutter about service state changes from background
    fun notifyServiceStateChanged(isActive: Boolean) {
        try {
            Log.d(TAG, "Notifying Flutter about service state change: $isActive")
            
            // Use the UI thread for method channel communication
            Handler(Looper.getMainLooper()).post {
                try {
                    val args = HashMap<String, Any>()
                    args["isActive"] = isActive
                    args["timestamp"] = System.currentTimeMillis()
                    
                    // Only invoke if we have a valid channel
                    if (::channel.isInitialized) {
                        channel.invokeMethod("serviceStateChanged", args)
                        Log.d(TAG, "Successfully sent service state update to Flutter")
                    } else {
                        Log.e(TAG, "Cannot notify Flutter: channel not initialized")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error sending service state to Flutter: ${e.message}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to notify Flutter about service state: ${e.message}")
        }
    }

    // Send button event from background service to Flutter
    fun sendButtonEventToFlutter(action: String, type: String) {
        try {
            Log.d(TAG, "Sending button event to Flutter: $action")
            
            // Use the UI thread for method channel communication
            Handler(Looper.getMainLooper()).post {
                try {
                    val args = HashMap<String, Any>()
                    args["action"] = action
                    args["type"] = type
                    args["source"] = "background_service"
                    args["timestamp"] = System.currentTimeMillis()
                    
                    // Only invoke if we have a valid channel
                    if (::channel.isInitialized) {
                        channel.invokeMethod("buttonPressed", args)
                        Log.d(TAG, "Successfully sent button event to Flutter")
                    } else {
                        Log.e(TAG, "Cannot send button event: channel not initialized")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error sending button event to Flutter: ${e.message}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to send button event to Flutter: ${e.message}")
        }
    }

    // Include methods for manually simulating button presses for diagnostics
    fun simulateButtonPress(action: String, type: String) {
        try {
            Log.d(TAG, "🔧 DEBUG: Simulating button press: $action ($type)")
            // Send directly to Flutter without involving the service
            sendButtonEventToFlutter(action, type)
        } catch (e: Exception) {
            Log.e(TAG, "Error simulating button press: ${e.message}")
        }
    }

    // For testing background detection
    fun simulateButtonPress(action: String, type: String, source: String) {
        Log.d(TAG, "🧪 SIMULATING button press: $action ($type) from $source")
        
        // Create arguments map
        val args = HashMap<String, Any>()
        args["action"] = action
        args["type"] = type 
        args["source"] = source
        args["timestamp"] = System.currentTimeMillis()
        
        // Send via plugin's method
        sendButtonEvent(action, type)
        
        // Also directly notify
        try {
            Handler(Looper.getMainLooper()).post {
                if (::channel.isInitialized) {
                    channel.invokeMethod("buttonPressed", args)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to simulate button: ${e.message}")
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        if (::channel.isInitialized) {
            channel.setMethodCallHandler(null)
        }
        Log.d(TAG, "Plugin detached from engine")
        
        // Don't clear instance reference - we need it for background service
        // We'll keep the static instance for background service communication
    }
}
