//+------------------------------------------------------------------+
//|                                                      FileLog.mqh |
//|                                                  Richard Gunning |
//|                                            https://rjgunning.com |
//+------------------------------------------------------------------+
#property copyright "Richard Gunning"
#property link      "https://rjgunning.com"
#property version   "1.02"
#property strict
#include <Files/File.mqh>

/*
*    FileLog Class
*
*    FileLog is a mql4 (MetaQuotes MetaTrader 4 Language) Class for flexible
*    logging to files and the terminal console.
*
*    Usage in your code:
* 
*        CFileLog* logger = new CFileLog("example.log",WARNING,true,true);
*        logger.Error(StringFormat("%s %d %s",__FILE__, __LINE__, "Something unexpected happen"));
*        logger.Info(StringFormat("%s %d %s",__FILE__, __LINE__, "Calculation Done));
*        logger.debug(StringFormat("%s %d The result of %s is %d",__FILE__, __LINE__,string1, value1));
*
*     Dont forget at the end of your EA / Indicator / Script:
*         Delete logger;
*
*     Log Levels:
*         TRACE
*         DEBUG
*         INFO
*         WARNING
*         ERROR
*         CRITICAL
*
*/

//+------------------------------------------------------------------+
//| Log Enumeration Level                                            |
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVEL
  {
   TRACE=0,
   DEBUG=1,
   INFO=2,
   WARNING=3,
   ERROR=4,
   CRITICAL=5
  };

//+------------------------------------------------------------------+
//| Class CFileLog                                                   |
//| Purpose: Class of operations with log files.                     |
//|          Derives from class CFile.                               |
//+------------------------------------------------------------------+

class CFileLog : public CFile
  {
private:
   ENUM_LOG_LEVEL    m_level;
   bool              m_print;
   int               iFileRead;
public:
                     CFileLog();
                     CFileLog(string file_name="example.log",ENUM_LOG_LEVEL level=3,bool print=false, bool bAppPreExist = false);
                    ~CFileLog();
   //--- methods for working with files
   void              SetLevel(ENUM_LOG_LEVEL value) {m_level=value;}
   void              SetPrint(bool value) {m_print=value;}
   //--- methods for working with files
   int               Open(const string file_name,const int open_flags);
   //--- methods to access data
   uint              Write(const string value);
   uint              Log(const ENUM_LOG_LEVEL level, const string value);
   void              Trace(const string value);
   void              Debug(const string value);
   void              Info(const string value);
   void              Warning(const string value);
   void              Error(const string value);
   void              Critical(const string value);
  };

//+------------------------------------------------------------------+
//| Standard Constructor                                             |
//+------------------------------------------------------------------+
CFileLog::CFileLog():m_level(WARNING),
                     m_print(false)
  {
  }

//+------------------------------------------------------------------+
//| Constructor with options                                         |
//| @var string file_name                                            |
//|             Filename of LogFile with extension                   |
//| @var ENUM_LOG_LEVEL level                                        |
//|             Level of Log message                                 | 
//| @var bool print                                                  |
//|             print to console                                     |
//| @var bool bAppPreExist                                           |
//|             write in append mode if file pre exist               |
//+------------------------------------------------------------------+
CFileLog::CFileLog(string file_name="example.log",ENUM_LOG_LEVEL level=3,bool print=false, bool bAppPreExist = false)
{
  this.iFileRead = bAppPreExist ? FILE_READ : 0;
  Open(file_name);
  FileSeek(m_handle, 0, SEEK_END);
  SetLevel(level);
  SetPrint(print);
  FileFlush(m_handle);
}



//+------------------------------------------------------------------+
//|  Deconstructor                                                   |
//+------------------------------------------------------------------+
CFileLog::~CFileLog()
  {
    FileClose(m_handle);
  }

//+------------------------------------------------------------------+
//| Open the log file                                                |
//| @var string file_name                                            |
//|             Filename of LogFile with extension                   |
//| @var int open_flags                                              |
//|             Flags for Opening LogFile                            |
//| @return int                                                      |
//+------------------------------------------------------------------+
int CFileLog::Open(const string file_name,const int open_flags=FILE_WRITE)
  {
   return(CFile::Open(file_name,this.iFileRead|open_flags|FILE_CSV|FILE_SHARE_READ));
  }

//+------------------------------------------------------------------+
//| Writing string to file                                           |
//| @var string value                                                |
//|             Message to Write                                     |
//+------------------------------------------------------------------+
uint CFileLog::Write(const string value)
  {
   if(m_print){Print(value);}
//--- check handle
   if(m_handle!=INVALID_HANDLE) {
     uint uiRet = FileWrite(m_handle,TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS),"",value);
     FileFlush(m_handle);
     return(uiRet);
   }
//--- failure
   return(0);
  }

//+------------------------------------------------------------------+
//| Log string to file                                               | 
//| @var ENUM_LOG_LEVEL level                                        |
//|             Level of Log message                                 |  
//| @var string value                                                |
//|             Message to Write                                     |
//| @return uint                                                     |
//|             0 returned on failure                                |
//+------------------------------------------------------------------+
uint CFileLog::Log(const ENUM_LOG_LEVEL level, const string value)
  {
   string levelString = StringFormat("[%s]",EnumToString(level));
   if(m_print && m_level<=level){PrintFormat("%s %s",levelString,value);}
//--- check handle
   if(m_handle!=INVALID_HANDLE && m_level<=level) {
     uint uiRet = FileWrite(m_handle,TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS),levelString,value);
     FileFlush(m_handle);
     return(uiRet);
   }
//--- failure
   return(0);
  }

//+------------------------------------------------------------------+
//| Writing Trace string to file                                     |
//| @var string value                                                |
//|             Message to Write                                     |
//| @return void                                                     |
//+------------------------------------------------------------------+
void CFileLog::Trace(const string value)
  {
    Log(TRACE,value);
  }
//+------------------------------------------------------------------+
//| Writing Debug string to file                                     |
//| @var string value                                                |
//|             Message to Write                                     |
//| @return void                                                     |
//+------------------------------------------------------------------+
void CFileLog::Debug(const string value)
  {
       Log(DEBUG,value);
  }
//+------------------------------------------------------------------+
//| Writing Info string to file                                      |
//| @var string value                                                |
//|             Message to Write                                     |
//| @return void                                                     |
//+------------------------------------------------------------------+
void CFileLog::Info(const string value)
  {
       Log(INFO,value);
  }
//+------------------------------------------------------------------+
//| Writing Warning string to file                                   |
//| @var string value                                                |
//|             Message to Write                                     |
//| @return void                                                     |
//+------------------------------------------------------------------+
void CFileLog::Warning(const string value)
  {
       Log(WARNING,value);
  }
//+------------------------------------------------------------------+
//| Writing Error string to file                                     |
//| @var string value                                                |
//|             Message to Write                                     |
//| @return void                                                     |
//+------------------------------------------------------------------+
void CFileLog::Error(const string value)
  {
       Log(ERROR,value);
  }
//+------------------------------------------------------------------+
//| Writing Critical string to file                                  |
//| @var string value                                                |
//|             Message to Write                                     |
//| @return void                                                     |
//+------------------------------------------------------------------+
void CFileLog::Critical(const string value)
  {
       Log(CRITICAL,value);
  }
  
//+------------------------------------------------------------------+
