/*
 * Copyright 2019 <Nicolas Carrier>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include <Arduino.h>
#include <inttypes.h>
#include <Servo.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <WebSocketsServer.h>

static Servo servo;

static const char *kSsid = "esp_robot";
static const char *kPassword = "esp_robot";
static const char *mdns_name = kSsid;
// static const int kHeadPin = D0;
// static const int kLeftWheelPin = D1;
// static const int kRightWheelPin = D2;
static const int kLeftEyePin = D3;
static const int kRightEyePin = D4;
static const int kRefreshPeriod = 42;

static int leftEyeValue = 0;
static int rightEyeValue = 0;
static int leftEyeIncrement = 10;
static int rightEyeIncrement = 10;

static ESP8266WebServer server(80);
static WebSocketsServer web_socket(81);

static void startMdns() {
  MDNS.begin(mdns_name);
  Serial.printf("mDNS responder started: http://%s.local\n", mdns_name);
}

static void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload,
                    size_t lenght) {
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;

    case WStype_CONNECTED: {
      IPAddress ip = web_socket.remoteIP(num);
      Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0],
                    ip[1], ip[2], ip[3], payload);
    }
      break;

    case WStype_TEXT:
      Serial.printf("[%u] get Text: %s\n", num, payload);
      break;

    default:
      Serial.printf("unhandled websocket event type %d\n", type);
  }
}

static void startWebSocket() {
  web_socket.begin();
  web_socket.onEvent(webSocketEvent);
  Serial.println("WebSocket server started.");
}

static String getContentType(String file_name) {
  if (file_name.endsWith(".html"))
    return "text/html";
  else if (file_name.endsWith(".css"))
    return "text/css";
  else if (file_name.endsWith(".js"))
    return "application/javascript";
  else if (file_name.endsWith(".ico"))
    return "image/x-icon";
  else if (file_name.endsWith(".gz"))
    return "application/x-gzip";
  return "text/plain";
}

static bool handleFileRead(String path) {
  Serial.printf("handleFileRead: %s\n", path.c_str());
  if (path.endsWith("/"))
    path += "index.html";
  String pathWithGz = path + ".gz";
  bool with_gz = SPIFFS.exists(pathWithGz);
  if (with_gz || SPIFFS.exists(path))
    if (with_gz)
      path = pathWithGz;
  if (SPIFFS.exists(path)) {
    File file = SPIFFS.open(path, "r");
    server.streamFile(file, getContentType(path));
    file.close();
    return true;
  }
  Serial.println("\tFile Not Found");

  return false;
}

void setup() {
  Serial.println(WL_CONNECTED);
  servo.attach(D0, 610, 2470);
  pinMode(kLeftEyePin, OUTPUT);
  pinMode(kRightEyePin, OUTPUT);
  Serial.begin(115200);
  WiFi.softAP(kSsid, kPassword);
  SPIFFS.begin();
  startMdns();
  startWebSocket();
  Serial.printf("Connected to %s \n", kSsid);
  Serial.printf("IP address: ");
  Serial.println(WiFi.softAPIP());
  server.onNotFound([]() {
        if (!handleFileRead(server.uri()))
          server.send(404, "text/plain", "404: Not Found");
      });
  server.begin();
  Serial.println("Web server started!");
}

static void updateEyes() {
  leftEyeValue += leftEyeIncrement;
  rightEyeValue += rightEyeIncrement;
  if (leftEyeValue >= 255 || leftEyeValue <= 0) {
    leftEyeValue = leftEyeValue <= 0 ? 0 : 255;
    leftEyeIncrement *= -1;
  }
  if (rightEyeValue >= 255 || rightEyeValue <= 0) {
    rightEyeValue = rightEyeValue <= 0 ? 0 : 255;
    rightEyeIncrement *= -1;
  }
  analogWrite(kLeftEyePin, leftEyeValue);
  analogWrite(kRightEyePin, rightEyeValue);
}

void loop() {
  unsigned long current_time = millis(); // NOLINT
  static unsigned long previous_time = current_time; // NOLINT
  unsigned long elapsed = current_time - previous_time; // NOLINT
  int64_t sleep_duration = kRefreshPeriod - (int64_t)elapsed;
  if (sleep_duration > 0)
    delay(sleep_duration);
  previous_time = current_time;

  server.handleClient();
  MDNS.update();
  updateEyes();
//  servo.write(0);
}
