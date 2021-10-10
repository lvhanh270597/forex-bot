//+------------------------------------------------------------------+
//|                                                     Telegram.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Values/Variables.mqh>


void sendMessage(string text){
   string listGroups[];
   int groupSize = StringSplit(chatIds, ',', listGroups);
   for (int i=0; i<groupSize; i++){
      sendGroup(listGroups[i], text);
   }
}

void sendGroup(string groupId, string text){
   text = StringFormat("Bot%d[%s] said: %s", magicNumber, Symbol(), text);
   string url = "https://api.telegram.org/bot" + token + "/sendMessage";   
   char   data[]; 
   string str = StringFormat("{\"chat_id\": %s, \"text\": \"%s\"}", groupId, text);
   ArrayResize(data, StringToCharArray(str, data, 0, WHOLE_ARRAY,CP_UTF8) - 1);
   WebRequest("POST", url, "Content-Type: application/json", 5000, data, data, str);
}