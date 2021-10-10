//+------------------------------------------------------------------+
//|                                                        Basic.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include <Values/Variables.mqh>
#include <Notification/Total.mqh>

void openThisPosition(ENUM_CAPITAL_OPEN_RECOMMEND recommendation, bool doubleVolume=false){
   if (recommendation == OPEN_NOTHING) { return ; }
   
   double priceOpen  = (priorityTrend == UP_TREND ? Ask : Bid);
   double takeprofit = (pipTakeProfit == 0 ? 0 : NormalizeDouble(priceOpen + (priorityTrend == UP_TREND ? +1.0 : -1.0) * pipTakeProfit * 10 * Point, Digits));
   int type          = (priorityTrend == UP_TREND ? OP_BUY : OP_SELL);
   double volume     = (recommendation == OPEN_DEFAULT ? volumeDefault : volumeSmaller);
   volume            = (doubleVolume ? volume * 2 : volume);
   double stoploss   = peakOrBottom;
   
   int ticket = OrderSend(Symbol(), type, volume, priceOpen, 3, stoploss, takeprofit, NULL, magicNumber);
   if (ticket > 0) {
      sendBoth(StringFormat("Opened %s at price: %1.4f with volume: %1.2f", (priorityTrend == UP_TREND ? "BUY" : "SELL"), NormalizeDouble(priceOpen, Digits - 1), NormalizeDouble(volume, 2))); 
   }
   else {
      sendBoth("Open order failed!");
   }
}

void closePositions(int Operator){
   string ope = Operator == OP_BUY ? "buy" : "sell";
   for (int i=0; i<OrdersTotal(); i++){
      if (OrderSelect(i, SELECT_BY_POS) && (OrderMagicNumber() == magicNumber)) {
         if (OrderType() == Operator) {
            OrderClose(OrderTicket(), OrderLots(), Operator == OP_BUY ? Bid : Ask, 3);
         }
      }
   }
}