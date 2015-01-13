#property version "1.0"
#property copyright "Copyright ? 2015, Quantrade Corp."
#property link      "http: //algotrade.co"
#property description "PowerSymbols is a simple indicator"
#property description "showing most profitable symbols"
#property description " in relation to margin."

#property indicator_chart_window
//---- input parameters

extern int limitN     = 1;
extern int returnBars = 24;

#include <Symbols.mqh> // #### must be stated here to pull in the functions

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
{
    static string   sSymbols[1000];
    static int      iSymbols;
    static datetime tPreviousTime;
    //double dMA;
    int             i;
    string          sPeriod = "," + PeriodToStr();
    string          p;
    double          marza;

    // only load the Symbols once into the array "sSymbols"
    if (iSymbols == 0)
        iSymbols = Symbols(sSymbols);

    // only start analysis on complete bars
    if (tPreviousTime == Time[0])
        return;

    for (i = 0; i < iSymbols; i++)
    {
        marza = MarketInfo(sSymbols[i], MODE_MARGINREQUIRED) / (MathAbs(iClose(sSymbols[i], 0, i) * MarketInfo(sSymbols[i], MODE_DIGITS) - iOpen(sSymbols[i], 0, i + returnBars - 1) * MarketInfo(sSymbols[i], MODE_DIGITS)) * MarketInfo(sSymbols[i], MODE_TICKVALUE)) / 1000;
        if (marza < limitN)
        {
            p = sSymbols[i] + " " + DoubleToStr(marza, 2) + "\n" + p;
        }
        Comment(p);
    }
    tPreviousTime = Time[0];
}
//+------------------------------------------------------------------+
