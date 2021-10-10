//+------------------------------------------------------------------+
//|                                                        Basic.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property strict

#include <Values/Variables.mqh>
#include <Notification/Terminal.mqh>


ENUM_CAPITAL_OPEN_RECOMMEND getCapitalRecommend(){
   
   if (OrdersTotal() >= maxOrdersOpened) { return OPEN_NOTHING; }
   
   double priceOpen = (priorityTrend == UP_TREND ? Ask : Bid);
   
   if (!validPrice(priceOpen)) { showLog("invalid price"); return OPEN_NOTHING; }
   
   if (getMinDistanceBefore(priceOpen) >= minDistanceOrdersPip){
      return checkBalance(priceOpen);
   }
   
   return OPEN_NOTHING;
}

ENUM_CAPITAL_OPEN_RECOMMEND checkBalance(double priceOpen){
   int maximalCurrent = maximalLossAllCurrent();
   int maximalNewOrder = maximalLossOne(priceOpen);
   
   showLog(StringFormat("MaximalLossAccept = %d, MaximalCurrent = %d, MaximalNew = %d", maxPipLoss, maximalCurrent, maximalNewOrder));
   
   if ((maximalNewOrder < defaultPipLossAccept) && (maximalCurrent + maximalNewOrder < maxPipLoss)) { return OPEN_DEFAULT; }
   
   if ((maximalNewOrder < smallerPipLossAccept) && (maximalCurrent + maximalNewOrder < maxPipLoss)) { return OPEN_SMALL; }
   
   return OPEN_NOTHING;
}

int getMinDistanceBefore(double priceOpen){
   int minDistance = INT_MAX;
   for (int i=0; i<OrdersTotal(); i++){
      if (OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber){ 
         minDistance = MathMin(minDistance, getDistanceByPip(OrderOpenPrice(), priceOpen));
      }
   }
   return minDistance;
}

int maximalLossOne(double price){
  return MathAbs(price - peakOrBottom) / (Point * 10);
}

int maximalLossAllCurrent(){
   int sum = 0;
   for (int i=0; i<OrdersTotal(); i++){
      if (OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber){ 
         sum += maximalLossOne(OrderOpenPrice()); 
      }
   }
   return sum;
}

void moveStoplossEntry(int ticket) {
   if (OrderSelect(ticket, SELECT_BY_TICKET) && OrderMagicNumber() == magicNumber) {
      if (OrderType() == OP_BUY) {
         if (OrderStopLoss() < OrderOpenPrice()) {
            double stoploss = NormalizeDouble(OrderOpenPrice() + (Point * 2 * 10), Digits);
            if (OrderModify(ticket, OrderOpenPrice(), stoploss, OrderTakeProfit(), 0)){
               showLog("Move stoploss to entry successfully!");
            }
         }
      }
      if (OrderType() == OP_SELL) {
         if (OrderStopLoss() > OrderOpenPrice()) {
            double stoploss = NormalizeDouble(OrderOpenPrice() - (Point * 2 * 10), Digits);
            if (OrderModify(ticket, OrderOpenPrice(), stoploss, OrderTakeProfit(), 0)){
               showLog("Move stoploss to entry successfully!");
            } 
         }
      }
   }
}


bool wasBreakEvenTicket(int ticket){
   if (OrderSelect(ticket, SELECT_BY_TICKET) && OrderMagicNumber() == magicNumber){
      bool breakEvenCurrent = (OrderType() == OP_BUY) && OrderStopLoss() >= OrderOpenPrice();
      return breakEvenCurrent || (OrderType() == OP_SELL && OrderStopLoss() <= OrderOpenPrice());
   }
   return false;
}

void doBreakEven(){
   for (int i=0; i<OrdersTotal(); i++){
      if (OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber) {
         bool wasBreakEvenCurrent = wasBreakEvenTicket(OrderTicket());
         if (!wasBreakEvenCurrent && getProfitAsPip(OrderTicket()) >= pipMovingEntry){
            moveStoplossEntry(OrderTicket());
         }
      }
   }
}

void trailingStoploss(){
   for (int i=0; i<OrdersTotal(); i++){
      if (OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber) {
         if (getProfitAsPip(OrderTicket()) >= pipTrailingStoploss) {
            if ( OrderType() == OP_BUY ) {
               double nextStoploss = NormalizeDouble(Ask - pipTrailingStoploss * 10 * Point, Digits);
               if (OrderStopLoss() < nextStoploss) {
                  OrderModify(OrderTicket(), Ask, nextStoploss, OrderTakeProfit(), 0);
               }
            }
            if ( OrderType() == OP_SELL ) {
               double nextStoploss = NormalizeDouble(Bid + pipTrailingStoploss * 10 * Point, Digits);
               if (OrderStopLoss() > nextStoploss) {
                  OrderModify(OrderTicket(), Bid, nextStoploss, OrderTakeProfit(), 0);
               }
            }
         }
      }
   }
}


bool validPrice(double price){
   if (priorityTrend == UP_TREND && price < peakOrBottom) { return false; }
   if (priorityTrend == DOWN_TREND && price > peakOrBottom) { return false; }
   return true;
}

int getDistanceByPip(double price1, double price2) {
   return MathAbs(price1 - price2) / (Point * 10);
}

int getProfitAsPip(int ticket) {
   if (OrderSelect(ticket, SELECT_BY_TICKET) && OrderMagicNumber() == magicNumber) {
      double difference = (OrderType() == OP_BUY ? Bid - OrderOpenPrice() : OrderOpenPrice() - Ask);
      return difference / (Point * 10);
   }
   return -1;
}

bool isEqual(double a, double b, double ratio=0.00001){
   return MathAbs(a - b) <= ratio;
}

bool isBiggerThan(double a, double b, double ratio=0.00001){
   return a - b > ratio;
}