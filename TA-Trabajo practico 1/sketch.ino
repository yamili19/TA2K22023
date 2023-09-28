//#include <Adafruit_SSD1306.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>
#include <splash.h>

#include "config.h"
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define BAUDRATE 9600
Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire);

const int buttonPin = 2;   // Pin para el pulsador
const int blueLedPin = 13;  // Pin para el LED azul
const int redLedPin = 12;   // Pin para el LED rojo
const int greenLedPin = 14; // Pin para el LED verde
const int potPin = 34;     // Pin para el potenciómetro

//const int displaySDAPin = 21;  // Pin SDA para el display
//const int displaySCLPin = 22;  // Pin SCL para el display

int ledRedIntensity = 0;
int relayState = LOW;
int buttonPressCount = 0;
int lastRelayState = LOW;
int lastRedIntensity = 0;
int estadoLed = LOW; // Estado del LED   
int estadoBoton; // Estado del pulsador
int ultimoEstado = HIGH; // Estado anterior del pulsador   
unsigned long ultimoRebote = 0; // Último tiempo de rebote del pulsador
int delayRebote = 50; // Tiempo de rebote del pulsador

void displayInit(){
  display.begin(0x3C, true); // Address 0x3C default
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.setCursor(0,0);
  display.display();
}


void setup() {
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(blueLedPin, OUTPUT);
  pinMode(redLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);
  
  // Inicializar comunicación con el display
  Serial.begin(BAUDRATE);
  Serial.println(F("Iniciando Display..."));
  displayInit();  
}

void loop() {

  int lectura = digitalRead(buttonPin);
  // Si el estado del pulsador ha cambiado, registrar el tiempo de rebote
  if (lectura != ultimoEstado) {
    ultimoRebote = millis();
  }

  // Si ha pasado suficiente tiempo desde el último rebote, actualizar el estado del pulsador
  if ((millis() - ultimoRebote) > delayRebote) {
    // Si el estado del pulsador ha cambiado, actualizar el estado del LED
    if (lectura != estadoBoton) {
      estadoBoton = lectura;
      // Si el pulsador ha sido presionado, cambiar el estado del LED
      if (estadoBoton == HIGH) {
        estadoLed = !estadoLed;
        digitalWrite(blueLedPin, estadoLed);
        buttonPressCount ++;
      }
    }
  }
  // Guardar el último estado del pulsador
  ultimoEstado = lectura;
  // Leer el valor del potenciómetro
  int potValue = analogRead(potPin);
  
  // Ajustar la intensidad del LED rojo según el potenciómetro
  ledRedIntensity = map(potValue, 0, 4095, 0, 100);
  analogWrite(redLedPin, ledRedIntensity * 255 / 100);
  lastRedIntensity = ledRedIntensity;
  
  // Controlar el relé según la posición del potenciómetro
  if (potValue > 2048) {
    relayState = HIGH;
  } else {
    relayState = LOW;
    lastRelayState = relayState;
  }

  // Actualizar el estado del LED verde
  digitalWrite(greenLedPin, relayState);

  // Actualizar el display
  display.clearDisplay();
  display.setCursor(0, 0);
  display.print("Pulsador: ");
  display.println(buttonPressCount);
  display.print("Led A: ");
  display.println(estadoLed ? "Encendido" : "Apagado");
  display.print("Led R: ");
  display.print(ledRedIntensity);
  display.println("% de potencia");
  display.print("Led V: ");
  display.println(relayState ? "Encendido" : "Apagado");
  display.display();
}

