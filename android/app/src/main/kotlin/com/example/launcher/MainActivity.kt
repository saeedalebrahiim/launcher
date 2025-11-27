package com.example.launcher

import android.app.ActivityManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.SortedMap
import java.util.TreeMap

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.launcher/app_monitor"
    private lateinit var activityManager: ActivityManager
    private var usageStatsManager: UsageStatsManager? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        android.util.Log.d("MainActivity", "Configuring Flutter Engine with channel: $CHANNEL")
        
        activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        }
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            android.util.Log.d("MainActivity", "Received method call: ${call.method}")
            when (call.method) {
                "getCurrentApp" -> {
                    val currentApp = getCurrentForegroundApp()
                    result.success(currentApp)
                }
                "closeApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        closeApp(packageName)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getCurrentForegroundApp(): String? {
        return try {
            // Try RunningTasks first (works without special permissions)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                try {
                    val tasks = activityManager.getRunningTasks(1)
                    if (tasks.isNotEmpty()) {
                        val packageName = tasks[0].topActivity?.packageName
                        if (packageName != null) {
                            return packageName
                        }
                    }
                } catch (e: Exception) {
                    // Permission denied, try UsageStats
                }
            }
            
            // Fallback to UsageStatsManager for Android 5.1+ (requires permission)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1 && usageStatsManager != null) {
                val time = System.currentTimeMillis()
                val stats = usageStatsManager!!.queryUsageStats(
                    UsageStatsManager.INTERVAL_DAILY,
                    time - 1000 * 5, // Last 5 seconds
                    time
                )
                
                if (stats != null && stats.isNotEmpty()) {
                    // Find most recently used app
                    var recentApp: UsageStats? = null
                    var recentTime: Long = 0
                    
                    for (usageStats in stats) {
                        if (usageStats.lastTimeUsed > recentTime) {
                            recentApp = usageStats
                            recentTime = usageStats.lastTimeUsed
                        }
                    }
                    
                    return recentApp?.packageName
                }
            }
            
            null
        } catch (e: Exception) {
            null
        }
    }

    private fun closeApp(packageName: String) {
        try {
            // First, bring home screen to front (our launcher)
            val homeIntent = android.content.Intent(android.content.Intent.ACTION_MAIN)
            homeIntent.addCategory(android.content.Intent.CATEGORY_HOME)
            homeIntent.flags = android.content.Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(homeIntent)
            
            // Then kill the app's background processes
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                try {
                    activityManager.killBackgroundProcesses(packageName)
                } catch (e: Exception) {
                    // May fail due to permissions
                }
            }, 200)
        } catch (e: Exception) {
            // Fallback: at least try to go home
            try {
                val homeIntent = android.content.Intent(android.content.Intent.ACTION_MAIN)
                homeIntent.addCategory(android.content.Intent.CATEGORY_HOME)
                homeIntent.flags = android.content.Intent.FLAG_ACTIVITY_NEW_TASK
                startActivity(homeIntent)
            } catch (e2: Exception) {
                // Last resort failed
            }
        }
    }
}
