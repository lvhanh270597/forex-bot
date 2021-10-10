//+------------------------------------------------------------------+
//|                                                      Termial.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Values/Variables.mqh>

void showLog(string text){
   printf("Bot%d[%s] said: %s", magicNumber, Symbol(), text);
}