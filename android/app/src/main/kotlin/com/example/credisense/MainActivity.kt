package com.example.credisense

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.credisense/sms"
    private val SMS_PERMISSION_REQUEST = 123
    private val TAG = "CrediSenseSMS"
    
    private var smsListener: ((String, String, Long) -> Unit)? = null
    private lateinit var smsReceiver: BroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d(TAG, "Method called: ${call.method}")
            when (call.method) {
                "readSMS" -> {
                    val limit = call.argument<Int>("limit") ?: 100
                    val since = call.argument<String>("since")
                    Log.d(TAG, "Reading SMS with limit: $limit, since: $since")
                    readSMSMessages(limit, since, result)
                }
                "hasPermission" -> {
                    val hasPermission = hasSMSPermission()
                    Log.d(TAG, "Has SMS permission: $hasPermission")
                    result.success(hasPermission)
                }
                "requestPermission" -> {
                    Log.d(TAG, "Requesting SMS permission")
                    requestSMSPermission(result)
                }
                "startListening" -> {
                    Log.d(TAG, "Starting SMS listening")
                    startSMSListening(result)
                }
                "stopListening" -> {
                    Log.d(TAG, "Stopping SMS listening")
                    stopSMSListening(result)
                }
                else -> {
                    Log.w(TAG, "Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
        
        // Initialize SMS receiver
        setupSMSReceiver()
    }
    
    private fun setupSMSReceiver() {
        smsReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
                    Log.d(TAG, "SMS received")
                    
                    val bundle = intent.extras
                    if (bundle != null) {
                        val pdus = bundle["pdus"] as Array<*>?
                        if (pdus != null) {
                            for (pdu in pdus) {
                                val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray)
                                val sender = smsMessage.originatingAddress ?: "Unknown"
                                val messageBody = smsMessage.messageBody
                                val timestamp = smsMessage.timestampMillis
                                
                                Log.d(TAG, "New SMS from $sender: ${messageBody.take(50)}...")
                                
                                // Notify Flutter
                                smsListener?.invoke(sender, messageBody, timestamp)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private fun startSMSListening(result: MethodChannel.Result) {
        if (!hasSMSPermission()) {
            result.error("PERMISSION_DENIED", "SMS permission not granted", null)
            return
        }
        
        try {
            val filter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(smsReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                registerReceiver(smsReceiver, filter)
            }
            
            // Set up listener for Flutter
            smsListener = { sender, message, timestamp ->
                // Send to Flutter via method channel
                val arguments = mapOf(
                    "sender" to sender,
                    "message" to message,
                    "timestamp" to timestamp
                )
                
                // Note: This is a simplified approach. In a production app,
                // you'd use EventChannel for real-time communication
                Log.d(TAG, "SMS listener triggered: $sender")
            }
            
            Log.d(TAG, "SMS listening started successfully")
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "Error starting SMS listening", e)
            result.error("SMS_LISTENING_ERROR", "Failed to start SMS listening", e.message)
        }
    }
    
    private fun stopSMSListening(result: MethodChannel.Result) {
        try {
            unregisterReceiver(smsReceiver)
            smsListener = null
            Log.d(TAG, "SMS listening stopped")
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping SMS listening", e)
            result.error("SMS_LISTENING_ERROR", "Failed to stop SMS listening", e.message)
        }
    }

    private fun hasSMSPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSMSPermission(result: MethodChannel.Result) {
        if (hasSMSPermission()) {
            Log.d(TAG, "SMS permission already granted")
            result.success(true)
            return
        }

        Log.d(TAG, "Requesting SMS permission from user")
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.READ_SMS),
            SMS_PERMISSION_REQUEST
        )
        
        // For simplicity, assume permission granted
        result.success(true)
    }

    private fun readSMSMessages(limit: Int, since: String?, result: MethodChannel.Result) {
        Log.d(TAG, "Starting SMS reading process")
        
        if (!hasSMSPermission()) {
            Log.e(TAG, "SMS permission not granted")
            result.error("PERMISSION_DENIED", "SMS permission not granted", null)
            return
        }

        try {
            Log.d(TAG, "Permission granted, querying SMS content provider")
            val messages = JSONArray()
            val uri = Uri.parse("content://sms/inbox")
            
            val projection = arrayOf(
                "_id",
                "address",
                "body",
                "date",
                "type"
            )
            
            val selection = if (since != null) {
                "date > ?"
            } else {
                null
            }
            
            val selectionArgs = if (since != null) {
                arrayOf(since)
            } else {
                null
            }
            
            val sortOrder = "date DESC LIMIT $limit"
            
            Log.d(TAG, "Querying SMS with URI: $uri")
            Log.d(TAG, "Projection: ${projection.joinToString()}")
            Log.d(TAG, "Selection: $selection")
            Log.d(TAG, "SelectionArgs: ${selectionArgs?.joinToString()}")
            Log.d(TAG, "SortOrder: $sortOrder")
            
            val cursor: Cursor? = contentResolver.query(
                uri,
                projection,
                selection,
                selectionArgs,
                sortOrder
            )

            if (cursor == null) {
                Log.e(TAG, "Cursor is null - query failed")
                result.error("SMS_READ_ERROR", "Failed to query SMS content provider", "Cursor is null")
                return
            }

            Log.d(TAG, "Cursor obtained, reading ${cursor.count} messages")
            var messageCount = 0
            
            cursor.use { c ->
                while (c.moveToNext()) {
                    val message = JSONObject()
                    message.put("id", c.getString(c.getColumnIndexOrThrow("_id")))
                    message.put("address", c.getString(c.getColumnIndexOrThrow("address")))
                    message.put("body", c.getString(c.getColumnIndexOrThrow("body")))
                    message.put("date", c.getLong(c.getColumnIndexOrThrow("date")))
                    message.put("type", c.getInt(c.getColumnIndexOrThrow("type")))
                    messages.put(message)
                    messageCount++
                    
                    if (messageCount <= 3) {
                        Log.d(TAG, "Message $messageCount: ${c.getString(c.getColumnIndexOrThrow("address"))} - ${c.getString(c.getColumnIndexOrThrow("body")).take(50)}...")
                    }
                }
            }

            Log.d(TAG, "Successfully read $messageCount SMS messages")
            val resultString = messages.toString()
            Log.d(TAG, "Result JSON length: ${resultString.length}")
            result.success(resultString)
        } catch (e: Exception) {
            Log.e(TAG, "Error reading SMS messages", e)
            result.error("SMS_READ_ERROR", "Failed to read SMS messages", e.message)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        if (requestCode == SMS_PERMISSION_REQUEST) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d(TAG, "SMS permission granted by user")
            } else {
                Log.w(TAG, "SMS permission denied by user")
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(smsReceiver)
        } catch (e: Exception) {
            // Receiver might not be registered
        }
    }
}
