/*
* Sprinting Gates Timer Code
*/

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#define COMPONENT 3 // 1 for remote, 2 for laser detector (x 2)

#if (COMPONENT==1)
#include <LiquidCrystal.h>
LiquidCrystal lcd(1,0,5,4,3,2);
#endif


RF24 radio(7, 8); // CE, CSN

const uint64_t wAddress[] = {0x7878787878LL, 0xB3B4B5B6F1LL, 0xB3B4B5B6CDLL, 0xB3B4B5B6A3LL, 0xB3B4B5B60FLL, 0xB3B4B5B605LL};
const uint64_t PTXpipe = wAddress[ COMPONENT - 1 ];   // Pulls the address from the above array for this node's pipe



unsigned long code_timer,i=0;
char text[32];
int valOld=LOW;

// the remote control
#if (COMPONENT==1)




  void setup() {
    //Serial.begin(9600); // lcd library doesn't seem to like Serial?
    pinMode(9,INPUT);
    lcd.begin(16,2);
  
    radio.begin();
    radio.setPALevel(RF24_PA_MIN); // "short range setting" - increase if you want more range AND have a good power supply
    radio.setChannel(108);         // the higher channels tend to be more "open"

    radio.openReadingPipe(1,wAddress[1]); // address of receiver*/
    radio.openReadingPipe(2,wAddress[2]); // address of receiver*/

    code_timer=millis();
  }






  void loop() {
    unsigned long timer1,timer2,timer3;
    bool sync_flag=false;
    uint8_t pipe_num;
    int val=digitalRead(9);


    // sync clocks++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if((val==HIGH) && (valOld==LOW)) {
      radio.stopListening();
      timer1=millis();
      sprintf(text,"%02d%ld",1,timer1);
      radio.openWritingPipe(wAddress[1]); // communication between remote and detector 1
      radio.write(&text,sizeof(text));
      //radio.openWritingPipe(wAddress[2]); // communication between remote and detector 2
      //radio.write(&text,sizeof(text));
      sync_flag=true;
      radio.startListening(); // set as receiver
      delay(100);
    }
    //------------------------------------------------------------------------------------



    if(sync_flag) {
      //while(!radio.available());
      while(radio.available(&pipe_num)) {
        radio.read(&text,sizeof(text));
      
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("He");
        lcd.print(text);
        lcd.print(" ");
        lcd.print(pipe_num);
        delay(1000);
        lcd.clear();
      }
    } 
    //-------------------------------------------------------

    valOld=val;

  }
#endif






// the detectors:

#if (COMPONENT>=2)
  void setup() {
    Serial.begin(9600);
    pinMode(2,OUTPUT);
    digitalWrite(2,HIGH);


    
    radio.begin();
    radio.setPALevel(RF24_PA_MIN); // "short range setting" - increase if you want more range AND have a good power supply
    radio.setChannel(108);         // the higher channels tend to be more "open"
    /*radio.openWritingPipe(wAddress[0]); // communication between this detector and remote */
    radio.openReadingPipe(1,wAddress[1]); // address of receiver
    radio.startListening(); // set as receiver*/
    code_timer=millis();
  }

  void loop() {
    unsigned long ref_time;
    bool read_flag=false;
    bool gate_flag;
    uint8_t pipe_num;

    // read photo-diode signal
    int val=analogRead(A7);
    gate_flag=(val >= 900) ? true : false;
    
    // set LED value to high if laser is detected, low if not
    if(gate_flag) digitalWrite(2,HIGH);
    else digitalWrite(2,LOW);

    // read the reference time+++++++++++++++++++++++++++++++
    if(radio.available(&pipe_num)) {
      radio.read(&text,sizeof(text));
      ref_time=atol(&text[2]);
      Serial.print(ref_time);
      Serial.print(" ");
      Serial.println(pipe_num);
      read_flag=true;
    }
    //-------------------------------------------------------



    // write code back to remote+++++++++++++++++++++++++++++
    if(read_flag) {
      //delay(100);
      radio.stopListening();
      radio.openWritingPipe(wAddress[COMPONENT-1]);
     // check if gates are closed
     if((read_flag) && (gate_flag) ) {
      // write back to remote control
      sprintf(text,"%02d",2);
     } else if((read_flag) && (!gate_flag))  {
      // write back to remote control
      sprintf(text,"%02d",3);
     }
     radio.write(&text,sizeof(text));
     radio.startListening();
    }
    //-------------------------------------------------------
    


  }
#endif

