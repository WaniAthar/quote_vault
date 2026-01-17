package com.example.quote_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class QuoteWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val quoteId = widgetData.getString("quote_id", "")
                val quoteText = widgetData.getString("quote_text", "Open App to see Quote of the Day")
                val quoteAuthor = widgetData.getString("quote_author", "")

                setTextViewText(R.id.widget_quote_text, quoteText)
                setTextViewText(R.id.widget_author, quoteAuthor)

                // Create intent to open the app with deep link
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("quotevault://quote?id=$quoteId")
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
