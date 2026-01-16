package com.example.quote_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
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
                val quoteText = widgetData.getString("quote_text", "Open App to see Quote of the Day")
                val quoteAuthor = widgetData.getString("quote_author", "")

                setTextViewText(R.id.widget_quote_text, quoteText)
                setTextViewText(R.id.widget_author, quoteAuthor)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}