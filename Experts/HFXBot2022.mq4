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

int                           indexCheck;
int                           markIndex;
ENUM_OPEN_TYPE_RECOMMEND      pinbar;
ENUM_OPEN_TYPE_RECOMMEND      ma;
ENUM_OPEN_TYPE_RECOMMEND      ema200;
ENUM_OPEN_TYPE_RECOMMEND      isAllowedType;
bool                          isMaOk;
bool                          rsiCheck;
bool                          falseSignal;
ENUM_CAPITAL_OPEN_RECOMMEND   capitalRecommend;
double                        closePriceMarkIndex;
double                        currentPriceIndex;
double                        prevPriceIndex;

int OnInit(){ 
   indexCheck = 1;
   isAllowedType = (priorityTrend == UP_TREND ? OPEN_BUY : OPEN_SELL);
   falseSignal = false;
   
   welCome(); 
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){}


void OnTick(){
   
   checkPoint();
   
   doBreakEven();
   
   if (newBarCurrent()) {
      ma                = maRecommend(indexCheck);
      pinbar            = pinbarRecommend(indexCheck);
      
      isMaOk            = (ma != NOTHING);
      
      if (priorityTrend == UP_TREND) {
         rsiCheck = (iRSI(Symbol(), timeFrameUsed, 14, PRICE_CLOSE, indexCheck) < 70.0);
      }
      if (priorityTrend == DOWN_TREND) {
         rsiCheck = (iRSI(Symbol(), timeFrameUsed, 14, PRICE_CLOSE, indexCheck) > 30.0);
      }
      
      if ( isMaOk && rsiCheck ){
         if (isAllowedType == ma) {
            showLog("Signal & trend are the same!");   
            openThisPosition(getCapitalRecommend(), pinbar == ma);
            falseSignal = false;
         } else {
            if (falseSignal == false) {
               showLog("Signal & trend are different! Save mark index!");
               falseSignal = true;
               markIndex = indexCheck;
            }
         }
      }
      
      if (falseSignal) {
         if (markIndex == indexCheck) { markIndex += 1; }
         else {
            closePriceMarkIndex = iClose(Symbol(), timeFrameUsed, markIndex);
            currentPriceIndex = iClose(Symbol(), timeFrameUsed, indexCheck);
            prevPriceIndex = iClose(Symbol(), timeFrameUsed, indexCheck + 1);
            if ( priorityTrend == DOWN_TREND ){
               if ( closePriceMarkIndex < currentPriceIndex ){
                  if (prevPriceIndex < currentPriceIndex) { markIndex += 1; }
                  else {
                     showLog(StringFormat("Open order from mark index: %d", markIndex));
                     openThisPosition(getCapitalRecommend());
                     falseSignal = false;
                  }
               } else {
                  falseSignal = false;
               }
            }
            if ( priorityTrend == UP_TREND ) {
               if ( closePriceMarkIndex > currentPriceIndex ){
                  if (prevPriceIndex > currentPriceIndex) { markIndex += 1; }
                  else {
                     showLog(StringFormat("Open order from mark index: %d", markIndex));
                     openThisPosition(getCapitalRecommend());
                     falseSignal = false;
                  }
               }
               else {
                  falseSignal = false;
               }
            }
         }
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
