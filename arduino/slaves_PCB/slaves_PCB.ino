

// SimpleRxAckPayload- the slave or the receiver
#include <avr/wdt.h>

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

#define CE_PIN   7
#define CSN_PIN 8

#define SERIAL false

#define SERIAL_NO 1
#define GATE 0

#if SERIAL_NO==0
#if GATE==0
const byte thisSlaveAddress[5] = {'R','x','A','C','C'}; // gate 0
#else
const byte thisSlaveAddress[5] = {'R','x','A','B','B'}; // gate 1
#endif
#endif

#if SERIAL_NO==1
#if GATE==0
const byte thisSlaveAddress[5] = {'R','x','A','A','A'}; // gate 0
#else
const byte thisSlaveAddress[5] = {'R','x','A','A','B'}; // gate 1
#endif
#endif


RF24 radio(CE_PIN, CSN_PIN);

char dataReceived[32]; // this must match dataToSend in the TX
long int ackData[3] = {109, -4000, -10000}; // the two values to be sent to the master
bool newData = false;
bool gate_flag, gate_flag_old=true;
unsigned long timer_sync,gate_open_timer,timer_local_sync;
long message_code;
bool reset_flag=false;
//==============



void setup() {

    pinMode(A5,OUTPUT);
    digitalWrite(A5,HIGH);
#if SERIAL
    Serial.begin(9600);

    Serial.println("SimpleRxAckPayload Starting");
#endif

    radio.begin();
    radio.setChannel(120);
    //radio.setAutoAck(false);
#if SERIAL_NO==0
    radio.setPALevel(RF24_PA_MIN); // "short range setting" - increase if you want more range AND have a good power supply
    radio.setDataRate( RF24_250KBPS );
#endif

#if SERIAL_NO==1
    radio.setDataRate( RF24_1MBPS );
#endif

    radio.openReadingPipe(1, thisSlaveAddress);

    radio.enableAckPayload();
    radio.writeAckPayload(1, &ackData, sizeof(ackData)); // pre-load data

    radio.startListening();
    //reset1();
}

//==========

void loop() {

    // read photo-diode signal
    int val=analogRead(A0);
    gate_flag=(val >= 950) ? true : false;
    
    // set LED value to high if laser is detected, low if not
    if(gate_flag) { 
      digitalWrite(A5,HIGH);
    }
    else {
      digitalWrite(A5,LOW);
    }


    if(gate_flag==false && gate_flag_old==true && reset_flag==true) {
      gate_open_timer=millis();
      reset_flag=false;
    }
    //Serial.println(reset_flag);

    
    getData();
    showData();
    gate_flag_old=gate_flag;
}

//============

// get data from the master
void getData() {
    char str1[2];
    unsigned long test = millis();
    if ( radio.available() ) {
        
        radio.read( &dataReceived, sizeof(dataReceived) );
        str1[0]=dataReceived[0];
        str1[1]=dataReceived[1];
        
        message_code=atol(str1);
        if(message_code==0) {
          
          timer_local_sync=test; // this is when the sync signal is received on the slave
#if SERIAL
          Serial.println(message_code);
#endif
          timer_sync=atol(&dataReceived[2]); // this is when the sync signal is sent (on the master)
          reset_flag=true;
#if SERIAL          
          Serial.println(dataReceived);
#endif
        } else if(message_code==1) {
          // send the time the gate was opened 
          
        }
        updateReplyData();
        newData = true;
    }
}

//================

void showData() {
    if (newData == true) {
#if SERIAL      
        Serial.print("Data received ");
        Serial.println(dataReceived);
        Serial.print(" ackPayload sent ");
        Serial.print(ackData[0]);
        Serial.print(", ");
        Serial.println(ackData[1]);
#endif        
        newData = false;
    }
}

//================

void updateReplyData() {
    ackData[0] -= 1;
    ackData[1] -= 1;
    if (ackData[0] < 100) {
        ackData[0] = 109;
    }
    if (ackData[1] < -4009) {
        ackData[1] = -4000;
    }
    ackData[0]=((long)gate_flag)*((long)reset_flag);
    ackData[1]=(long)timer_sync;
    ackData[2]=(long)gate_open_timer-(long)timer_local_sync; // this is how long gate was closed for
    radio.writeAckPayload(1, &ackData, sizeof(ackData)); // load the payload for the next time
}

void reset1()
{
  // enable the watchdog timer. This will wake up the board after 120ms
  wdt_enable(WDTO_120MS);
  
  // go to deep sleep
  if (true)
  {
    SMCR |= (1 << 2); // power down mode
    SMCR |= 1;        // enable sleep;
    __asm__ __volatile__("sleep");
  }    
}
