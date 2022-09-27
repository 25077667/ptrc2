// https://swf.com.tw/?p=712

#include <SoftwareSerial.h> 

SoftwareSerial BT(8, 9);

void setup() { 
  Serial.begin(9600); //Arduino Baud 9600 
  BT.begin(9600); //hc-05 Baud 38400
}

void loop() {
    if (BT.available())
    {
        // print entire string what for receiving
        char c = BT.read();
        Serial.println((int)c);
    }
}