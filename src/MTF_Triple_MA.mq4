//+------------------------------------------------------------------+
//|                                             MTF_Triple_MA.mq4    |
//|                                                             FxTT  |
//+------------------------------------------------------------------+
#property copyright "FxTT"
#property link      "https://forextradingtools.eu/en/marketplace/mtf-triple-ma"
#property version   "2.00"
#property strict
#property description "Triple Moving Average Multi-Timeframe Panel"
#property indicator_chart_window
#property indicator_buffers 27

//--- one set of Fast/Medium/Slow buffers for each source timeframe
#property indicator_label1  "MA Fast MN1"
#property indicator_color1  clrMagenta
#property indicator_style1  STYLE_DOT
#property indicator_width1  1
#property indicator_label2  "MA Medium MN1"
#property indicator_color2  clrMagenta
#property indicator_style2  STYLE_DASH
#property indicator_width2  1
#property indicator_label3  "MA Slow MN1"
#property indicator_color3  clrMagenta
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
#property indicator_label4  "MA Fast W1"
#property indicator_color4  clrDodgerBlue
#property indicator_style4  STYLE_DOT
#property indicator_width4  1
#property indicator_label5  "MA Medium W1"
#property indicator_color5  clrDodgerBlue
#property indicator_style5  STYLE_DASH
#property indicator_width5  1
#property indicator_label6  "MA Slow W1"
#property indicator_color6  clrDodgerBlue
#property indicator_style6  STYLE_SOLID
#property indicator_width6  2
#property indicator_label7  "MA Fast D1"
#property indicator_color7  clrOrange
#property indicator_style7  STYLE_DOT
#property indicator_width7  1
#property indicator_label8  "MA Medium D1"
#property indicator_color8  clrOrange
#property indicator_style8  STYLE_DASH
#property indicator_width8  1
#property indicator_label9  "MA Slow D1"
#property indicator_color9  clrOrange
#property indicator_style9  STYLE_SOLID
#property indicator_width9  2
#property indicator_label10 "MA Fast H4"
#property indicator_color10 clrLimeGreen
#property indicator_style10 STYLE_DOT
#property indicator_width10 1
#property indicator_label11 "MA Medium H4"
#property indicator_color11 clrLimeGreen
#property indicator_style11 STYLE_DASH
#property indicator_width11 1
#property indicator_label12 "MA Slow H4"
#property indicator_color12 clrLimeGreen
#property indicator_style12 STYLE_SOLID
#property indicator_width12 2
#property indicator_label13 "MA Fast H1"
#property indicator_color13 clrGold
#property indicator_style13 STYLE_DOT
#property indicator_width13 1
#property indicator_label14 "MA Medium H1"
#property indicator_color14 clrGold
#property indicator_style14 STYLE_DASH
#property indicator_width14 1
#property indicator_label15 "MA Slow H1"
#property indicator_color15 clrGold
#property indicator_style15 STYLE_SOLID
#property indicator_width15 2
#property indicator_label16 "MA Fast M30"
#property indicator_color16 clrTomato
#property indicator_style16 STYLE_DOT
#property indicator_width16 1
#property indicator_label17 "MA Medium M30"
#property indicator_color17 clrTomato
#property indicator_style17 STYLE_DASH
#property indicator_width17 1
#property indicator_label18 "MA Slow M30"
#property indicator_color18 clrTomato
#property indicator_style18 STYLE_SOLID
#property indicator_width18 2
#property indicator_label19 "MA Fast M15"
#property indicator_color19 clrDeepSkyBlue
#property indicator_style19 STYLE_DOT
#property indicator_width19 1
#property indicator_label20 "MA Medium M15"
#property indicator_color20 clrDeepSkyBlue
#property indicator_style20 STYLE_DASH
#property indicator_width20 1
#property indicator_label21 "MA Slow M15"
#property indicator_color21 clrDeepSkyBlue
#property indicator_style21 STYLE_SOLID
#property indicator_width21 2
#property indicator_label22 "MA Fast M5"
#property indicator_color22 clrViolet
#property indicator_style22 STYLE_DOT
#property indicator_width22 1
#property indicator_label23 "MA Medium M5"
#property indicator_color23 clrViolet
#property indicator_style23 STYLE_DASH
#property indicator_width23 1
#property indicator_label24 "MA Slow M5"
#property indicator_color24 clrViolet
#property indicator_style24 STYLE_SOLID
#property indicator_width24 2
#property indicator_label25 "MA Fast M1"
#property indicator_color25 clrSilver
#property indicator_style25 STYLE_DOT
#property indicator_width25 1
#property indicator_label26 "MA Medium M1"
#property indicator_color26 clrSilver
#property indicator_style26 STYLE_DASH
#property indicator_width26 1
#property indicator_label27 "MA Slow M1"
#property indicator_color27 clrSilver
#property indicator_style27 STYLE_SOLID
#property indicator_width27 2

