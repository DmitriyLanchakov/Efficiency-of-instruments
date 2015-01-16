#property version "2.1"
#property copyright "Copyright ? 2015, Quantrade Corp."
#property link      "http: //algotrade.co"
#property description "PowerSymbols is a simple indicator"
#property description "showing most profitable symbols"
#property description " in relation to margin."

#property indicator_chart_window

//---- input parameters

extern double limitResults = 10; //less means beter efficiency
extern int limitTrendResults = 60; //  percents of trending
extern int ROIBars = 100;
extern int trendPeriod = 10;

#include <Symbols.mqh> // #### must be stated here to pull in the functions

int init()
  {
//---- indicators
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }

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
    double          eff;

    // only load the Symbols once into the array "sSymbols"
    if (iSymbols == 0)
        iSymbols = Symbols(sSymbols);

    // only start analysis on complete bars
    if (tPreviousTime == Time[0])
        return;

    for (i = 0; i < iSymbols; i++)
    {
        
        //get money value ROI over ROIBars
        double ret = MathAbs((iClose(sSymbols[i], 0, i) * MarketInfo(sSymbols[i], MODE_DIGITS) - iOpen(sSymbols[i], 0, i+ROIBars-1)) * MarketInfo(sSymbols[i], MODE_DIGITS)) * MarketInfo(sSymbols[i], MODE_TICKVALUE);
        
        if(ret != 0)
        {
        //get efficiency
        eff = MarketInfo(sSymbols[i], MODE_MARGINREQUIRED) / ret/ 10;
        } else
        {
        eff = 999999999;
        }
        
        // get in trend percent value
        double counter = DoTrendCnt(sSymbols[i])/ROIBars*100;
        
        if (eff < limitResults && counter > limitTrendResults)
        {
            p = sSymbols[i] + " Return efficiency: " + DoubleToStr(eff, 2)+" --- In trend: " + DoubleToStr(counter, 0) + "%\n" + p;
        }
        
        Comment(p);
    
    }
    
    tPreviousTime = Time[0];
    
}

//---------------------------------------------------------------------------------------------- FUNCTIONS

double DoTrendCnt(string symbol)
{
    int count = 0;
    for (int i=0; i < ROIBars; i++)
    {
    double ci     = iCustom(symbol, 0, "Choppiness index", trendPeriod, 0, i);
    if(ci < 50)
    {
    count++;
    } else
    {
    count = count;
    }
    }
    return count;
}


void DeleteLabel(string name)
{
    if (-1 != ObjectFind(name))
        ObjectDelete(name);
}