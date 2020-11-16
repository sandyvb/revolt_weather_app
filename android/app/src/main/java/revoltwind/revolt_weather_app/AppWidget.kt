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

// in manifest:
//  <uses-permission android:name="android.permission.INTERNET" />
//  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" /> ????
//  <action android:name="com.example.weatherapp.REFRESH"/>


class AppWidget : AppWidgetProvider() {

    companion object {
        private const val API_LINK: String = "https://api.openweathermap.org/data/2.5/weather?"
        private var COORDINATES: String = "SOMEWHERE"
        private const val API_ICON: String = "https://openweathermap.org/img/wn/"
        private const val API_KEY = "217da33042b65b3c9e4bd01ab0bdd02b"
    }

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
        if (intent.action == "com.revoltwind.appwidget.REFRESH") {
            // get manager
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            // get views
            val views = RemoteViews(context.packageName, R.layout.app_widget)
            // get appWidgetId
            val appWidgetId = intent.extras!!.getInt("appWidgetId")
            // find user's coords
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
        val views = RemoteViews(context.packageName, R.layout.app_widget)

        // find user's coords
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
        getLastKnownLocation(context, views, appWidgetId, appWidgetManager)

        // Create an Intent to launch MainActivity
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

        // Get the layout for the App Widget and attach an on-click listeners
        views.setOnClickPendingIntent(R.id.cityTextView, pendingIntent)
        views.setOnClickPendingIntent(R.id.tempTextView, pendingIntent)
        views.setOnClickPendingIntent(R.id.iconImageView, pendingIntent)

        // Create an Intent to refresh data
        val refreshIntent = Intent(context, AppWidget::class.java)
        refreshIntent.action = "com.revoltwind.appwidget.REFRESH"
        refreshIntent.putExtra("appWidgetId", appWidgetId)
        // Create pending intent for refresh
        val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set pending refresh intent to refresh image view
        views.setOnClickPendingIntent(R.id.timeTextView, refreshPendingIntent)
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
                    Log.i("coords", "location is: ${it.latitude}, ${it.longitude}")
                    COORDINATES = "lat=${it.latitude}&lon=${it.longitude}"
                    Log.i("coords", COORDINATES)
                    loadWeatherForecast(COORDINATES, context, views, appWidgetId, appWidgetManager)
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
        // URL to load forecast by coordinates
        val url = "$API_LINK$coordinates&APPID=$API_KEY&units=imperial"
        Log.i("coords", url)

        // JSON object request with Volley
        val jsonObjectRequest = JsonObjectRequest(
                Request.Method.GET, url, null, { response ->
            try {
                // load OK - parse data from the loaded JSON
                val mainJSONObject = response.getJSONObject("main")
                val weatherArray = response.getJSONArray("weather")
                val firstWeatherObject = weatherArray.getJSONObject(0)
                // city, condition, temperature
                val yourCity = response.getString("name")
                val condition = firstWeatherObject.getString("description")

                val temperatureString = mainJSONObject.getString("temp")
                val tempNumber = temperatureString.toDouble().toInt()
                val temperature = "$tempNumber °F"
//                    val temperature = mainJSONObject.getString("temp") + " °C"
                // time
                val weatherTime = response.getString("dt")
                val weatherLong = weatherTime.toLong()
                val formatter =
                        DateTimeFormatter.ofPattern("MM/dd h:mm a")
                val dt = Instant.ofEpochSecond(weatherLong).atZone(ZoneId.systemDefault())
                        .toLocalDateTime().format(formatter).toString()
                val updated = "Updated $dt "


                // set texts to textViews and load icon with Glide
                views.setTextViewText(R.id.cityTextView, yourCity)
                views.setTextViewText(R.id.condTextView, condition)
                views.setTextViewText(R.id.tempTextView, temperature)
                views.setTextViewText(R.id.timeTextView, updated)

                // AppWidgetTarget will be used with Glide - image target view
                val awt: AppWidgetTarget = object : AppWidgetTarget(
                        context.applicationContext,
                        R.id.iconImageView,
                        views,
                        appWidgetId
                ) {}
                val weatherIcon = firstWeatherObject.getString("icon")
                val iconUrl = "$API_ICON$weatherIcon@4x.png"

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
