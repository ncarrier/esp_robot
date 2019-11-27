#include <Arduino.h>
#include <inttypes.h>
#include <Servo.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <WebSocketsServer.h>

Servo servo;

const char* ssid = "esp_robot";
const char* password = "esp_robot";

ESP8266WebServer server(80);
WebSocketsServer webSocket(81);
const char* mdnsName = "esp_robot";

void html_index(void) {
  server.send(200, "text/html", "<html><head></head><body><p>Hello world!</p></body></html>");
}


void startMDNS() { // Start the mDNS responder
  MDNS.begin(mdnsName);                        // start the multicast domain name server
  Serial.print("mDNS responder started: http://");
  Serial.print(mdnsName);
  Serial.println(".local");
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t lenght) { // When a WebSocket message is received
  switch (type) {
    case WStype_DISCONNECTED:             // if the websocket is disconnected
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    case WStype_CONNECTED: {              // if a new websocket connection is established
        IPAddress ip = webSocket.remoteIP(num);
        Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);
//        rainbow = false;                  // Turn rainbow off when a new connection is established
      }
      break;
    case WStype_TEXT:                     // if new text data is received
      Serial.printf("[%u] get Text: %s\n", num, payload);
//      if (payload[0] == '#') {            // we get RGB data
//        uint32_t rgb = (uint32_t) strtol((const char *) &payload[1], NULL, 16);   // decode rgb data
//        int r = ((rgb >> 20) & 0x3FF);                     // 10 bits per color, so R: bits 20-29
//        int g = ((rgb >> 10) & 0x3FF);                     // G: bits 10-19
//        int b =          rgb & 0x3FF;                      // B: bits  0-9
//
//        analogWrite(LED_RED,   r);                         // write it to the LED output pins
//        analogWrite(LED_GREEN, g);
//        analogWrite(LED_BLUE,  b);
//      } else if (payload[0] == 'R') {                      // the browser sends an R when the rainbow effect is enabled
//        rainbow = true;
//      } else if (payload[0] == 'N') {                      // the browser sends an N when the rainbow effect is disabled
//        rainbow = false;
//      }
//      break;
  }
}

void startWebSocket() { // Start a WebSocket server
  webSocket.begin();                          // start the websocket server
  webSocket.onEvent(webSocketEvent);          // if there's an incomming websocket message, go to function 'webSocketEvent'
  Serial.println("WebSocket server started.");
}

void setup() {
  Serial.println(WL_CONNECTED);
  servo.attach(D0, 610, 2470);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  analogWrite(D1, 0); // R
  analogWrite(D2, 0); // B
  analogWrite(D3, 255); // V
  Serial.begin(115200);
  WiFi.softAP(ssid, password); //begin WiFi access point
  startMDNS();
  startWebSocket();
  Serial.println("");

  // Wait for connection
//  while (WiFi.status() != WL_CONNECTED) {
//    delay(500);
//    Serial.print(WiFi.status());
//  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.softAPIP());
  server.on("/", html_index);
  server.begin();
  Serial.println("Web server started!");
}

int sensorValue;
int outputValue;

struct rgb {
    double r;       // a fraction between 0 and 1
    double g;       // a fraction between 0 and 1
    double b;       // a fraction between 0 and 1
};

struct hsv {
    double h;       // angle in degrees
    double s;       // a fraction between 0 and 1
    double v;       // a fraction between 0 and 1
};

struct rgb hsv2rgb(struct hsv in)
{
    double      hh, p, q, t, ff;
    long        i;
    rgb         out;

    if(in.s <= 0.0) {       // < is bogus, just shuts up warnings
        out.r = in.v;
        out.g = in.v;
        out.b = in.v;
        return out;
    }
    hh = in.h;
    if(hh >= 360.0) hh = 0.0;
    hh /= 60.0;
    i = (long)hh;
    ff = hh - i;
    p = in.v * (1.0 - in.s);
    q = in.v * (1.0 - (in.s * ff));
    t = in.v * (1.0 - (in.s * (1.0 - ff)));

    switch(i) {
    case 0:
        out.r = in.v;
        out.g = t;
        out.b = p;
        break;
    case 1:
        out.r = q;
        out.g = in.v;
        out.b = p;
        break;
    case 2:
        out.r = p;
        out.g = in.v;
        out.b = t;
        break;

    case 3:
        out.r = p;
        out.g = q;
        out.b = in.v;
        break;
    case 4:
        out.r = t;
        out.g = p;
        out.b = in.v;
        break;
    case 5:
    default:
        out.r = in.v;
        out.g = p;
        out.b = q;
        break;
    }
    out.r *= 255.;
    out.g *= 255.;
    out.b *= 255.;
    
    return out;     
}

struct hsv hsv = {
  .h = 0.,
  .s = 1.,
  .v = 1.,
};

struct rgb rgb;

void loop() {
  server.handleClient();
//  delay(10);
//  sensorValue = analogRead(A0);
//  Serial.print("sensor = ");
//  Serial.println(sensorValue);
//  outputValue = map(sensorValue, 0, 1024, 0, 359);
//  Serial.print("output = ");
//  Serial.println(outputValue);
//  hsv.h = outputValue;
//  rgb = hsv2rgb(hsv);
//  analogWrite(D1, rgb.r); // R
//  analogWrite(D2, rgb.b); // B
//  analogWrite(D3, rgb.g); // V
//  servo.write(0);
//  delay(1000);
//  servo.write(180);
//  delay(1000);
}
