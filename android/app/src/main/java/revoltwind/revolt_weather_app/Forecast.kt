package revoltwind.revolt_weather_app

import android.Manifest
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.ActivityCompat
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices

class Forecast : AppWidgetProvider() {

    private val apiLink: String = "https://api.openweathermap.org/data/2.5/onecall?"
    private val apiLinkName: String = "https://api.openweathermap.org/data/2.5/weather?"

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
        if (intent.action == "com.revoltwind.forecast.REFRESH") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.forecast)
            val appWidgetId = intent.extras!!.getInt("appWidgetId")
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
            getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
        }
        if (intent.action == "com.revoltwind.forecast.CONVERT") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.forecast)
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
        val views = RemoteViews(context.packageName, R.layout.forecast)

        // Create an Intent to launch MainActivity
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

        // Get the layout for the App Widget and attach an on-click listeners
//        views.setOnClickPendingIntent(R.id.cityName, pendingIntent)
        //TODO: set intents
//        views.setOnClickPendingIntent(R.id.forecast, pendingIntent)

        // Create an Intent to refresh data
        val refreshIntent = Intent(context, Forecast::class.java)
        refreshIntent.action = "com.revoltwind.forecast.REFRESH"
        refreshIntent.putExtra("appWidgetId", appWidgetId)
        // Create pending intent for refresh
        val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set onclick to refresh image view
        views.setOnClickPendingIntent(R.id.updated, refreshPendingIntent)

        // Create an Intent to convert units
        val convertIntent = Intent(context, Forecast::class.java)
        convertIntent.action = "com.revoltwind.forecast.CONVERT"
        convertIntent.putExtra("appWidgetId", appWidgetId)
        // Create pending intent for convert
        val convertPendingIntent = PendingIntent.getBroadcast(
                context, 0, convertIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        // set onclick to convert image view
        views.setOnClickPendingIntent(R.id.convert_button, convertPendingIntent)
//        views.setOnClickPendingIntent(R.id.convert_c, convertPendingIntent)
//        views.setOnClickPendingIntent(R.id.convert_f, convertPendingIntent)

        // find user's coords
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
        getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
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

        // get only daily data
        val urlForecast = "$apiLink$coordinates&exclude=current,minutely,hourly,alerts&APPID=$apiKey&units=$units"
        // get city name
        val url = "$apiLink$coordinates&APPID=$apiKey&units=$units"

        // JSON NAME request with Volley
        val jsonObjectRequest = JsonObjectRequest(
                Request.Method.GET, url, null, { response ->
            try {
                // load OK - parse data from the loaded JSON
                val yourCity = response.getString("name")
                views.setTextViewText(R.id.city, yourCity)
                Log.i("city", "YourCity: $yourCity")

            } catch (e: Exception) {
                e.printStackTrace()
                Log.i("NAME ERROR", "***** error: $e")
            }
            Log.i("city", "$response")
        },
                { error -> Log.i("NAME ERROR", "Error: $error") })

        // start loading data with Volley
        val queue = Volley.newRequestQueue(context)
        queue.add(jsonObjectRequest)

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)


        // JSON object request with Volley
//        val jsonDailyRequest = JsonObjectRequest(
//                Request.Method.GET, urlForecast, null, { response ->
//            try {
//                // load OK - parse data from the loaded JSON
//                val dailyArray = response.getJSONArray("daily")
//                // updated
//                val firstWeatherObject = dailyArray.getJSONObject(0)
//                val dtString = firstWeatherObject.getString("dt")
//                val weatherLong = dtString.toLong()
//                val formatter =
//                        DateTimeFormatter.ofPattern("MM/dd h:mm a")
//                val dt = Instant.ofEpochSecond(weatherLong).atZone(ZoneId.systemDefault())
//                        .toLocalDateTime().format(formatter).toString()
//                val updated = "Updated $dt"
//                views.setTextViewText(R.id.updatedForecast, updated)
//
//                // LOOP
//                val weatherObject = dailyArray.getJSONObject(0)
//                // date
//                val dtStringLoop = weatherObject.getString("dt")
//                val weatherLongLoop = dtStringLoop.toLong()
//                val formatterLoop =
//                        DateTimeFormatter.ofPattern("MM/dd")
//                val date = Instant.ofEpochSecond(weatherLongLoop).atZone(ZoneId.systemDefault())
//                        .toLocalDateTime().format(formatterLoop).toString()
//                // temps
//                val dailyTemps = weatherObject.getJSONObject("temp")
//                val minTemp = dailyTemps.getDouble("min").toInt().toString()
//                val maxTemp = dailyTemps.getDouble("max").toInt().toString()
//                // description // id
//                val dailyWeatherArray = weatherObject.getJSONArray("weather")
//                val dailyWeather = dailyWeatherArray.getJSONObject(0)
//                val description = dailyWeather.getString("main")
//                val icon = dailyWeather.getString("icon")
//
//                views.setTextViewText(R.id.cityName, "HELP")
//
////                    views.setTextViewText(R.id.date0, date)
////                    views.setTextViewText(R.id.description0, description)
////                    views.setTextViewText(R.id.lowTemp0, minTemp)
////                    views.setTextViewText(R.id.highTemp0, maxTemp)
////                    val awt: AppWidgetTarget = object : AppWidgetTarget(
////                            context.applicationContext,
////                            R.id.iconCondition0,
////                            views,
////                            appWidgetId
////                    ) {}
////
////                    val iconUrl = "$apiIcon$icon.png"
////
////                    Glide
////                            .with(context)
////                            .asBitmap()
////                            .load(iconUrl)
////                            .into(awt)
//
//            } catch (e: Exception) {
//                e.printStackTrace()
//                Log.i("DAILY ERROR", "***** error: $e")
//            }
//        },
//                { error -> Log.i("DAILY ERROR", "Error: $error") })


        // start loading data with Volley
//        val queue = Volley.newRequestQueue(context)
//        queue.add(jsonDailyRequest)
//        queue.add(jsonNameRequest)

        // Instruct the widget manager to update the widget
//        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
