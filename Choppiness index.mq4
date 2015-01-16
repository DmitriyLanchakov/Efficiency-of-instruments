//+------------------------------------------------------------------+
//|                                             Choppiness index.mq4 |
//|                                                           mladen |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  Red

#property indicator_level1 50

//
//
//
//
//

extern int CILength = 10;

double buffer[];


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   SetIndexBuffer(0,buffer);
   IndicatorShortName("Choppiness index ("+CILength+")");
   return(0);
}
int deinit()
{
   return(0);
}

//
//
//
//
//

int start()
{
   double log          = MathLog(CILength)/100.00;
   int    counted_bars = IndicatorCounted();
   int    i,limit;
   
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
           limit = Bars-counted_bars;

   //
   //
   //
   //
   //

   for (i=limit; i>=0; i--)
   {  
      double atrSum =    0.00;
      double maxHig = High[i];
      double minLow =  Low[i];
               
         for (int k = 0; k < CILength; k++)
         {
            atrSum += MathMax(High[i+k],Close[i+k+1])-MathMin(Low[i+k],Close[i+k+1]);
            maxHig  = MathMax(maxHig,MathMax(High[i+k],Close[i+k+1]));
            minLow  = MathMin(minLow,MathMin( Low[i+k],Close[i+k+1]));
         }
         if (maxHig!=minLow) buffer[i] = MathLog(atrSum/(maxHig-minLow))/log;
   }         
   
   //
   //
   //
   //
   //
   
   return(0);
}