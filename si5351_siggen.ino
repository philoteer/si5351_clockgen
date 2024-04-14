
#include <Wire.h>
#include <LiquidCrystal_I2C.h> //https://github.com/fdebrabander/Arduino-LiquidCrystal-I2C-library/
#include <Adafruit_SI5351.h>

#define BUTTON_NO 9
#define LCD_I2C_ADDR 0x27
#define DEBOUNCE_DELAY 100


///////////////////////////////////////////////////////////////////////////////////////////////////
// Configs
///////////////////////////////////////////////////////////////////////////////////////////////////
LiquidCrystal_I2C lcd(LCD_I2C_ADDR,16,2); 
Adafruit_SI5351 clockgen = Adafruit_SI5351();
 
int is_button_off = 0, is_button_off_prev = 0;
signed long last_button_press = 0; //TODO implement wrapping
signed long current_time = 0; 
int button_press_cnt = 0;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Pre-configured frequency list
// PLL clock = 25 MHz * (m + n/d); m in range of (15,90), n in range of (0, 1048575), d in range of (1, 1048575)
// Output clock = PLL_clock / multisynth div (  SI5351_MULTISYNTH_DIV_4 = 4,  SI5351_MULTISYNTH_DIV_6 = 6,  SI5351_MULTISYNTH_DIV_8 = 8)
// See: https://cdn-learn.adafruit.com/downloads/pdf/adafruit-si5351-clock-generator-breakout.pdf
///////////////////////////////////////////////////////////////////////////////////////////////////
int FREQ_LUT_LEN = 3; //maybe use the sizeof()/sizeof() trick instead?
int PLL_m_LUT[] = {16, 16, 16};  //15 to 90
int PLL_n_LUT[] = {0, 0, 0}; // 0 to 1,048,575
int PLL_d_LUT[] = {1, 1, 1}; // 1 to 1,048,575
int MULTISYNTH_DIV_LUT[] = {40, 80, 160}; //4 to 900

///////////////////////////////////////////////////////////////////////////////////////////////////
// Init
///////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  //init lcd
  lcd.begin();
  lcd.backlight();
  lcd.clear();

  //init button
  pinMode(BUTTON_NO, INPUT_PULLUP);

  //init clockgen
  if (clockgen.begin() != ERROR_NONE)
  {
    lcd.print("Clockgen Error! \n");  
    while(1);
  }
  next_freq(button_press_cnt); 
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// Loop (detects the button press, and switches the frequency)
///////////////////////////////////////////////////////////////////////////////////////////////////
void loop() {
  current_time = millis();//TODO implement wrapping
  is_button_off_prev = is_button_off;
  is_button_off = digitalRead(BUTTON_NO); //fsck, I forgot to wire the button to an interruptable pin.

  if(is_button_off != is_button_off_prev && !is_button_off && current_time > last_button_press){ //on button press
    last_button_press  = current_time + DEBOUNCE_DELAY;
    button_press_cnt++;
    next_freq(button_press_cnt);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Frequency Selector
///////////////////////////////////////////////////////////////////////////////////////////////////
void next_freq(int selection){
  lcd.clear();
  selection = selection % FREQ_LUT_LEN;
  
  clockgen.setupPLL(SI5351_PLL_A, PLL_m_LUT[selection], PLL_n_LUT[selection], PLL_d_LUT[selection]);
  clockgen.setupMultisynth(0, SI5351_PLL_A, MULTISYNTH_DIV_LUT[selection], 0, 1);
  clockgen.setupMultisynth(1, SI5351_PLL_A, MULTISYNTH_DIV_LUT[selection], 0, 1);
  clockgen.setupMultisynth(2, SI5351_PLL_A, MULTISYNTH_DIV_LUT[selection], 0, 1);

  lcd.print("LUT #");   
  lcd.print(selection);   
  lcd.print(":");   
  lcd.print(PLL_m_LUT[selection]);   
  lcd.print(",");   
  lcd.print(PLL_n_LUT[selection]);   
  lcd.print(",");   
  lcd.print(PLL_d_LUT[selection]);   
  lcd.print(",");   
  lcd.print(MULTISYNTH_DIV_LUT[selection]);   

  lcd.setCursor(0,1);
  lcd.print("Freq: ");   
  lcd.print(25 * (PLL_m_LUT[selection] + (float(PLL_n_LUT[selection])/PLL_d_LUT[selection]))/ MULTISYNTH_DIV_LUT[selection]);   
  lcd.print("MHz"); 
  clockgen.enableOutputs(true);
}
