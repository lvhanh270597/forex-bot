//+------------------------------------------------------------------+
//|                                                        Basic.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

void DrawArrow(double linePrice, datetime time, bool bullish){
    string name = "arrow"+(bullish?"up":"down") + IntegerToString(time);
    ObjectCreate(name, OBJ_ARROW, 0, time, linePrice);
    ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
    ObjectSet(name, OBJPROP_ARROWCODE, bullish?SYMBOL_ARROWUP:SYMBOL_ARROWDOWN);
    ObjectSet(name, OBJPROP_COLOR, bullish? clrLime : clrRed);
}