//--- Moving averages: Fast, Medium, and Slow are independently period-configurable.
input int                InpFastPeriod = 50;
input int                InpMedPeriod  = 100;
input int                InpSlowPeriod = 200;
input ENUM_MA_METHOD     InpMAMethod   = MODE_EMA;
input ENUM_APPLIED_PRICE InpMAPrice    = PRICE_CLOSE;
input int                InpMAShift    = 0;

//--- panel and labels
input int  InpPanelX = 20;
input int  InpPanelY = 30;
input bool InpShowLabels     = true;
input int  InpLabelShiftBars = 1;
input int  InpLabelFontSize  = 8;

enum ETFIndex
{
   TF_MN1 = 0,
   TF_W1  = 1,
   TF_D1  = 2,
   TF_H4  = 3,
   TF_H1  = 4,
   TF_M30 = 5,
   TF_M15 = 6,
   TF_M5  = 7,
   TF_M1  = 8
};

#define TF_COUNT 9
#define PLOT_COUNT 27

//--- Explicit arrays keep this file compatible with the standard MT4 compiler.
double B0[], B1[], B2[], B3[], B4[], B5[], B6[], B7[], B8[];
double B9[], B10[], B11[], B12[], B13[], B14[], B15[], B16[], B17[];
double B18[], B19[], B20[], B21[], B22[], B23[], B24[], B25[], B26[];

bool     g_Show[TF_COUNT];
bool     g_Eligible[TF_COUNT];
datetime g_Time[];
int      g_RatesTotal = 0;
bool     g_Expanded = true;
bool     g_Dirty = true;
int      g_PanelX = 0;
int      g_PanelY = 0;
bool     g_Dragging = false;
bool     g_ActuallyDragged = false;
bool     g_WasLBDown = false;
int      g_DragOffX = 0;
int      g_DragOffY = 0;
int      g_DragStartX = 0;
int      g_DragStartY = 0;
string   g_Pfx;

const int DRAG_THRESHOLD = 4;
const int PANEL_W = 230;
const int TOGGLE_H = 24;
const int CHECK_H = 22;
const int PADDING = 4;
const int GAP = 2;
const color CLR_PANEL_BG = C'18,26,42';
const color CLR_PANEL_BORDER = C'55,85,130';
const color CLR_TOGGLE_BG = C'35,55,90';
const color CLR_CHECK_BG_ON = C'28,44,68';
const color CLR_CHECK_BG_OFF = C'16,22,34';
const color CLR_UNCHECKED_TEXT = C'70,85,100';
const color CLR_DISABLED_BG = C'14,18,24';
const color CLR_DISABLED_TEXT = C'40,48,58';

string N(const string name) { return g_Pfx + name; }

int TfByIndex(const int index)
{
   switch(index)
   {
      case TF_MN1: return PERIOD_MN1;
      case TF_W1:  return PERIOD_W1;
      case TF_D1:  return PERIOD_D1;
      case TF_H4:  return PERIOD_H4;
      case TF_H1:  return PERIOD_H1;
      case TF_M30: return PERIOD_M30;
      case TF_M15: return PERIOD_M15;
      case TF_M5:  return PERIOD_M5;
      case TF_M1:  return PERIOD_M1;
   }
   return PERIOD_CURRENT;
}

string TfLabel(const int index)
{
   switch(index)
   {
      case TF_MN1: return "MN1";
      case TF_W1:  return "W1";
      case TF_D1:  return "D1";
      case TF_H4:  return "H4";
      case TF_H1:  return "H1";
      case TF_M30: return "M30";
      case TF_M15: return "M15";
      case TF_M5:  return "M5";
      case TF_M1:  return "M1";
   }
   return "";
}

