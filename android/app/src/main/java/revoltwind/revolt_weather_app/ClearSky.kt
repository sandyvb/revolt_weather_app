package revoltwind.revolt_weather_app

import android.Manifest
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.ActivityCompat
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.AppWidgetTarget
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.*

class ClearSky : AppWidgetProvider() {

    private val apiLink: String = "https://api.openweathermap.org/data/2.5/weather?"
    private var coordinates: String = "SOMEWHERE"
    private val apiIcon: String = "https://revoltwind.com/icons/"
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

        // got a new action, check if it is refresh action
        if (intent.action == "com.revoltwind.clearsky.REFRESH") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.clear_sky)
            val appWidgetId = intent.extras!!.getInt("appWidgetId")
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
            getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
        }
        if (intent.action == "com.revoltwind.clearsky.CONVERT") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.clear_sky)
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
        val views = RemoteViews(context.packageName, R.layout.clear_sky)

        // find user's coords
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
        getLastKnownLocation(context, views, appWidgetId, appWidgetManager)

        // Create an Intent to launch MainActivity
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

        // Get the layout for the App Widget and attach an on-click listeners
        views.setOnClickPendingIntent(R.id.city, pendingIntent)
        views.setOnClickPendingIntent(R.id.temperature, pendingIntent)
        views.setOnClickPendingIntent(R.id.iconCondition, pendingIntent)
        views.setOnClickPendingIntent(R.id.revoltTextView, pendingIntent)

        // Create an Intent to refresh data
        val refreshIntent = Intent(context, ClearSky::class.java)
        refreshIntent.action = "com.revoltwind.clearsky.REFRESH"
        refreshIntent.putExtra("appWidgetId", appWidgetId)
        // Create pending intent for refresh
        val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set onclick to refresh image view
        views.setOnClickPendingIntent(R.id.updated, refreshPendingIntent)

        // Create an Intent to convert units
        val convertIntent = Intent(context, ClearSky::class.java)
        convertIntent.action = "com.revoltwind.clearsky.CONVERT"
        convertIntent.putExtra("appWidgetId", appWidgetId)
        // Create pending intent for convert
        val convertPendingIntent = PendingIntent.getBroadcast(
                context, 0, convertIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set onclick to convert image view
        views.setOnClickPendingIntent(R.id.convert_button, convertPendingIntent)
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

        val url = "$apiLink$coordinates&APPID=$apiKey&units=$units"

        // JSON object request with Volley
        val jsonObjectRequest = JsonObjectRequest(
                Request.Method.GET, url, null, { response ->
            try {
                // load OK - parse data from the loaded JSON
                val mainJSONObject = response.getJSONObject("main")
                val weatherArray = response.getJSONArray("weather")
                val firstWeatherObject = weatherArray.getJSONObject(0)
                // city, condition
                val yourCity = response.getString("name")
                val main = firstWeatherObject.getString("main").capitalize(Locale.ROOT)
                // temperature
                val tempString = mainJSONObject.getString("temp").toDouble().toInt()
                val temperature = if (isMetric) {
                    "$tempString°C"
                } else {
                    "$tempString°F"
                }
                // time
                val weatherTime = response.getString("dt")
                val weatherLong = weatherTime.toLong()
                val formatter =
                        DateTimeFormatter.ofPattern("MM/dd h:mm a")
                val dt = Instant.ofEpochSecond(weatherLong).atZone(ZoneId.systemDefault())
                        .toLocalDateTime().format(formatter).toString()
                val updated = "Updated $dt "

                // set texts to textViews and load icon with Glide
                views.setTextViewText(R.id.city, yourCity)
                views.setTextViewText(R.id.description, main)
                views.setTextViewText(R.id.temperature, temperature)
                views.setTextViewText(R.id.updated, updated)

                // set toggle button image
                val toggleIcon = if (isMetric) R.drawable.ic_toggle_on else R.drawable.ic_toggle_off
                views.setImageViewResource(R.id.convert_button, toggleIcon)

                // AppWidgetTarget will be used with Glide - image target view
                val awt: AppWidgetTarget = object : AppWidgetTarget(
                        context.applicationContext,
                        R.id.iconCondition,
                        views,
                        appWidgetId
                ) {}

                val weatherIcon = firstWeatherObject.getString("icon")
                val iconUrl = "$apiIcon$weatherIcon.png"

                Glide
                        .with(context)
                        .asBitmap()
                        .load(iconUrl)
                        .into(awt)

            } catch (e: Exception) {
                e.printStackTrace()
                Log.i("WEATHER", "***** error: $e")
            }
        },
                { error -> Log.i("ERROR", "Error: $error") })

        // start loading data with Volley
        val queue = Volley.newRequestQueue(context)
        queue.add(jsonObjectRequest)

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}