import RPi.GPIO as GPIO
import requests
import time

api_key = " "
#channel_id = " "

LDR_PIN = 7
LED_PIN = 13

GPIO.setmode(GPIO.BOARD)
GPIO.setup(LDR_PIN, GPIO.IN)
GPIO.setup(LED_PIN, GPIO.OUT)

try:
    while True:
        ldr_value = GPIO.input(LDR_PIN)
        GPIO.output(LED_PIN, ldr_value)
        params = {'api_key': api_key, 'field1': ldr_value}
        try:
            response = requests.get(f"https://api.thingspeak.com/update", params=params)
            print(f"LDR Value: {ldr_value}, LED State: {'ON' if ldr_value else 'OFF'}, Response: {response.text}")
        except Exception as e:
            print("Failed to update ThingSpeak:", e)
        time.sleep(5)
except KeyboardInterrupt:
    GPIO.cleanup()
finally:
    GPIO.cleanup()



program 7---> water sensor

import RPi.GPIO as GPIO
import smtplib
from email.mime.text import MIMEText
import time

EMAIL_ADDRESS = ''  
EMAIL_PASSWORD = ''  
TO_EMAIL = ''    

SENSOR_PIN = 11  
BUZ_PIN = 13    

GPIO.setmode(GPIO.BOARD)
GPIO.setup(SENSOR_PIN, GPIO.IN)
GPIO.setup(BUZ_PIN, GPIO.OUT)

def send_email():
    msg = MIMEText('Rain/Water detected!')
    msg['Subject'] = 'Alert: Rain/Water Detected'
    msg['From'] = EMAIL_ADDRESS
    msg['To'] = TO_EMAIL

    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
            server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
            server.send_message(msg)
            print("Email sent successfully")
    except Exception as e:
        print(f"Failed to send email: {e}")

try:
    print("Rain/Water Sensor Test")
    time.sleep(2)  
    print("Ready")

    while True:
        if not GPIO.input(SENSOR_PIN):  
            print("Rain/Water detected!")
            GPIO.output(BUZ_PIN, GPIO.HIGH)
            send_email()
            time.sleep(5)  
        else:
            GPIO.output(BUZ_PIN, GPIO.LOW)  

except KeyboardInterrupt:
    print("Program terminated")
finally:
    GPIO.cleanup()


    import time
import adafruit_dht
import board

dht = adafruit_dht.DHT11(board.D4)  

while True:
   
        temperature = dht.temperature
        humidity = dht.humidity

        print(f'Temperature: {temperature:.1f}C')
        print(f'Humidity: {humidity:.1f}%')

         
   
        time.sleep(2)


        #include<LiquidCrystal_I2C.h>
#include<wire.h>

LiquidCrystal_I2C lcd(0X27,16,2);

void setup(){
  lcd.begin(16,2);
  lcd.backlight();

  lcd.setCursor(0,0);
  lcd.print("System Monitor");
  lcd.setCursor(0,1);
  lcd.print("initializing");
  delay(2000);
}

void loop(){
  float networkutilization=getNetworkUtilization();
  float cpuload=getCpuload();
  float diskspace=getdiskspace();
  lcd.setCursor(0,0);
  lcd.print("network utilization : ");
  lcd.print(networkutilization);
  lcd.print("%");
  lcd.setCursor(0,1);
  lcd.print("CPU");
  lcd.print(cpuload);
  lcd.print("% disk");
  lcd.print(diskspace);
  lcd.print("GB");
  delay(5000);
}

float getNetworkUtilization(){
  return 50.5;
}
float getCpuload(){
  return 36.2;
}
float getdiskspace(){
  return 27.2;
}
