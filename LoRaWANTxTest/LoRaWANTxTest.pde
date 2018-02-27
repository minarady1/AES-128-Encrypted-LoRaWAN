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
#include <WaspUART.h>
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
uint8_t PORT = 3;
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
    ACC.ON();
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
  /*  
    char input1 []= "GHI";
    char input2 [3];
    char input3 [3];
    char *p = input2;
    char *p1 =input1;
    for (int i =0;i<3;i++)
    {
      //sprintf(p,"%c",input1[i]);// p contains 71 ,72,73
      sscanf(p1,"%c",p);
      USB.printf("[{%s}] [[%x]]",*p,*p);
      p1++;
      bp(*p);
      //p++;//because one byte is used instead of half byte
      p++;
    }
    USB.printf("{%s}",input2,3);
 */   
    /*
      get from char to int
      from int to hex
      print hex to char
      store char in array
    */

   

      frame.createFrame(ASCII);
  
    // set frame fields (single)
    //frame.addSensor(111, "this_is_a_string");ACC.ON();
    LoRaWAN.getRadioSF();
    char toz [10] ;
    //sprintf(toz,"%i",LoRaWAN._radioSF);
    //frame.addSensor(1, toz);
    USB.printf("Battery: %i %c",PWR.getBatteryLevel(),PWR.getBatteryLevel());
    sprintf(toz,"%i",PWR.getBatteryLevel());
    frame.addSensor(1, toz);
    
    // print frame
    frame.showFrame();
    //destination is double the size because it takes on .5 byte and spreads it on 1 full byte
    size_t s = frame.length*2;
    
    char data [s];
   
    //char input []={0x41,0x42,0x43,0x48,0x49,0x50,0x51,0x52};
    //USB.println(s);
    
    Utils.hex2str(frame.buffer,data,frame.length);

    USB.println(data);
   
    //error = LoRaWAN.sendConfirmed( PORT, frame.buffer, frame.length);

    error = LoRaWAN.sendRadio(data);
   if (error == 0)
  {
    
    USB.println(F("--> Packet sent OK"));
    for (int i =0;i<3;i++)
    {
      Utils.blinkLEDs(100);
    }
  }else
  {
     USB.printf("Error %d\n",error );
    }
  
     //PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
    delay(10000);
}
void bp(char val) {
  for (int i = 7; 0 <= i; i--) {
    USB.printf("%c", (val & (1 << i)) ? '1' : '0');
  }
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
