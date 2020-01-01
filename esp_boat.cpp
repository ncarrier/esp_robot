#include <Servo.h>

int en_pin = 11;
int rudder_pin = 10;

int value = 170;
int increment = 10;

Servo rudder;


void setup() {
  pinMode(en_pin, OUTPUT);
  Serial.begin(115200);
  rudder.attach(rudder_pin);
}

void loop() {
  delay(300);
  // handle motor
  if (0) {
    value += increment;
    if (value == 250 || value == 40)
      increment *= -1;
    analogWrite(en_pin, value);
    Serial.println(value);
  } else {
  // handle propeller
  if (0)
    {
    rudder.write(value);
    value += increment;
    if (value == 180 || value == 0)
      increment *= -1;
    analogWrite(rudder_pin, value);
    Serial.println(value);
    }
  }
//  rudder.write(90);
}
