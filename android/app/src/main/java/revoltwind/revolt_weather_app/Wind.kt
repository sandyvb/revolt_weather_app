package revoltwind.revolt_weather_app

import android.Manifest
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.os.Bundle
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.ActivityCompat
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import org.json.JSONException
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import kotlin.math.roundToInt


class Wind : AppWidgetProvider() {

    private val apiLink: String = "https://api.openweathermap.org/data/2.5/weather?"
    private var coordinates: String = "PARIS"
    private val apiKey = "217da33042b65b3c9e4bd01ab0bdd02b"
    private val mSharedPrefFile: String = "com.revoltwind.appwidgets"


    // find user's coords
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateWeatherAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        //check if it is refresh action or convert action
        if (intent.action == "com.revoltwind.wind.REFRESH") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.wind)
            val appWidgetId = intent.extras!!.getInt("appWidgetId")
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
            getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
        }

        if (intent.action == "com.revoltwind.wind.CONVERT") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.wind)
            val appWidgetId = intent.extras!!.getInt("appWidgetId")

            // set and/or change preferred unit
            val prefs = context.getSharedPreferences(mSharedPrefFile, 0)
            val isMetric = prefs.getBoolean("$appWidgetId", false)
            val prefEditor = prefs.edit()
            prefEditor.putBoolean("$appWidgetId", !isMetric)
            prefEditor.apply()

            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
            getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
        }
    }

    private fun updateWeatherAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
    ) {
        // Construct the RemoteViews object
        val views = RemoteViews(context.packageName, R.layout.wind)

        // find user's coords (then loadWeatherForecast)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
        getLastKnownLocation(context, views, appWidgetId, appWidgetManager)

        // Create an Intent to launch MainActivity
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)
        // set onclick to launch MainActivity
        views.setOnClickPendingIntent(R.id.wind_direction, pendingIntent)
        views.setOnClickPendingIntent(R.id.wind_speed, pendingIntent)
        views.setOnClickPendingIntent(R.id.speed_units, pendingIntent)
        views.setOnClickPendingIntent(R.id.revoltTextView, pendingIntent)

        // Create an Intent to refresh data
        val refreshIntent = Intent(context, Wind::class.java)
        refreshIntent.action = "com.revoltwind.wind.REFRESH"
        refreshIntent.putExtra("appWidgetId", appWidgetId)
        val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set onclick to refresh widget
        views.setOnClickPendingIntent(R.id.updated, refreshPendingIntent)

        // Create an Intent to convert units
        val convertIntent = Intent(context, Wind::class.java)
        convertIntent.action = "com.revoltwind.wind.CONVERT"
        convertIntent.putExtra("appWidgetId", appWidgetId)
        val convertPendingIntent = PendingIntent.getBroadcast(
                context, 0, convertIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set onclick to convert units
        views.setOnClickPendingIntent(R.id.convert_button, convertPendingIntent)
        views.setOnClickPendingIntent(R.id.city, convertPendingIntent)
    }

    private fun getLastKnownLocation(
            context: Context,
            views: RemoteViews,
            appWidgetId: Int,
            appWidgetManager: AppWidgetManager
    ) {
        if (ActivityCompat.checkSelfPermission(
                        context,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
        ) {
            Log.i("coords", "User has no permissions")
            return
        } else {
            fusedLocationClient.lastLocation.addOnSuccessListener {
                if (it != null) {
                    coordinates = "lat=${it.latitude}&lon=${it.longitude}"
                    loadWeatherForecast(coordinates, context, views, appWidgetId, appWidgetManager)
                }
            }
        }
    }

    // resize widget
    override fun onAppWidgetOptionsChanged(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetId: Int, newOptions: Bundle?) {
        if (context != null) {
            val views = RemoteViews(context.packageName, R.layout.wind)
            val minHeight = newOptions?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)
            val maxHeight = newOptions?.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT)

            if (maxHeight != null && minHeight != null) {
                if (maxHeight in 0..180 || minHeight in 0..180) {
                    views.setViewVisibility(R.id.city, View.GONE)
                    views.setViewVisibility(R.id.convert_button, View.GONE)
                    views.setViewVisibility(R.id.revoltTextView, View.GONE)
                    views.setTextViewTextSize(R.id.wind_speed, TypedValue.COMPLEX_UNIT_SP, 35F)
                }

                if (maxHeight > 180 || minHeight > 180) {
                    views.setViewVisibility(R.id.revoltTextView, View.VISIBLE)
                    views.setViewVisibility(R.id.city, View.VISIBLE)
                    views.setViewVisibility(R.id.convert_button, View.VISIBLE)
                    views.setTextViewTextSize(R.id.wind_speed, TypedValue.COMPLEX_UNIT_SP, 42F)
                }
            }
            appWidgetManager?.updateAppWidget(appWidgetId, views)
        }
    }

    private fun loadWeatherForecast(
            coordinates: String,
            context: Context,
            views: RemoteViews,
            appWidgetId: Int,
            appWidgetManager: AppWidgetManager
    ) {
        // get unit preference or set to default value
        val prefs = context.getSharedPreferences(mSharedPrefFile, 0)
        val isMetric = prefs.getBoolean("$appWidgetId", false)
        val units = if (isMetric) "metric" else "imperial"
        // set toggle button image
        val toggleIcon = if (isMetric) R.drawable.ic_toggle_on else R.drawable.ic_toggle_off
        views.setImageViewResource(R.id.convert_button, toggleIcon)

        // owm url
        val url = "$apiLink$coordinates&APPID=$apiKey&units=$units"

        // get data
        val queue = Volley.newRequestQueue(context)
        val jsonObjectRequest = JsonObjectRequest(Request.Method.GET, url, null,
                { response ->
                    try {
                        // city
                        val yourCity = response.getString("name")
                        // wind
                        val windObject = response.getJSONObject("wind")
                        val windSpeed = windObject.getDouble("speed").roundToInt()
                        val windDeg = windObject.getInt("deg")
                        val speedUnits = if (isMetric) "m/s" else "mph"
                        // time
                        val weatherTime = response.getString("dt")
                        val weatherLong = weatherTime.toLong()
                        val formatter = DateTimeFormatter.ofPattern("MM/dd h:mm a")
                        val dt = Instant.ofEpochSecond(weatherLong).atZone(ZoneId.systemDefault())
                                .toLocalDateTime().format(formatter).toString()
                        val updated = "Updated $dt"

                        // set views
                        views.setTextViewText(R.id.city, yourCity)
                        views.setTextViewText(R.id.wind_speed, windSpeed.toString())
                        views.setTextViewText(R.id.speed_units, speedUnits)
                        views.setTextViewText(R.id.updated, updated)

                        // rotate arrow icon to reflect wind direction
                        val bmpOriginal: Bitmap = BitmapFactory.decodeResource(context.applicationContext.resources, R.drawable.arrow)
                        val bmpResult = Bitmap.createBitmap(bmpOriginal.width, bmpOriginal.height, Bitmap.Config.ARGB_8888)
                        val tempCanvas = Canvas(bmpResult)
                        tempCanvas.rotate(windDeg.toFloat(), bmpOriginal.width / 2.toFloat(), bmpOriginal.height / 2.toFloat())
                        tempCanvas.drawBitmap(bmpOriginal, 0f, 0f, null)
                        views.setImageViewBitmap(R.id.wind_direction, bmpResult)

                        // update widget
                        appWidgetManager.updateAppWidget(appWidgetId, views)

                    } catch (e: JSONException) {
                        e.printStackTrace()
                        Log.i("city", "error: $e ")
                    }
                }
        ) { }
        queue.add(jsonObjectRequest)
    }
}
