//+------------------------------------------------------------------+
//|                                                    Variables.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| Enum define                                                      |
//+------------------------------------------------------------------+
enum ENUM_TREND { UP_TREND, DOWN_TREND };
enum ENUM_OPEN_TYPE_RECOMMEND  { NOTHING, OPEN_BUY, OPEN_SELL };
enum ENUM_CAPITAL_OPEN_RECOMMEND { OPEN_NOTHING, OPEN_DEFAULT, OPEN_SMALL };

//+------------------------------------------------------------------+
//| Bot input                                                        |
//+------------------------------------------------------------------+
extern int magicNumber = 0;                                 // Magic number

//+------------------------------------------------------------------+
//| Signal inputs                                                    |
//+------------------------------------------------------------------+
extern ENUM_TIMEFRAMES timeFrameUsed = PERIOD_H1;           // Timeframe for analysts signal
extern ENUM_TREND priorityTrend = UP_TREND;                 // Priority trend/
extern double peakOrBottom = 0.0;                           // Peak or Bottom of trend
extern double pinbarRatio = 1.0;                            // Pinbar ratio

//+------------------------------------------------------------------+
//| Capital inputs                                                   |
//+------------------------------------------------------------------+
extern int maxOrdersOpened = 4;                             // Max orders opened
extern int minDistanceOrdersPip = 100;                      // Minimal distance between 2 orders

extern int maxPipLoss = 1000;                               // Total pip for loss
extern double volumeDefault = 0.02;                         // Default volume for an order
extern int defaultPipLossAccept = 250;                      // Default pip loss accept
extern double volumeSmaller = 0.01;                         // Smaller volume for an order
extern int smallerPipLossAccept = 450;                      // Smaller pip loss accept
extern int pipMovingEntry = 30;                             // Pip moving entry profit
extern int pipTrailingStoploss = 60;                        // Pip trailing stoploss
extern int pipTakeProfit = 0;                               // Pip takeprofit
//+------------------------------------------------------------------+
//| Notification inputs                                              |
//+------------------------------------------------------------------+
extern bool externalNoti = false;                                         // Enable external notification
extern string token = "1836388902:AAH9h7VIU4HoVCKBtL2FEWzHfdHG7ZXZ1cQ";   // Token of bot
extern string chatIds = "-528261310";                                     // List of chatId separated by ,