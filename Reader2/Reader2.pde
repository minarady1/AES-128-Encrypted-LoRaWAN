/*  
 *  ------------ [GP_02] - CO2 ------------
 *  
 *  Explanation: This is the basic code to manage and read the carbon dioxide
 *  (CO2) gas sensor. The concentration and the enviromental variables will be
 *  stored in a frame. Cycle time: 5 minutes
 *  
 *  Copyright (C) 2015 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify  
 *  it under the terms of the GNU General Public License as published by  
 *  the Free Software Foundation, either version 3 of the License, or  
 *  (at your option) any later version.  
 *   
 *  This program is distributed in the hope that it will be useful,  
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of  
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
 *  GNU General Public License for more details.  
 *   
 *  You should have received a copy of the GNU General Public License  
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
 * 
 *  Version:           0.2
 *  Design:            David Gascón 
 *  Implementation:    Alejandro Gállego
 */

#include <WaspSensorGas_Pro.h>
#include <WaspFrame.h>
#include <WaspLoRaWAN.h>

/*
 * Define object for sensor: CO2
 * Input to choose board socket. 
 * Waspmote OEM. Possibilities for this sensor:
 * 	- SOCKET_1 
 * P&S! Possibilities for this sensor:
 * 	- SOCKET_A
 * 	- SOCKET_B
 * 	- SOCKET_C
 * 	- SOCKET_F
 */

 // define radio settings
//////////////////////////////////////////////

uint8_t power = 15;
uint32_t frequency;
char spreading_factor[] = "sf12";
char coding_rate[] = "4/5";
uint16_t bandwidth = 125;
char crc_mode[] = "on";

//////////////////////////////////////////////
uint8_t socket = SOCKET0;

Gas CO2(SOCKET_A);
char node_ID[] = "01";

float concentration;	// Stores the concentration level in ppm
float temperature;	// Stores the temperature in ºC
float humidity;		// Stores the realitve humidity in %RH
float pressure;		// Stores the pressure in Pa
uint8_t error;

void setup()
{
    USB.println(F("CO2 example"));
    // Set the Waspmote ID
    frame.setID(node_ID); 
    error = radioModuleSetup();
  
  // Check status
  if (error == 0)
  {
    USB.println(F("Module configured OK"));     
  }
  else 
  {
    USB.println(F("Module configured ERROR"));     
  }  

}	


