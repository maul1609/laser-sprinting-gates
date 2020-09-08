

// SimpleRxAckPayload- the slave or the receiver

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

#define CE_PIN   7
#define CSN_PIN 8

const byte thisSlaveAddress[5] = {'R','x','A','A','A'};
//const byte thisSlaveAddress[5] = {'R','x','A','A','B'};

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

    pinMode(2,OUTPUT);
    digitalWrite(2,HIGH);

    Serial.begin(9600);

    Serial.println("SimpleRxAckPayload Starting");
    radio.begin();
    //radio.setDataRate( RF24_250KBPS );
    radio.setPALevel(RF24_PA_MIN); // "short range setting" - increase if you want more range AND have a good power supply

    radio.openReadingPipe(1, thisSlaveAddress);

    radio.enableAckPayload();
    radio.writeAckPayload(1, &ackData, sizeof(ackData)); // pre-load data

    radio.startListening();
}

//==========

void loop() {

    // read photo-diode signal
    int val=analogRead(A7);
    gate_flag=(val >= 1000) ? true : false;
    
    // set LED value to high if laser is detected, low if not
    if(gate_flag) { 
      digitalWrite(2,HIGH);
    }
    else digitalWrite(2,LOW);


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

void getData() {
    char str1[2];
    if ( radio.available() ) {
        timer_local_sync=millis();
        
        radio.read( &dataReceived, sizeof(dataReceived) );
        str1[0]=dataReceived[0];
        str1[1]=dataReceived[1];
        
        message_code=atol(str1);
        if(message_code==0) {
          Serial.println(message_code);
          timer_sync=atol(&dataReceived[2]);
          reset_flag=true;
          Serial.println(dataReceived);
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
        Serial.print("Data received ");
        Serial.println(dataReceived);
        Serial.print(" ackPayload sent ");
        Serial.print(ackData[0]);
        Serial.print(", ");
        Serial.println(ackData[1]);
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
    ackData[2]=(long)gate_open_timer-(long)timer_local_sync;
    radio.writeAckPayload(1, &ackData, sizeof(ackData)); // load the payload for the next time
}
