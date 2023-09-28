const int potPin = 34;     // Pin para el potenciómetro
const int ledRojo = 2; // pin para led rojo
const int ledAzul = 5; //pin para led azul
const int ledVerde = 33; // pin para led verde
int estadoLedAzul = 0;
int estadoLedRojo = 0;
unsigned long botLastScan;
const unsigned long botMTBS = 1000; //mean time between scan messages
template<class T> inline Print &operator <<(Print &obj, T arg) { obj.print(arg); return obj; }
int intensidadPotenciometro = 0;
#include <CTBot.h>
#include <CTBotDataStructures.h>
#include <CTBotDefines.h>
#include <CTBotInlineKeyboard.h>
#include <CTBotReplyKeyboard.h>
#include <CTBotSecureConnection.h>
#include <CTBotStatusPin.h>
#include <CTBotWifiSetup.h>
#include <Utilities.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>
#include <ArduinoJson.h>
#include <ArduinoJson.hpp>
#include "DHT.h"
#include <Adafruit_Sensor.h>

// Configuración del sensor DHT
#define DHTPIN 26  // Pin de datos del sensor DHT
#define DHTTYPE DHT22  // Tipo de sensor DHT (DHT11 o DHT22)

DHT dht(DHTPIN, DHTTYPE);
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define BAUDRATE 115200
Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire);

CTBot miBot;

#include "token.h"


void displayInit(){
  display.begin(0x3C, true); // Address 0x3C default
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.setCursor(0,0);
  display.display();
}


void setup() {
  Serial.begin(115200);
  Serial.print("Iniciando Bot de Telegram");

  miBot.wifiConnect(ssid, password);
  miBot.setTelegramToken(token);

  // Inicializar comunicación con el display
  Serial.begin(BAUDRATE);
  Serial.print("\nIniciando Display...");
  displayInit();  
  if (miBot.testConnection()) {
    Serial.println("\nConectado");
  }
  else {
    Serial.println("\n No resultó bien");
  }
  // Inicializar sensores y pines de LED
  dht.begin();
  pinMode(ledRojo, OUTPUT); 
  pinMode(ledAzul, OUTPUT);
  pinMode(ledVerde, OUTPUT);

}

void loop() {
  TBMessage msg;
  if (millis() - botLastScan > botMTBS){
    if (CTBotMessageText == miBot.getNewMessage(msg)) {
      // Procesar el mensaje
      display.clearDisplay();
      display.setCursor(0, 0);
      // Mostrar el mensaje en la pantalla OLED
      display.print("Mensaje de Telegram:");
      display.println(msg.text);
      if (msg.text == "/LeerPotenciometro"){
        int potValue = analogRead(potPin);
        // Ajustar la intensidad del LED rojo según el potenciómetro
        intensidadPotenciometro = map(potValue, 0, 4095, 0, 100);
        display.print("Valor del potenciómetro: ");
        display.println(String(intensidadPotenciometro) + "%");
        // Enviar la intensidad del potenciómetro como respuesta al mensaje de Telegram
        String responseMessage = "Valor del potenciómetro: " + String(intensidadPotenciometro) + "%";
        miBot.sendMessage(msg.sender.id, responseMessage);
      }
      if (msg.text == "/LeerDHT"){
        // Leer valores del sensor DHT
        float humidity = dht.readHumidity();
        float temperature = dht.readTemperature();
        display.print("Valores DHT: ");
        display.printf("Temperatura: %d°C\tHumedad: %d%\n", (int)temperature, (int)humidity);
        String responseMessage1 = "Valores DHT:\n";
        String responseMessage2 = "Temperatura: " + String(temperature) + " grados" + " - Humedad: " + String(humidity) + "%";
        String responseMessage = responseMessage1 + responseMessage2;
        miBot.sendMessage(msg.sender.id, responseMessage);
      }
      if (msg.text == "/ApagarLedRojo"){
        int estadoLedRojo = 0;
        digitalWrite(ledRojo, estadoLedRojo);
        miBot.sendMessage(msg.sender.id, "Led rojo apagado");
      }
      if (msg.text == "/ApagarLedAzul"){
        int estadoLedAzul = 0;
        digitalWrite(ledAzul, estadoLedAzul);
        miBot.sendMessage(msg.sender.id, "Led azul apagado");
      }
      if (msg.text == "/EncenderLedRojo"){
        int estadoLedRojo = 1;
        digitalWrite(ledRojo, estadoLedRojo);
        miBot.sendMessage(msg.sender.id, "Led rojo encendido");
      }
      if (msg.text  == "/EncenderLedAzul"){
        int estadoLedAzul = 1;
        digitalWrite(ledAzul, estadoLedAzul);
        miBot.sendMessage(msg.sender.id, "Led azul encendido");
      }
      if (msg.text == "/IntensidadLedVerde50"){
        analogWrite(ledVerde, 50);
        miBot.sendMessage(msg.sender.id, "Led verde al 50% de intensidad");
      }
      if (msg.text == "/IntensidadLedVerde100"){
        analogWrite(ledVerde, 100);
        miBot.sendMessage(msg.sender.id, "Led verde al 100% de intensidad");
      }
      if (msg.text == "/IntensidadLedVerde0"){
        analogWrite(ledVerde, 0);
        miBot.sendMessage(msg.sender.id, "Led verde al 0% de intensidad");
      }
      if (msg.text == "/start"){
        String mensajeBienvenida = "Menu de opciones:\n\n";
        mensajeBienvenida += "/LeerDHT : leer sendor DHT\n";
        mensajeBienvenida += "/LeerPotenciometro : leer potenciometro\n";
        mensajeBienvenida += "/ApagarLedRojo : apagar led rojo\n";
        mensajeBienvenida += "/ApagarLedAzul : apagar led azul\n";
        mensajeBienvenida += "/EncenderLedRojo : encender led rojo\n";
        mensajeBienvenida += "/EncenderLedAzul : encender led azul\n";
        mensajeBienvenida += "/IntensidadLedVerde50 : intensidad de led verde al 50%\n";
        mensajeBienvenida += "/IntensidadLedVerde100 : intensidad de led verde al 100%\n";
        mensajeBienvenida += "/IntensidadLedVerde0 : intensidad de led verde al 0%\n";
        display.print(mensajeBienvenida);
        miBot.sendMessage(msg.sender.id, mensajeBienvenida);
      }
    }
    botLastScan = millis();
    display.display();
  }
}