int TfSeconds(const int tf)
{
   switch(tf)
   {
      case PERIOD_M1:  return 60;
      case PERIOD_M5:  return 300;
      case PERIOD_M15: return 900;
      case PERIOD_M30: return 1800;
      case PERIOD_H1:  return 3600;
      case PERIOD_H4:  return 14400;
      case PERIOD_D1:  return 86400;
      case PERIOD_W1:  return 604800;
      case PERIOD_MN1: return 2592000;
   }
   return 0;
}

color AccentColor(const int index)
{
   switch(index)
   {
      case TF_MN1: return clrMagenta;
      case TF_W1:  return clrDodgerBlue;
      case TF_D1:  return clrOrange;
      case TF_H4:  return clrLimeGreen;
      case TF_H1:  return clrGold;
      case TF_M30: return clrTomato;
      case TF_M15: return clrDeepSkyBlue;
      case TF_M5:  return clrViolet;
      case TF_M1:  return clrSilver;
   }
   return clrWhite;
}

string CheckboxId(const int index) { return "Cb" + TfLabel(index); }
string CheckboxText(const int index) { return "[ ]  Triple MA  " + TfLabel(index); }
string MASpeedLabel(const int index)
{
   if(index == 0) return "MA" + IntegerToString(InpFastPeriod);
   if(index == 1) return "MA" + IntegerToString(InpMedPeriod);
   if(index == 2) return "MA" + IntegerToString(InpSlowPeriod);
   return "";
}
string PlotLabel(const int plot) { return MASpeedLabel(plot % 3) + " " + TfLabel(plot / 3); }
int PanelHeight(const bool expanded)
{
   if(expanded) return PADDING + TOGGLE_H + GAP + TF_COUNT * (CHECK_H + GAP) + PADDING;
   return PADDING + TOGGLE_H + PADDING;
}
string GVK(const string suffix) { return "TRMTF_" + IntegerToString((int)ChartID()) + "_" + suffix; }

void StateSave()
{
   GlobalVariableSet(GVK("X"), g_PanelX);
   GlobalVariableSet(GVK("Y"), g_PanelY);
   GlobalVariableSet(GVK("Expanded"), g_Expanded ? 1.0 : 0.0);
   for(int i = 0; i < TF_COUNT; i++)
      GlobalVariableSet(GVK("Show" + TfLabel(i)), g_Show[i] ? 1.0 : 0.0);
}

bool StateLoad()
{
   if(!GlobalVariableCheck(GVK("X"))) return false;
   g_PanelX = (int)GlobalVariableGet(GVK("X"));
   g_PanelY = (int)GlobalVariableGet(GVK("Y"));
   g_Expanded = GlobalVariableGet(GVK("Expanded")) != 0.0;
   for(int i = 0; i < TF_COUNT; i++)
   {
      string key = GVK("Show" + TfLabel(i));
      if(GlobalVariableCheck(key)) g_Show[i] = GlobalVariableGet(key) != 0.0;
   }
   return true;
}

void StateDelete()
{
   GlobalVariableDel(GVK("X"));
   GlobalVariableDel(GVK("Y"));
   GlobalVariableDel(GVK("Expanded"));
   for(int i = 0; i < TF_COUNT; i++) GlobalVariableDel(GVK("Show" + TfLabel(i)));
}

void Put(const int plot, const int shift, const double value)
{
   switch(plot)
   {
      case 0: B0[shift] = value; break; case 1: B1[shift] = value; break; case 2: B2[shift] = value; break;
      case 3: B3[shift] = value; break; case 4: B4[shift] = value; break; case 5: B5[shift] = value; break;
      case 6: B6[shift] = value; break; case 7: B7[shift] = value; break; case 8: B8[shift] = value; break;
      case 9: B9[shift] = value; break; case 10: B10[shift] = value; break; case 11: B11[shift] = value; break;
      case 12: B12[shift] = value; break; case 13: B13[shift] = value; break; case 14: B14[shift] = value; break;
      case 15: B15[shift] = value; break; case 16: B16[shift] = value; break; case 17: B17[shift] = value; break;
      case 18: B18[shift] = value; break; case 19: B19[shift] = value; break; case 20: B20[shift] = value; break;
      case 21: B21[shift] = value; break; case 22: B22[shift] = value; break; case 23: B23[shift] = value; break;
      case 24: B24[shift] = value; break; case 25: B25[shift] = value; break; case 26: B26[shift] = value; break;
   }
}

