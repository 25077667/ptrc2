// https://swf.com.tw/?p=712

#include <SoftwareSerial.h> 

SoftwareSerial BT(8, 9);

void setup() { 
  Serial.begin(9600); //Arduino Baud 9600 
  BT.begin(9600); //hc-05 Baud 38400
}

void loop() {
  char val; 
  // 若收到「序列埠監控視窗」的資料，則送到藍牙模組
  if (Serial.available()) {
    const auto s = Serial.readString();
    Serial.println(s);
    BT.println(s);
  }

  // 若收到藍牙模組的資料，則送到「序列埠監控視窗」
  if (BT.available()) {
    val = BT.read();
    Serial.println((int)val);
  }
}