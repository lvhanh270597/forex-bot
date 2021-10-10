//+------------------------------------------------------------------+
//|                                                        Total.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Notification/Terminal.mqh>
#include <Notification/Telegram.mqh>

const string welcomeString = "Bot restarted!";

void sendBoth(string text){
   showLog(text);
   if (externalNoti) { sendMessage(text); }
}

void welCome(){
   sendBoth(welcomeString);
}