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
import org.json.JSONException
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import kotlin.math.roundToInt

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
        for (appWidgetId in appWidgetIds) {
            updateWeatherAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        // got a new action, check if it is refresh action
        if (intent.action == "com.revoltwind.forecast5.REFRESH") {
            val appWidgetManager = AppWidgetManager.getInstance(context.applicationContext)
            val views = RemoteViews(context.packageName, R.layout.forecast)
            val appWidgetId = intent.extras!!.getInt("appWidgetId")
            fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)
            getLastKnownLocation(context, views, appWidgetId, appWidgetManager)
        }

        if (intent.action == "com.revoltwind.forecast5.CONVERT") {
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
        views.setOnClickPendingIntent(R.id.forecast_container, pendingIntent)
        views.setOnClickPendingIntent(R.id.revoltTextView, pendingIntent)

        // Create an Intent to refresh data
        val refreshIntent = Intent(context, Forecast::class.java)
        refreshIntent.action = "com.revoltwind.forecast5.REFRESH"
        refreshIntent.putExtra("appWidgetId", appWidgetId)
        val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 0, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        views.setOnClickPendingIntent(R.id.updated, refreshPendingIntent)

        // Create an Intent to convert units
        val convertIntent = Intent(context, Forecast::class.java)
        convertIntent.action = "com.revoltwind.forecast5.CONVERT"
        convertIntent.putExtra("appWidgetId", appWidgetId)
        val convertPendingIntent = PendingIntent.getBroadcast(
                context, 0, convertIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        views.setOnClickPendingIntent(R.id.convert_button, convertPendingIntent)
        views.setOnClickPendingIntent(R.id.convert_c, convertPendingIntent)
        views.setOnClickPendingIntent(R.id.convert_f, convertPendingIntent)
        views.setOnClickPendingIntent(R.id.city, convertPendingIntent)

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

        // get city name
        val urlForecast = "$apiLink$coordinates&exclude=current,minutely,hourly,alerts&APPID=$apiKey&units=$units"
        // get city name
        val url = "$apiLinkName$coordinates&APPID=$apiKey&units=$units"

        // get data
        val nameQueue = Volley.newRequestQueue(context)
        val jsonNameRequest = JsonObjectRequest(
                Request.Method.GET, url, null, { response ->
            try {
                // city name
                val yourCity = response.getString("name")
                // updated
                val weatherTime = response.getString("dt")
                val weatherLong = weatherTime.toLong()
                val formatter =
                        DateTimeFormatter.ofPattern("MM/dd h:mm a")
                val dt = Instant.ofEpochSecond(weatherLong).atZone(ZoneId.systemDefault())
                        .toLocalDateTime().format(formatter).toString()
                val updated = "Updated $dt "
                views.setTextViewText(R.id.city, yourCity)
                views.setTextViewText(R.id.updated, updated)

                appWidgetManager.updateAppWidget(appWidgetId, views)

            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
        ) { }
        nameQueue.add(jsonNameRequest)

        // get forecast data from daily object
        val forecastQueue = Volley.newRequestQueue(context)
        val jsonDailyRequest = JsonObjectRequest(
                Request.Method.GET, urlForecast, null, { response ->
            try {
                // load OK - parse data from the loaded JSON
                for (i in 0..4) {
                    val daily = response.getJSONArray("daily")
                    val weatherObject = daily.getJSONObject(i)

                    // date
                    val dtStringLoop = weatherObject.getString("dt")
                    val weatherLongLoop = dtStringLoop.toLong()
                    val formatterLoop =
                            DateTimeFormatter.ofPattern("MM/dd")
                    val date = Instant.ofEpochSecond(weatherLongLoop).atZone(ZoneId.systemDefault())
                            .toLocalDateTime().format(formatterLoop).toString()
                    // temps
                    val dailyTemps = weatherObject.getJSONObject("temp")
                    val minTemp = dailyTemps.getDouble("min").roundToInt().toString()
                    val maxTemp = dailyTemps.getDouble("max").roundToInt().toString()
                    // description // id
                    val dailyWeatherArray = weatherObject.getJSONArray("weather")
                    val dailyWeather = dailyWeatherArray.getJSONObject(0)
                    val description = dailyWeather.getString("main")
                    val icon = dailyWeather.getString("icon")
                    val pop = (weatherObject.getDouble("pop") * 100).roundToInt()

                    val dateView: Int
                    val descriptionView: Int
                    val lowTempView: Int
                    val highTempView: Int
                    val iconView: Int
                    val popView: Int

                    when (i) {
                        0 -> {
                            dateView = R.id.date0
                            descriptionView = R.id.description0
                            lowTempView = R.id.lowTemp0
                            highTempView = R.id.highTemp0
                            iconView = R.id.iconCondition0
                            popView = R.id.pop0
                        }
                        1 -> {
                            dateView = R.id.date1
                            descriptionView = R.id.description1
                            lowTempView = R.id.lowTemp1
                            highTempView = R.id.highTemp1
                            iconView = R.id.iconCondition1
                            popView = R.id.pop1
                        }
                        2 -> {
                            dateView = R.id.date2
                            descriptionView = R.id.description2
                            lowTempView = R.id.lowTemp2
                            highTempView = R.id.highTemp2
                            iconView = R.id.iconCondition2
                            popView = R.id.pop2
                        }
                        3 -> {
                            dateView = R.id.date3
                            descriptionView = R.id.description3
                            lowTempView = R.id.lowTemp3
                            highTempView = R.id.highTemp3
                            iconView = R.id.iconCondition3
                            popView = R.id.pop3
                        }
                        else -> {
                            dateView = R.id.date4
                            descriptionView = R.id.description4
                            lowTempView = R.id.lowTemp4
                            highTempView = R.id.highTemp4
                            iconView = R.id.iconCondition4
                            popView = R.id.pop4
                        }
                    }

                    // set views
                    views.setTextViewText(dateView, date)
                    views.setTextViewText(descriptionView, description)
                    views.setTextViewText(lowTempView, "$minTemp°")
                    views.setTextViewText(highTempView, "$maxTemp°")
                    views.setTextViewText(popView, "$pop%")

                    val awt: AppWidgetTarget = object : AppWidgetTarget(
                            context.applicationContext,
                            iconView,
                            views,
                            appWidgetId
                    ) {}

                    val iconUrl = "$apiIcon$icon.png"

                    Glide
                            .with(context)
                            .asBitmap()
                            .load(iconUrl)
                            .into(awt)

                }
                appWidgetManager.updateAppWidget(appWidgetId, views)

            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
        ) { }
        forecastQueue.add(jsonDailyRequest)
    }
}
