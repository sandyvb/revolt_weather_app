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

class BigSky : AppWidgetProvider() {

    private val apiLink: String = "https://api.openweathermap.org/data/2.5/weather?"
    private var coordinates: String = "PARIS"
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
        for (appWidgetId in appWidgetIds) {
            updateWeatherAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        // check for refresh or unit conversion actions
        if (intent.action == "com.revoltwind.bigsky.REFRESH") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.big_sky)
            val appWidgetId = intent.extras!!.getInt("appWidgetId")
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
            getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
        }

        if (intent.action == "com.revoltwind.bigsky.CONVERT") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.big_sky)
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
        val views = RemoteViews(context.packageName, R.layout.big_sky)

        // find user's coords
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
        getLastKnownLocation(context, views, appWidgetId, appWidgetManager)

        // Create an Intent to launch MainActivity
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)
        views.setOnClickPendingIntent(R.id.temperature, pendingIntent)
        views.setOnClickPendingIntent(R.id.iconCondition, pendingIntent)
        views.setOnClickPendingIntent(R.id.revoltTextView, pendingIntent)

        // Create an Intent to refresh data
        val refreshIntent = Intent(context, BigSky::class.java)
        refreshIntent.action = "com.revoltwind.bigsky.REFRESH"
        refreshIntent.putExtra("appWidgetId", appWidgetId)
        val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        views.setOnClickPendingIntent(R.id.updated, refreshPendingIntent)

        // Create an Intent to convert units
        val convertIntent = Intent(context, BigSky::class.java)
        convertIntent.action = "com.revoltwind.bigsky.CONVERT"
        convertIntent.putExtra("appWidgetId", appWidgetId)
        val convertPendingIntent = PendingIntent.getBroadcast(
                context, 0, convertIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
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
        val jsonObjectRequest = JsonObjectRequest(
                Request.Method.GET, url, null, { response ->
            try {
                // load OK - parse data from the loaded JSON
                val mainJSONObject = response.getJSONObject("main")
                val weatherArray = response.getJSONArray("weather")
                val firstWeatherObject = weatherArray.getJSONObject(0)
                // city, condition
                val yourCity = response.getString("name")
                val description = firstWeatherObject.getString("description").capitalize(Locale.ROOT)
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
                views.setTextViewText(R.id.description, description)
                views.setTextViewText(R.id.temperature, temperature)
                views.setTextViewText(R.id.updated, updated)

                // image target view
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

                // update widget
                appWidgetManager.updateAppWidget(appWidgetId, views)

            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        ) {}
        queue.add(jsonObjectRequest)
    }
}
