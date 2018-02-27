/*  
 *  ------------ [GP_02] - CO2 ------------
 *  
 *  Explanation: This is the basic code to manage and read the carbon dioxide
 *  (CO2) gass sensor. The concentration and the enviromental variables will be
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
#include <WaspAES.h>


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
char node_ID[] = "0S";
uint8_t error;


/////////////////////////////////////////
// Encryption Parameters
char password[] = "libeliumlibelium";
uint8_t IV[16] = { 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F};
// Variable for encrypted message's length
uint16_t encrypted_length;

// 2. Declaration of variable encrypted message with enough memory space
uint8_t encrypted_message[128]; 


void setup()
{
    frame.setID(node_ID); 
    error = radioModuleSetup();
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
  USB.print(RTC.getEpochTime());
  USB.println(" :Turn On Sensors");
  USB.print(RTC.getEpochTime());
  USB.println(" :Sensor On compete. Sleep 1 Start");
  //PWR.deepSleep("00:00:01:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  USB.print(RTC.getEpochTime());
  USB.println(" :Weakup Complete ALL_ON 1 And Will Set Radio Modile");
  error = radioModuleSetup();
  USB.print(RTC.getEpochTime());
  USB.println(" :Radio Setup Complete , Preprocessing Begin");
  // Check status
  if (error == 0)
  {
    USB.println(F("Module configured OK"));     
  }
  else 
  {
    USB.println(F("Module configured ERROR"));     
  }
    frame.createFrame(ASCII);
    frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel()); 
    frame.addTimestamp();  
    frame.showFrame();

    //Encrypt
     encrypted_length = AES.sizeOfBlocks(frame.length); 
     AES.encrypt(  128
                , password
                , frame.buffer
                , frame.length
                , encrypted_message
                , CBC
                , PKCS5
                , IV); 
    AES.printMessage( encrypted_message, encrypted_length); 
    USB.printf("HEX Encrypt [%s]\n",encrypted_message);
    //Prepare Final Payload
    size_t s = encrypted_length*2;
    //USB.printf("size is %i allocated size is %i\n",sizeof(encrypted_message),encrypted_length);
    char data [128];
    char* d=data;
    //sprintf(data,"%c",encrypted_message);
    
    Utils.hex2str(encrypted_message,data,64);

    USB.printf("ACTUAL DATA %s \n",data);

    USB.print(RTC.getEpochTime());
    USB.println(" :Preprocessing Ceomplete, Send Data Prepare");
    error = LoRaWAN.sendRadio(data);
    if (error == 0)
    { 
      USB.print(RTC.getEpochTime());
      USB.println(" :Send Complete, Will Blink");
      USB.println(F("--> Packet sent OK"));
      for (int i =0;i<3;i++)
      {
        Utils.blinkLEDs(100);
      }

      USB.print(RTC.getEpochTime());
      USB.println(" :Blink Complete");

    }else
    {
     USB.printf("Error %d\n",error );
    }

    USB.print(RTC.getEpochTime());
    USB.println(" :Sleep 2");
    delay(10000);
    //PWR.deepSleep("00:00:01:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
    USB.print(RTC.getEpochTime());
    USB.println(" :Wakup 2 complete ALL_OFF , end of loop");
    //delay(10000);
}
void EncryptStr (uint8_t  str [], uint8_t * encrypted_message )
{
  uint16_t encrypted_length;
  uint8_t *IV_ptr = IV;
  encrypted_length = sizeof(str);
  char new_str [300];
  sprintf(new_str,"%c",str);
  //sscanf(str,"%c",new_str);
  AES.encrypt(  AES_128
              , (char*)password
              , new_str
              , encrypted_message
              , CBC
              , ZEROS
              , IV_ptr);
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
