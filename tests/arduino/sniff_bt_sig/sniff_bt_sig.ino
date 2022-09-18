// This is an arduino Node MCU v3
// Which is designed for sniff the original ptrc app
#include <BluetoothSerial.h>

namespace DEFAULTS
{
    const uint16_t BAUD_RATE = 9600;
    const char *BT_NAME = "AAAAA";
};
// Global variables

BluetoothSerial BT;

void setup()
{
    Serial.begin(DEFAULTS::BAUD_RATE);
    BT.begin(DEFAULTS::BAUD_RATE);
    BT.begin(DEFAULTS::BT_NAME);
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