double Get(const int plot, const int shift)
{
   switch(plot)
   {
      case 0: return B0[shift]; case 1: return B1[shift]; case 2: return B2[shift]; case 3: return B3[shift];
      case 4: return B4[shift]; case 5: return B5[shift]; case 6: return B6[shift]; case 7: return B7[shift];
      case 8: return B8[shift]; case 9: return B9[shift]; case 10: return B10[shift]; case 11: return B11[shift];
      case 12: return B12[shift]; case 13: return B13[shift]; case 14: return B14[shift]; case 15: return B15[shift];
      case 16: return B16[shift]; case 17: return B17[shift]; case 18: return B18[shift]; case 19: return B19[shift];
      case 20: return B20[shift]; case 21: return B21[shift]; case 22: return B22[shift]; case 23: return B23[shift];
      case 24: return B24[shift]; case 25: return B25[shift]; case 26: return B26[shift];
   }
   return EMPTY_VALUE;
}

void ClearPlot(const int plot)
{
   for(int i = 0; i < g_RatesTotal; i++) Put(plot, i, EMPTY_VALUE);
}
void ClearTf(const int tfIndex)
{
   ClearPlot(tfIndex * 3);
   ClearPlot(tfIndex * 3 + 1);
   ClearPlot(tfIndex * 3 + 2);
}

void CalculatePlot(const int plot, const int tf, const int period, const int start)
{
   int from = MathMin(g_RatesTotal - 1, MathMax(0, start));
   for(int i = from; i >= 0; i--)
   {
      int sourceShift = iBarShift(NULL, tf, g_Time[i], false);
      if(sourceShift < 0 || period < 1)
         Put(plot, i, EMPTY_VALUE);
      else
         Put(plot, i, iMA(NULL, tf, period, InpMAShift, InpMAMethod, InpMAPrice, sourceShift));
   }
}

void CalculateTf(const int tfIndex, const int start)
{
   if(!g_Show[tfIndex] || !g_Eligible[tfIndex]) { ClearTf(tfIndex); return; }
   CalculatePlot(tfIndex * 3, TfByIndex(tfIndex), InpFastPeriod, start);
   CalculatePlot(tfIndex * 3 + 1, TfByIndex(tfIndex), InpMedPeriod, start);
   CalculatePlot(tfIndex * 3 + 2, TfByIndex(tfIndex), InpSlowPeriod, start);
}

void DeleteLabel(const int plot)
{
   ObjectDelete(0, N("MALbl_" + IntegerToString(plot)));
}
void SetLabel(const int plot, const bool visible)
{
   if(!InpShowLabels || !visible || g_RatesTotal <= 0)
   {
      DeleteLabel(plot);
      return;
   }
   double price = Get(plot, 0);
   if(price == EMPTY_VALUE || !MathIsValidNumber(price)) { DeleteLabel(plot); return; }
   string name = N("MALbl_" + IntegerToString(plot));
   datetime when = g_Time[0] + (datetime)(MathMax(0, InpLabelShiftBars) * MathMax(60, TfSeconds(Period())));
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_TEXT, 0, when, price);
   else ObjectMove(0, name, 0, when, price);
   ObjectSetString(0, name, OBJPROP_TEXT, PlotLabel(plot));
   ObjectSetInteger(0, name, OBJPROP_COLOR, AccentColor(plot / 3));
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, MathMax(1, InpLabelFontSize));
   ObjectSetString(0, name, OBJPROP_FONT, "Segoe UI");
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
}
void RefreshLabels()
{
   for(int i = 0; i < PLOT_COUNT; i++) SetLabel(i, g_Show[i / 3] && g_Eligible[i / 3]);
}
void DeleteLabels()
{
   for(int i = 0; i < PLOT_COUNT; i++) DeleteLabel(i);
}

