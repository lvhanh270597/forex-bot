//+------------------------------------------------------------------+
//|                                                   CheckPoint.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Values/Variables.mqh>
#include <Notification/Terminal.mqh>
#include <Notification/Total.mqh>

int                           tickets[50];
int                           ticketCount = 0;


void checkPoint(){
   for (int i=0; i<ticketCount; i++){
      if (OrderSelect(tickets[i], SELECT_BY_TICKET) && OrderCloseTime() != 0) {
         sendBoth(StringFormat("Ticket %d was closed with profit: %1.2f$! Balance: %1.2f$", tickets[i], NormalizeDouble(OrderProfit(), 2), NormalizeDouble(AccountBalance(), 2)));
      }
   }
   
   ticketCount = 0;
   for (int i=0; i<OrdersTotal(); i++){
      if (OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magicNumber) {
         tickets[ticketCount++] = OrderTicket();
      }
   }
}