// MultiTxAckPayload - the master or the transmitter
//   works with two Arduinos as slaves
//     each slave should the SimpleRxAckPayload program
//       one with the adress {'R','x','A','A','A'}
//         and the other with {'R','x','A','A','B'}

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

#include <LiquidCrystal.h>
LiquidCrystal lcd(1,0,5,4,3,2);

#define CE_PIN   7
#define CSN_PIN 8

#define SERIAL false

const byte numSlaves = 2;
const byte slaveAddress[numSlaves][5] = {
        // each slave needs a different address
                            {'R','x','A','A','A'},
                            {'R','x','A','A','B'}
                        };

RF24 radio(CE_PIN, CSN_PIN); // Create a Radio

//~ char dataToSend[10] = "Message 0";
char dataToSend[32] = "ToSlvN  0";
char txNum = '0';
long int ackData[3] = {-1, -1,-1}; // to hold the two values coming from the slave
bool newData = false;
bool gates_closed;

unsigned long currentMillis;
unsigned long prevMillis;
unsigned long txIntervalMillis = 1000; // send once per second
unsigned long timer_sync[2],time_slaves[2]; 
int valOld=LOW;

//===============

void setup() {
#if SERIAL
    Serial.begin(9600);
    Serial.println(F("Source File = /mnt/SGT/SGT-Prog/Arduino/ForumDemos/nRF24Tutorial/MultiTxAckPayload.ino "));
    Serial.println("SimpleTxAckPayload Starting");
#endif
#if !(SERIAL)
    lcd.begin(16,2);
#endif    
    pinMode(9,INPUT);

    radio.begin();
    //radio.setDataRate( RF24_250KBPS );
    radio.setPALevel(RF24_PA_MIN); // "short range setting" - increase if you want more range AND have a good power supply

    radio.enableAckPayload();

    radio.setRetries(3,5); // delay, count

    currentMillis = millis();
    prevMillis=currentMillis;
}





//=============

void loop() {
    int val=digitalRead(9);
    bool gates_open;
    char test[2];
    currentMillis = millis();
    
    
    /*dataToSend[0]='0';
    dataToSend[1]='2';
    test[0]=dataToSend[0];
    test[1]=dataToSend[1];
    Serial.println(atol(test));*/
    //if (currentMillis - prevMillis >= txIntervalMillis) {
    if ((val==HIGH) && (valOld==LOW)) {

      
        sync_time_and_receive_gates_closed_status(&gates_closed);
        sync_time_and_receive_gates_closed_status(&gates_closed);

        
#if SERIAL
        if(gates_closed) Serial.println("Ready");
        else Serial.println("Close gates");
#endif        
#if !(SERIAL)
        if(gates_closed) {
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Ready");
        }
        else {
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Close gates");
        }
#endif        

        delay(100);
    }
    valOld=val;




    gates_open = !gates_closed;



    
    // poll until gates open
    if(gates_closed) {
      while(!gates_open) {
        val=digitalRead(9);
        if((val==HIGH) ) break;
  
  
        
        currentMillis = millis();
        if ((currentMillis - prevMillis) >= txIntervalMillis) {
          // poll
          poll_and_receive_time_and_gates_open_status(&gates_open);
#if SERIAL
          Serial.println("");
          Serial.println((int)gates_open);
#endif
          prevMillis=currentMillis;
        }
      }
      gates_closed=false;

      // calculate mm, ss, etc
      unsigned long runMillis=abs((long)time_slaves[1]-(long)time_slaves[0]);
      unsigned long allSeconds=runMillis/1000.;
      int runHours=allSeconds/3600;
      int secsRemaining=allSeconds%3600;
      int runMinutes=secsRemaining/60;
      int runSeconds=secsRemaining%60;
      int runMSeconds=runMillis%1000;
      char buf[21];
      sprintf(buf,"%02d:%02d:%03d",runMinutes,runSeconds,runMSeconds);

      
#if SERIAL
      Serial.println("The time was: ");
      Serial.println((long)time_slaves[1]-(long)time_slaves[0]);
#endif      
#if !(SERIAL)
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("The time was");
      lcd.setCursor(0,1);
      lcd.print(buf);
#endif      
    }    
    // now poll until gate


}

