# FileLog Class

FileLog is a mql4 (MetaQuotes MetaTrader 4 Language) Class for flexible logging to files and the terminal console.

Log File will be saved in:
* \<Data folder\>\MQL4\Files\
* \<Data folder\>\Tester\Files\

## Usage in your code:

    CFileLog* logger = new CFileLog("example.log",WARNING,true);
    logger.Error(StringFormat("%s %d %s",__FILE__, __LINE__, "Something unexpected happen"));
    logger.Info(StringFormat("%s %d %s",__FILE__, __LINE__, "Calculation Done));
    logger.debug(StringFormat("%s %d The result of %s is %d",__FILE__, __LINE__,string1, value1));

Dont forget at the end of your EA / Indicator / Script:

    Delete logger;

Log Levels:
* TRACE
* DEBUG
* INFO
* WARNING
* ERROR
* CRITICAL

Log Functions:
* Trace()
* Debug()
* Info()
* Warning()
* Error()
* Critical()
