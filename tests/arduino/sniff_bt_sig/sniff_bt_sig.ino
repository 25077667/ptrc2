// This is an arduino Node MCU v3
// Which is designed for sniff the original ptrc app
#include <BluetoothSerial.h>
#include <esp_bt_device.h>

namespace DEFAULTS
{
    const uint32_t BAUD_RATE = 115200;
    const char *BT_NAME = "AAAAA";
};
// Global variables

BluetoothSerial BT;

void show_bt_mac();

void setup()
{
    Serial.begin(DEFAULTS::BAUD_RATE);
    BT.begin(DEFAULTS::BAUD_RATE);
    BT.begin(DEFAULTS::BT_NAME);

    // Show BT Mac Address in Serial
    show_bt_mac();
}

void loop()
{
    if (BT.available())
    {
        // print entire string what for receiving
        String str = BT.readString();
        Serial.println(str);
    }
}

void show_bt_mac() {
  // https://www.dfrobot.com/blog-870.html
  const uint8_t* point = esp_bt_dev_get_address();
 
  for (int i = 0; i < 6; i++) {
    char str[3];
 
    sprintf(str, "%02X", (int)point[i]);
    Serial.print(str);
 
    if (i < 5){
      Serial.print(":");
    }
  }
}