//================






void poll_and_receive_time_and_gates_open_status(bool *gates_open) {

        // call each slave in turn
    for (byte n = 0; n < numSlaves; n++){

            // open the writing pipe with the address of a slave
        radio.openWritingPipe(slaveAddress[n]);

        //timer_sync[n] = millis();
        sprintf(dataToSend,"%02d%ld",1,timer_sync[n]);
        bool rslt;
        rslt = radio.write( &dataToSend, sizeof(dataToSend) );
            // Always use sizeof() as it gives the size as the number of bytes.
            // For example if dataToSend was an int sizeof() would correctly return 2

#if SERIAL
        Serial.print("  ========  For Slave ");
        Serial.print(n);
        Serial.println("  ========");
        Serial.print("  Data Sent ");
        Serial.print(dataToSend);
#endif        
        if (rslt) {
            if ( radio.isAckPayloadAvailable() ) {
                radio.read(&ackData, sizeof(ackData));
                time_slaves[n]=ackData[2];
                newData = true;
                if(n==0) *gates_open=!(bool)ackData[0];
                else *gates_open *=!(bool)ackData[0];
            }
            else {
#if SERIAL
                Serial.println("  Acknowledge but no data ");
#endif
                *gates_open=false;
            }
            updateMessage();
        }
        else {
#if SERIAL
            Serial.println("  Tx failed");
#endif            
            *gates_open=false;
        }
        showData();
#if SERIAL
        Serial.print("\n");
#endif        
    }

 }


//=================

void sync_time_and_receive_gates_closed_status(bool *gates_closed) {

        // call each slave in turn
    for (byte n = 0; n < numSlaves; n++){

            // open the writing pipe with the address of a slave
        radio.openWritingPipe(slaveAddress[n]);

            // include the slave number in the message
        dataToSend[5] = n + '0';
        timer_sync[n] = millis();
        sprintf(dataToSend,"%02d%ld",0,timer_sync[n]);
        bool rslt;
        rslt = radio.write( &dataToSend, sizeof(dataToSend) );
            // Always use sizeof() as it gives the size as the number of bytes.
            // For example if dataToSend was an int sizeof() would correctly return 2

#if SERIAL
        Serial.print("  ========  For Slave ");
        Serial.print(n);
        Serial.println("  ========");
        Serial.print("  Data Sent ");
        Serial.print(dataToSend);
#endif        
        if (rslt) {
        
            if ( radio.isAckPayloadAvailable() ) {
                radio.read(&ackData, sizeof(ackData));
                newData = true;
                if(n==0) *gates_closed=ackData[0];
                else *gates_closed *=ackData[0];
            }
            else {
#if SERIAL
                Serial.println("  Acknowledge but no data ");
#endif                
                *gates_closed=false;
            }
            updateMessage();
        }
        else {
#if SERIAL
            Serial.println("  Tx failed");
#endif            
            *gates_closed=false;
        }
        showData();
#if SERIAL
        Serial.print("\n");
#endif        
    }

 }


//=================

void showData() {
    if (newData == true) {
#if SERIAL
        Serial.print("  Acknowledge data ");
        Serial.print(ackData[0]);
        Serial.print(", ");
        Serial.print(ackData[1]);
        Serial.print(", ");
        Serial.println(ackData[2]);
        Serial.println();
#endif        
        newData = false;
    }
}

//================

void updateMessage() {
        // so you can see that new data is being sent
    txNum += 1;
    if (txNum > '9') {
        txNum = '0';
    }
    dataToSend[8] = txNum;
}