void loop()
{		
    ///////////////////////////////////////////
    // 1. Power on  sensors
    ///////////////////////////////////////////  

    // Power on the CO2 sensor. 
    // If the gases PRO board is off, turn it on automatically.
    CO2.ON();

    // CO2 gas sensor needs a warm up time at least 60 seconds	
    // To reduce the battery consumption, use deepSleep instead delay
    // After 1 minute, Waspmote wakes up thanks to the RTC Alarm
    USB.println(F(" Sleep 1 mins"));
error = LoRaWAN.sendRadio("1111111111");
    PWR.deepSleep("00:00:01:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
    USB.println(F("Jut Woke up from 1 mins"));
    error = LoRaWAN.sendRadio("1111111112");
   if (error == 0)
  {
    USB.println(F("--> Packet sent OK"));
    for (int i =0;i<1;i++)
    {
      Utils.blinkLEDs(1000);
    }
  }


    ///////////////////////////////////////////
    // 2. Read sensors
    ///////////////////////////////////////////  

    // Read the CO2 sensor and compensate with the temperature internally
    concentration = CO2.getConc();

    // Read enviromental variables
    temperature = CO2.getTemp();
    humidity = CO2.getHumidity();
    pressure = CO2.getPressure();

    // And print the values via USB
    USB.println(F("***************************************"));
    USB.print(F("Gas concentration: "));
    USB.print(concentration);
    USB.println(F(" ppm"));
    USB.print(F("Temperature: "));
    USB.print(temperature);
    USB.println(F(" Celsius degrees"));
    USB.print(F("RH: "));
    USB.print(humidity);
    USB.println(F(" %"));
    USB.print(F("Pressure: "));
    USB.print(pressure);
    USB.println(F(" Pa"));


    ///////////////////////////////////////////
    // 3. Power off sensors
    ///////////////////////////////////////////  

    // Power off the CO2 sensor. If there aren't more gas sensors powered,
    // turn off the board automatically
    CO2.OFF();


    ///////////////////////////////////////////
    // 4. Create ASCII frame
    /////////////////////////////////////////// 

    // Create new frame (ASCII)
    frame.createFrame(ASCII);

    // Add CO2 concentration
    frame.addSensor(SENSOR_GP_CO2, concentration);
    // Add temperature
    frame.addSensor(SENSOR_GP_TC, temperature);
    // Add humidity
    frame.addSensor(SENSOR_GP_HUM, humidity);
    // Add pressure
    frame.addSensor(SENSOR_GP_PRES, pressure);	

    // Show the frame
    frame.showFrame();
    for (int i =0 ;i<frame.length;i++)
    {
     USB.printf("value of b: %X [%c]\n",frame.buffer[i],frame.buffer[i]);
    }

     uint16_t size = frame.length;
     char buffer3[size];
  // Send packet
  
    USB.println(size);
    Utils.hex2str(frame.buffer, buffer3);
    
    USB.print(F(" PRINTING FRAME TO BE SENT: "));
    USB.println(sizeof(buffer3));
    for (int i=0;i<sizeof(buffer3); i++)
    {
      USB.print(buffer3[i]);
      }
   error = LoRaWAN.sendRadio(buffer3);
   if (error == 0)
  {
    USB.println(F("--> Packet sent OK"));
    for (int i =0;i<6;i++)
    {
      Utils.blinkLEDs(500);
    }
  }
  else 
  {
    USB.print(F("Error waiting for packets. error = "));  
    USB.println(error, DEC);   
  }
    ///////////////////////////////////////////
    // 5. Sleep
    /////////////////////////////////////////// 

    // Go to deepsleep. 	
    // After 4 minutes, Waspmote wakes up thanks to the RTC Alarm
    error = LoRaWAN.sendRadio("4444444");
   if (error == 0)
  {
    USB.println(F("--> Packet sent OK"));
    for (int i =0;i<4;i++)
    {
      Utils.blinkLEDs(1000);
    }
  }
      USB.println(F(" Sleep 4 mins"));
    PWR.deepSleep("00:00:04:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
        USB.println(F(" Jut Woke up from 4 mins"));


}
uint8_t radioModuleSetup()
{ 

  uint8_t status = 0;
  uint8_t e = 0;
  
  //////////////////////////////////////////////
  // 1. switch on
  //////////////////////////////////////////////

  e = LoRaWAN.ON(socket);

  // Check status
  if (e == 0)
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));

    if (LoRaWAN._version == RN2483_MODULE)
  {
    frequency = 868100000;
  }
  else if(LoRaWAN._version == RN2903_MODULE)
  {
    frequency = 902300000;
  }
  

  //////////////////////////////////////////////
  // 2. Enable P2P mode
  //////////////////////////////////////////////

  e = LoRaWAN.macPause();

  // Check status
  if (e == 0)
  {
    USB.println(F("2. P2P mode enabled OK"));
  }
  else 
  {
    USB.print(F("2. Enable P2P mode error = "));
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 3. Set/Get Radio Power
  //////////////////////////////////////////////

  // Set power
  e = LoRaWAN.setRadioPower(power);

  // Check status
  if (e == 0)
  {
    USB.println(F("3.1. Set Radio Power OK"));
  }
  else 
  {
    USB.print(F("3.1. Set Radio Power error = "));
    USB.println(e, DEC);
    status = 1;
  }

  // Get power
  e = LoRaWAN.getRadioPower();

  // Check status
  if (e == 0) 
  {
    USB.print(F("3.2. Get Radio Power OK. ")); 
    USB.print(F("Power: "));
    USB.println(LoRaWAN._radioPower);
  }
  else 
  {
    USB.print(F("3.2. Get Radio Power error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 4. Set/Get Radio Frequency
  //////////////////////////////////////////////

  // Set frequency
  e = LoRaWAN.setRadioFreq(frequency);

  // Check status
  if (e == 0)
  {
    USB.println(F("4.1. Set Radio Frequency OK"));
  }
  else 
  {
    USB.print(F("4.1. Set Radio Frequency error = "));
    USB.println(e, DEC);
    status = 1;
  }

  // Get frequency
  e = LoRaWAN.getRadioFreq();

  // Check status
  if (e == 0) 
  {
    USB.print(F("4.2. Get Radio Frequency OK. ")); 
    USB.print(F("Frequency: "));
    USB.println(LoRaWAN._radioFreq);
  }
  else 
  {
    USB.print(F("4.2. Get Radio Frequency error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 5. Set/Get Radio Spreading Factor (SF)
  //////////////////////////////////////////////

  // Set SF
  e = LoRaWAN.setRadioSF(spreading_factor);

  // Check status
  if (e == 0)
  {
    USB.println(F("5.1. Set Radio SF OK"));
  }
  else 
  {
    USB.print(F("5.1. Set Radio SF error = "));
    USB.println(e, DEC);
    status = 1;
  }

  // Get SF
  e = LoRaWAN.getRadioSF();

  // Check status
  if (e == 0) 
  {
    USB.print(F("5.2. Get Radio SF OK. ")); 
    USB.print(F("Spreading Factor: "));
    USB.println(LoRaWAN._radioSF);
  }
  else 
  {
    USB.print(F("5.2. Get Radio SF error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 6. Set/Get Radio Coding Rate (CR)
  //////////////////////////////////////////////

  // Set CR
  e = LoRaWAN.setRadioCR(coding_rate);

  // Check status
  if (e == 0)
  {
    USB.println(F("6.1. Set Radio CR OK"));
  }
  else 
  {
    USB.print(F("6.1. Set Radio CR error = "));
    USB.println(e, DEC);
    status = 1;
  }

  // Get CR
  e = LoRaWAN.getRadioCR();

  // Check status
  if (e == 0) 
  {
    USB.print(F("6.2. Get Radio CR OK. ")); 
    USB.print(F("Coding Rate: "));
    USB.println(LoRaWAN._radioCR);
  }
  else 
  {
    USB.print(F("6.2. Get Radio CR error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 7. Set/Get Radio Bandwidth (BW)
  //////////////////////////////////////////////

  // Set BW
  e = LoRaWAN.setRadioBW(bandwidth);

  // Check status
  if (e == 0)
  {
    USB.println(F("7.1. Set Radio BW OK"));
  }
  else 
  {
    USB.print(F("7.1. Set Radio BW error = "));
    USB.println(e, DEC);
  }

  // Get BW
  e = LoRaWAN.getRadioBW();

  // Check status
  if (e == 0) 
  {
    USB.print(F("7.2. Get Radio BW OK. ")); 
    USB.print(F("Bandwidth: "));
    USB.println(LoRaWAN._radioBW);
  }
  else 
  {
    USB.print(F("7.2. Get Radio BW error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 8. Set/Get Radio CRC mode
  //////////////////////////////////////////////

  // Set CRC
  e = LoRaWAN.setRadioCRC(crc_mode);

  // Check status
  if (e == 0)
  {
    USB.println(F("8.1. Set Radio CRC mode OK"));
  }
  else 
  {
    USB.print(F("8.1. Set Radio CRC mode error = "));
    USB.println(e, DEC);
    status = 1;
  }

  // Get CRC
  e = LoRaWAN.getRadioCRC();

  // Check status
  if (e == 0) 
  {
    USB.print(F("8.2. Get Radio CRC mode OK. ")); 
    USB.print(F("CRC status: "));
    USB.println(LoRaWAN._crcStatus);
  }
  else 
  {
    USB.print(F("8.2. Get Radio CRC mode error = ")); 
    USB.println(e, DEC);
    status = 1;
  }
  USB.println(F("-------------------------------------------------------"));


  return status;
}
