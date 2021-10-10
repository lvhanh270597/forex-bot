//+------------------------------------------------------------------+
//|                                                  PriceAction.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Charts/Normal.mqh>
#include <Values/Variables.mqh>


ENUM_OPEN_TYPE_RECOMMEND pinbarRecommend(int index){
   double belowTail, aboveTail, body;
   double openPrice        = iOpen(Symbol(), timeFrameUsed, index);
   double closePrice       = iClose(Symbol(), timeFrameUsed, index);
   double lowPrice         = iLow(Symbol(), timeFrameUsed, index);
   double highPrice        = iHigh(Symbol(), timeFrameUsed, index);
   double lowBeforePrice   = iLow(Symbol(), timeFrameUsed, index + 1);
   double highBeforePrice  = iHigh(Symbol(), timeFrameUsed, index + 1);
   
   bool pinbarInsideBefore = (lowBeforePrice <= lowPrice && highBeforePrice >= highPrice);
   
   // Check the bullish pinbar
   belowTail = MathMin(openPrice, closePrice) - lowPrice;
   body = highPrice - lowPrice - belowTail; 
   if (!pinbarInsideBefore && belowTail > pinbarRatio * body ) { return OPEN_BUY; }

   //Check the bearish pinbar
   aboveTail = highPrice - MathMax(openPrice, closePrice);
   body = highPrice - lowPrice - aboveTail; 
   if (!pinbarInsideBefore && aboveTail > pinbarRatio * body){ return OPEN_SELL; }

   return NOTHING;
}

ENUM_OPEN_TYPE_RECOMMEND pinbarRecommendTimeFrame(ENUM_TIMEFRAMES timeFrame, int index){
   double belowTail, aboveTail, body;
   double openPrice        = iOpen(Symbol(), timeFrame, index);
   double closePrice       = iClose(Symbol(), timeFrame, index);
   double lowPrice         = iLow(Symbol(), timeFrame, index);
   double highPrice        = iHigh(Symbol(), timeFrame, index);
   double lowBeforePrice   = iLow(Symbol(), timeFrame, index + 1);
   double highBeforePrice  = iHigh(Symbol(), timeFrame, index + 1);
   
   bool pinbarInsideBefore = (lowBeforePrice <= lowPrice && highBeforePrice >= highPrice);
   
   // Check the bullish pinbar
   belowTail = MathMin(openPrice, closePrice) - lowPrice;
   body = highPrice - lowPrice - belowTail; 
   if (!pinbarInsideBefore && belowTail > pinbarRatio * body ) { return OPEN_BUY; }

   //Check the bearish pinbar
   aboveTail = highPrice - MathMax(openPrice, closePrice);
   body = highPrice - lowPrice - aboveTail; 
   if (!pinbarInsideBefore && aboveTail > pinbarRatio * body){ return OPEN_SELL; }

   return NOTHING;
}

ENUM_OPEN_TYPE_RECOMMEND pinbarRecommendExtension(int index){
   ENUM_OPEN_TYPE_RECOMMEND pinbarD1 = pinbarRecommendTimeFrame(PERIOD_D1, index);
   ENUM_OPEN_TYPE_RECOMMEND pinbarH4 = pinbarRecommendTimeFrame(PERIOD_H4, index);
   ENUM_OPEN_TYPE_RECOMMEND pinbarH1 = pinbarRecommendTimeFrame(PERIOD_H1, index);
   if (pinbarD1 != NOTHING) { return pinbarD1; }
   if (pinbarH4 != NOTHING) { return pinbarH4; }
   if (pinbarH1 != NOTHING) { return pinbarH1; }
   return NOTHING;
}


ENUM_OPEN_TYPE_RECOMMEND maRecommend(int index){
   double EMA20 = iMA(Symbol(), timeFrameUsed, 20, index, MODE_EMA, PRICE_CLOSE, 0);
   double EMA50 = iMA(Symbol(), timeFrameUsed, 50, index, MODE_EMA, PRICE_CLOSE, 0);
   double EMA200 = iMA(Symbol(), timeFrameUsed, 200, index, MODE_EMA, PRICE_CLOSE, 0);
   
   // Body touched
   double lowPrice         = iLow(Symbol(), timeFrameUsed, index);
   double highPrice        = iHigh(Symbol(), timeFrameUsed, index);
   double closePrice       = iClose(Symbol(), timeFrameUsed, index);
   
   bool touchedEMA20       = (highPrice >= EMA20 && lowPrice <= EMA20);
   bool touchedEMA50       = (highPrice >= EMA50 && lowPrice <= EMA50);
   bool touchedEMA200      = (highPrice >= EMA200 && lowPrice <= EMA200);
   bool touchedEMA         = (touchedEMA20 || touchedEMA50 || touchedEMA200);
   
   if (touchedEMA && (EMA20 < EMA50) && (EMA20 < EMA200)) { return OPEN_SELL; }
   if (touchedEMA && (EMA20 > EMA50) && (EMA20 > EMA200)) { return OPEN_BUY; }
   return NOTHING;
}

ENUM_OPEN_TYPE_RECOMMEND ema200DailyRecommend(int index){
   double EMA200 = iMA(Symbol(), PERIOD_D1, 200, index, MODE_EMA, PRICE_CLOSE, 0);
   double closePrice = iClose(Symbol(), PERIOD_D1, index);
   if (closePrice > EMA200) return OPEN_BUY;
   if (closePrice < EMA200) return OPEN_SELL;
   return NOTHING;
}

ENUM_OPEN_TYPE_RECOMMEND sma21DailyRecommend(int index){
   double SMA21 = iMA(Symbol(), PERIOD_D1, 21, index, MODE_SMA, PRICE_CLOSE, 0);
   double closePrice = iClose(Symbol(), PERIOD_D1, index);
   if (closePrice > SMA21) return OPEN_BUY;
   if (closePrice < SMA21) return OPEN_SELL;
   return NOTHING;
}

ENUM_OPEN_TYPE_RECOMMEND ema50DailyRecommend(int index){
   double EMA50 = iMA(Symbol(), PERIOD_D1, 50, index, MODE_EMA, PRICE_CLOSE, 0);
   double closePrice = iClose(Symbol(), PERIOD_D1, index);
   if (closePrice > EMA50) return OPEN_BUY;
   if (closePrice < EMA50) return OPEN_SELL;
   return NOTHING;
}

ENUM_OPEN_TYPE_RECOMMEND ema21DailyRecommend(int index){
   double EMA21 = iMA(Symbol(), PERIOD_D1, 21, index, MODE_EMA, PRICE_CLOSE, 0);
   double closePrice = iClose(Symbol(), PERIOD_D1, index);
   if (closePrice > EMA21) return OPEN_BUY;
   if (closePrice < EMA21) return OPEN_SELL;
   return NOTHING;
}