//+------------------------------------------------------------------+
//|                                                        Basic.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Values/Variables.mqh>

bool newBarCurrent(){
   if (timeFrameUsed == PERIOD_H1) { return newHourlyBar(); }
   if (timeFrameUsed == PERIOD_H4) { return newFourlyBar(); }
   if (timeFrameUsed == PERIOD_D1) { return newDailyBar(); }
   return false;
}

bool newHourlyBar() {
   static datetime lastHourlyBar;
   datetime curBar = iTime(Symbol(), PERIOD_H1, 0);
   if (lastHourlyBar != curBar){
      lastHourlyBar = curBar; 
      return true;
   }
   return false;
}

bool newFourlyBar() {
   static datetime lastFourlyBar;
   datetime curBar = iTime(Symbol(), PERIOD_H4, 0);
   if (lastFourlyBar != curBar){
      lastFourlyBar = curBar; 
      return true;
   }
   return false;
}

bool newDailyBar() {
   static datetime lastDailyBar;
   datetime curBar = iTime(Symbol(), PERIOD_D1, 0);
   if (lastDailyBar != curBar){
      lastDailyBar = curBar; 
      return true;
   }
   return false;
}

bool newWeeklyBar() {
   static datetime lastWeeklyBar;
   datetime curBar = iTime(Symbol(), PERIOD_W1, 0);
   if (lastWeeklyBar != curBar){
      lastWeeklyBar = curBar; 
      return true;
   }
   return false;
}

bool isLongBar(int compareWithBefore=21) {
   double sum = 0;
   for (int i=1; i<=compareWithBefore; i++) { sum += High[i] - Low[i]; }
   return sum / compareWithBefore < High[1] - Low[1];
}

bool isShortBar(int compareWithBefore=21) {
   double sum = 0;
   for (int i=1; i<=compareWithBefore; i++) { sum += High[i] - Low[i]; }
   return sum / compareWithBefore > High[1] - Low[1];
}