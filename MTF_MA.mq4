//+------------------------------------------------------------------+
//|                                                       MTF_MA.mq4 |
//| 				                      Copyright © 2019, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "EarnForex.com"
#property link      "https://www.earnforex.com/"
#property version   "1.00"
#property strict

#property description "Displays a higher timeframe moving average on a lower timeframe chart."

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots 1
#property indicator_width1 1 
#property indicator_color1 clrRed
#property indicator_type1 DRAW_LINE
#property indicator_style1 STYLE_SOLID  

input ENUM_TIMEFRAMES MA_TF = PERIOD_H1; // MA Timeframe
input int MA_Period = 14; // MA Period
input int MA_Shift = 0; // MA Shift
input ENUM_MA_METHOD MA_Method = MODE_EMA; // MA Method
input ENUM_APPLIED_PRICE MA_Applied_Price = PRICE_CLOSE; // MA Applied Price

double MABuf[];

void OnInit()
{
   if (MA_TF < Period()) Alert("MA Timeframe should be greater or equal to the chart timeframe.");
   SetIndexBuffer(0, MABuf);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0);
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, MA_Period);
   IndicatorSetString(INDICATOR_SHORTNAME, "MTF MA (" + IntegerToString(MA_Period) + ") @ " + EnumToString(MA_TF));
}

int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[]
)
{
   int counted_bars = IndicatorCounted();
   if (counted_bars < 0) return(0);
   if (counted_bars > 0) counted_bars--;
   
   int limit = Bars - counted_bars;
   
   // Always recalculate for the current bar (on higher timeframe).
   limit += MA_TF / Period();
   if (limit > Bars - 1) limit = Bars - 1;
   
   for (int i = limit; i >= 0; i--)
   {
      int shift = iBarShift(NULL, MA_TF, Time[i], true);
      if (shift == -1) continue;
      MABuf[i] = iMA(NULL, MA_TF, MA_Period, MA_Shift, MA_Method, MA_Applied_Price, shift);
   }
   
   return(rates_total);
}