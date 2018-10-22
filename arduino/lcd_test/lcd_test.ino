#include <LiquidCrystal.h>
LiquidCrystal lcd(1,0,5,4,3,2);
int i=0;
void setup() {
  // put your setup code here, to run once:
  pinMode(9,INPUT);
  lcd.begin(16,2);
}

void loop() {
  // put your main code here, to run repeatedly:
  int val=digitalRead(9);
  if(val==HIGH) {
    i=1;
  } else {
    i=i+1;
  }
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(i);
    
  delay(1000);
  
}
