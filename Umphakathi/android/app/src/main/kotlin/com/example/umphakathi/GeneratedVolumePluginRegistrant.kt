package com.echoless.the_meet_app

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.PluginRegistry

class GeneratedVolumePluginRegistrant {
    companion object {
        fun registerWith(registry: FlutterPluginBinding) {
            if (alreadyRegisteredWith(registry)) {
                return
            }
            
            VolumeButtonPlugin().onAttachedToEngine(registry)
        }
        
        private fun alreadyRegisteredWith(registry: FlutterPluginBinding): Boolean {
            // No way to check directly, but we can try to avoid double registration
            return false
        }
    }
}
