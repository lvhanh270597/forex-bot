//+------------------------------------------------------------------+
//|                                                   HFXBot2021.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include <Values/Variables.mqh>
#include <Notification/Terminal.mqh>
#include <Notification/CheckPoint.mqh>
#include <Notification/Telegram.mqh>
#include <Capital/Normal.mqh>
#include <Signal/PriceAction.mqh>
#include <Order/Normal.mqh>


int                           indexCheck = 1;
ENUM_OPEN_TYPE_RECOMMEND      pinbar;
ENUM_OPEN_TYPE_RECOMMEND      ema21;
ENUM_OPEN_TYPE_RECOMMEND      ema200;
bool                          isPinbarOk;
bool                          isEma21Ok;
bool                          shouldBuy;
bool                          shouldSell;
bool                          preCheck;
ENUM_CAPITAL_OPEN_RECOMMEND   capitalRecommend;


int OnInit(){ 
   welCome(); 
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){}

void OnTick(){
   
   checkPoint();
   
   doBreakEven();
   
   if (newBarCurrent()) {
   
      pinbar         = pinbarRecommend(indexCheck);
      ema21          = ema21DailyRecommend(indexCheck);
      
      isPinbarOk     = (pinbar != NOTHING);
      isEma21Ok      = (ema21  != NOTHING);
      
      shouldBuy      = (pinbar == OPEN_BUY   && ema21 == OPEN_BUY); 
      shouldSell     = (pinbar == OPEN_SELL  && ema21 == OPEN_SELL);
      
      if (isPinbarOk && isEma21Ok && (pinbar == ema21)) {
         showLog(StringFormat("pinbar and ema21 recommend: %s", (pinbar == OPEN_BUY ? "BUY" : "SELL")));
         
         preCheck = (shouldBuy && priorityTrend == UP_TREND) || (shouldSell && priorityTrend == DOWN_TREND);
         
         if (shouldBuy && priorityTrend == UP_TREND) {
            if (considerRSI) {
               preCheck = (iRSI(Symbol(), timeFrameUsed, 14, PRICE_CLOSE, indexCheck) < 70.0);
            }
         }
         if (shouldSell && priorityTrend == DOWN_TREND) {
            if (considerRSI) {
               preCheck = (iRSI(Symbol(), timeFrameUsed, 14, PRICE_CLOSE, indexCheck) > 30.0);
            }
         }
         
         if (preCheck) { openThisPosition( getCapitalRecommend() ); }
      }
      
   }
   
   trailingStoploss();
   
   if ( newWeeklyBar() ) {
      ema200 = ema200DailyRecommend(indexCheck);
      if ((ema200 == OPEN_SELL && priorityTrend == UP_TREND) || (ema200 == OPEN_BUY && priorityTrend == DOWN_TREND)) {
         sendBoth("Trend is opposite!");
      }
   }
   

}
//+------------------------------------------------------------------+
