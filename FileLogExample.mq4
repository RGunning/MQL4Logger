//+------------------------------------------------------------------+
//|                                               FileLogExample.mq4 |
//|                                                  Richard Gunning |
//|                                            https://rjgunning.com |
//+------------------------------------------------------------------+
#property copyright "Richard"
#property link      "https://rjgunning.com"
#property version   "1.00"
#property strict

#include <FileLog.mqh>

//Define Logger globally
CFileLog *logger;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  	//Initialise Logger with filename = "example.log", Level = WARNING and Print to console
  	logger=new CFileLog("example.log",TRACE,true);  

  	logger.Write("Write message to log with no log level");
  	logger.Trace("Write Trace message to log");
  	logger.Debug("Write Debug message to log");
  	logger.Warning("Write Warning message to log");
  	logger.Info("Write Info message to log");
  	logger.Error(StringFormat("Write Error message to log. Error at line %d",__LINE__));
  	logger.Critical("Write Critical message to log");

  	return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   logger.Info(StringFormat("DeInitialising %d",reason));
   delete logger; // delete Chart Display
  }

//+------------------------------------------------------------------+
//| Expert OnTick Function                                           |
//+------------------------------------------------------------------+
void OnTick()
  {
  	static int lastBar=0;
  	if(lastBar!=Bars)
  	{
  		logger.Info(StringFormat("New Bar on Chart. Number of bars count in the history = %d",Bars));
  		lastBar=Bars;
  	}
  }