void CreateBackground(const string name, const int x, const int y, const int w, const int h)
{
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x); ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w); ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, CLR_PANEL_BG); ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_COLOR, CLR_PANEL_BORDER); ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_BACK, false); ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
}
void CreateButton(const string name, const int x, const int y, const int w, const int h,
                  const string text, const color bg, const color fg, const bool state)
{
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x); ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w); ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER); ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, name, OBJPROP_COLOR, fg); ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, CLR_PANEL_BORDER);
   ObjectSetString(0, name, OBJPROP_TEXT, text); ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Segoe UI"); ObjectSetInteger(0, name, OBJPROP_STATE, state);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false); ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
}
void UpdateCheckbox(const int index)
{
   string name = N(CheckboxId(index));
   bool checked = g_Show[index] && g_Eligible[index];
   ObjectSetInteger(0, name, OBJPROP_STATE, checked);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, !g_Eligible[index] ? CLR_DISABLED_BG : checked ? CLR_CHECK_BG_ON : CLR_CHECK_BG_OFF);
   ObjectSetInteger(0, name, OBJPROP_COLOR, !g_Eligible[index] ? CLR_DISABLED_TEXT : checked ? AccentColor(index) : CLR_UNCHECKED_TEXT);
}
void PanelCreate()
{
   int bx = g_PanelX + PADDING;
   int bw = PANEL_W - 2 * PADDING;
   CreateBackground(N("BG"), g_PanelX, g_PanelY, PANEL_W, PanelHeight(g_Expanded));
   CreateButton(N("Toggle"), bx, g_PanelY + PADDING, bw, TOGGLE_H,
                g_Expanded ? " Triple MA Panel  ^" : " Triple MA Panel  v", CLR_TOGGLE_BG, clrWhite, false);
   int cy = g_PanelY + PADDING + TOGGLE_H + GAP;
   for(int i = 0; i < TF_COUNT; i++)
   {
      CreateButton(N(CheckboxId(i)), bx, cy, bw, CHECK_H, CheckboxText(i),
                    !g_Eligible[i] ? CLR_DISABLED_BG : g_Show[i] ? CLR_CHECK_BG_ON : CLR_CHECK_BG_OFF,
                    !g_Eligible[i] ? CLR_DISABLED_TEXT : g_Show[i] ? AccentColor(i) : CLR_UNCHECKED_TEXT,
                    g_Show[i] && g_Eligible[i]);
      ObjectSetInteger(0, N(CheckboxId(i)), OBJPROP_TIMEFRAMES, g_Expanded ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
      cy += CHECK_H + GAP;
   }
   RefreshLabels();
}
void PanelDelete()
{
   ObjectDelete(0, N("BG")); ObjectDelete(0, N("Toggle"));
   for(int i = 0; i < TF_COUNT; i++) ObjectDelete(0, N(CheckboxId(i)));
   DeleteLabels();
}
void PanelMove(const int x, const int y)
{
   g_PanelX = MathMax(0, x); g_PanelY = MathMax(0, y);
   int bx = g_PanelX + PADDING;
   ObjectSetInteger(0, N("BG"), OBJPROP_XDISTANCE, g_PanelX); ObjectSetInteger(0, N("BG"), OBJPROP_YDISTANCE, g_PanelY);
   ObjectSetInteger(0, N("Toggle"), OBJPROP_XDISTANCE, bx); ObjectSetInteger(0, N("Toggle"), OBJPROP_YDISTANCE, g_PanelY + PADDING);
   int cy = g_PanelY + PADDING + TOGGLE_H + GAP;
   for(int i = 0; i < TF_COUNT; i++)
   {
      ObjectSetInteger(0, N(CheckboxId(i)), OBJPROP_XDISTANCE, bx);
      ObjectSetInteger(0, N(CheckboxId(i)), OBJPROP_YDISTANCE, cy);
      cy += CHECK_H + GAP;
   }
   StateSave();
}
void PanelSetExpanded(const bool expand)
{
   g_Expanded = expand;
   ObjectSetInteger(0, N("BG"), OBJPROP_YSIZE, PanelHeight(expand));
   ObjectSetString(0, N("Toggle"), OBJPROP_TEXT, expand ? " Triple MA Panel  ^" : " Triple MA Panel  v");
   long visible = expand ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS;
   for(int i = 0; i < TF_COUNT; i++) ObjectSetInteger(0, N(CheckboxId(i)), OBJPROP_TIMEFRAMES, visible);
   StateSave();
}
void ToggleTf(const int index)
{
   if(!g_Eligible[index]) { g_Show[index] = false; UpdateCheckbox(index); return; }
   g_Show[index] = !g_Show[index];
   UpdateCheckbox(index);
   CalculateTf(index, 0);
   g_Dirty = false;
   RefreshLabels();
   StateSave();
   ChartRedraw(0);
}

int OnInit()
{
   g_Pfx = "TRMTF_" + IntegerToString((int)ChartID()) + "_";
   ArrayInitialize(g_Show, true);
   if(!StateLoad()) { g_PanelX = InpPanelX; g_PanelY = InpPanelY; }
   if(InpFastPeriod < 1 || InpMedPeriod < 1 || InpSlowPeriod < 1) return INIT_PARAMETERS_INCORRECT;
   int chartSeconds = TfSeconds(Period());
   for(int i = 0; i < TF_COUNT; i++) g_Eligible[i] = chartSeconds <= TfSeconds(TfByIndex(i));

   // MT4 does not support arrays of buffer references; register each buffer explicitly.
   SetIndexBuffer(0,B0); SetIndexBuffer(1,B1); SetIndexBuffer(2,B2); SetIndexBuffer(3,B3); SetIndexBuffer(4,B4); SetIndexBuffer(5,B5); SetIndexBuffer(6,B6); SetIndexBuffer(7,B7); SetIndexBuffer(8,B8);
   SetIndexBuffer(9,B9); SetIndexBuffer(10,B10); SetIndexBuffer(11,B11); SetIndexBuffer(12,B12); SetIndexBuffer(13,B13); SetIndexBuffer(14,B14); SetIndexBuffer(15,B15); SetIndexBuffer(16,B16); SetIndexBuffer(17,B17);
   SetIndexBuffer(18,B18); SetIndexBuffer(19,B19); SetIndexBuffer(20,B20); SetIndexBuffer(21,B21); SetIndexBuffer(22,B22); SetIndexBuffer(23,B23); SetIndexBuffer(24,B24); SetIndexBuffer(25,B25); SetIndexBuffer(26,B26);
   for(int i = 0; i < PLOT_COUNT; i++) { SetIndexEmptyValue(i, EMPTY_VALUE); SetIndexDrawBegin(i, InpSlowPeriod); SetIndexLabel(i, PlotLabel(i)); }
   ArraySetAsSeries(g_Time, true);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   PanelCreate();
   return INIT_SUCCEEDED;
}
void OnDeinit(const int reason)
{
   ChartSetInteger(0, CHART_MOUSE_SCROLL, true); PanelDelete();
   if(reason == REASON_REMOVE || reason == REASON_RECOMPILE) StateDelete();
   ChartRedraw(0);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[],
                const double &high[], const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
{
   g_RatesTotal = rates_total;
   ArrayCopy(g_Time, time);
   if(rates_total < InpSlowPeriod) return 0;
   int start = (prev_calculated == 0 || g_Dirty) ? rates_total - 1 : MathMin(rates_total - 1, rates_total - prev_calculated + 2);
   for(int i = 0; i < TF_COUNT; i++) CalculateTf(i, start);
   g_Dirty = false;
   RefreshLabels();
   return rates_total;
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      int mouseX = (int)lparam, mouseY = (int)dparam;
      bool lbDown = ((int)StringToInteger(sparam) & 1) != 0;
      if(lbDown && !g_WasLBDown && mouseX >= g_PanelX + PADDING && mouseX <= g_PanelX + PANEL_W - PADDING &&
         mouseY >= g_PanelY + PADDING && mouseY <= g_PanelY + PADDING + TOGGLE_H)
      {
         g_Dragging = true; g_ActuallyDragged = false; g_DragOffX = mouseX - g_PanelX; g_DragOffY = mouseY - g_PanelY;
         g_DragStartX = mouseX; g_DragStartY = mouseY; ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
      }
      if(!lbDown && g_Dragging) { g_Dragging = false; ChartSetInteger(0, CHART_MOUSE_SCROLL, true); }
      if(g_Dragging && lbDown)
      {
         if(!g_ActuallyDragged && (MathAbs(mouseX - g_DragStartX) > DRAG_THRESHOLD || MathAbs(mouseY - g_DragStartY) > DRAG_THRESHOLD)) g_ActuallyDragged = true;
         if(g_ActuallyDragged) PanelMove(mouseX - g_DragOffX, mouseY - g_DragOffY);
      }
      g_WasLBDown = lbDown;
      return;
   }
   if(id != CHARTEVENT_OBJECT_CLICK) return;
   if(sparam == N("Toggle"))
   {
      ObjectSetInteger(0, N("Toggle"), OBJPROP_STATE, false);
      if(g_ActuallyDragged) { g_ActuallyDragged = false; return; }
      PanelSetExpanded(!g_Expanded); return;
   }
   for(int i = 0; i < TF_COUNT; i++) if(sparam == N(CheckboxId(i))) { ToggleTf(i); return; }
}
//+------------------------------------------------------------------+
