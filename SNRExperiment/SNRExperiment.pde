/* SNR Experiment
    ------ Waspmote Pro Code Example --------

    Explanation: This is the basic Code for Waspmote Pro

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// Put your libraries here (#include ...)
#include <WaspLoRaWAN.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// define radio settings
//////////////////////////////////////////////
uint8_t power = 15;
uint32_t frequency;
char spreading_factor[] = "sf7";
char coding_rate[] = "4/5";
uint16_t bandwidth = 125;
char crc_mode[] = "on";
int store_counter = 0;
uint8_t sd_answer;
uint8_t error;

void setup()
{
  // put your setup code here, to run once:
   error = radioModuleSetup();
  
  // Check status
  if (error == 0)
  {
    ////USB.println(F("Module configured OK"));     
  }
  else 
  {
   // //USB.println(F("Module configured ERROR"));     
  }  

}


void loop()
{
  // put your main code here, to run repeatedly:
 
 error= LoRaWAN.receiveRadio(100);
  LoRaWAN.getRadioSNR();
 USB.println(LoRaWAN._radioSNR);
  /* if (error==0){
  LoRaWAN.getRadioSNR();
 USB.println(LoRaWAN._radioSNR);
  }else{
  LoRaWAN.getRadioSNR();
 USB.println(LoRaWAN._radioSNR);}
*/
  

}
void bp(char val) {
  for (int i = 7; 0 <= i; i--) {
    ////USB.printf("%c", (val & (1 << i)) ? '1' : '0');
  }
}
/***********************************************************************************
*
* radioModuleSetup()
*
*   This function includes all functions related to the module setup and configuration
*   The user must keep in mind that each time the module powers on, all settings are set
*   to default values. So it is better to develop a specific function including all steps
*   for setup and call it everytime the module powers on.
*
*
***********************************************************************************/
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
    ////////USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    ////USB.print(F("1. Switch ON error = ")); 
    //////USB.println(e, DEC);
    status = 1;
  }
  //////USB.println(F("-------------------------------------------------------"));

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
    //////USB.println(F("2. P2P mode enabled OK"));
  }
  else 
  {
    ////USB.print(F("2. Enable P2P mode error = "));
    //////USB.println(e, DEC);
    status = 1;
  }
  //////USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 3. Set/Get Radio Power
  //////////////////////////////////////////////

  // Set power
  e = LoRaWAN.setRadioPower(power);

  // Check status
  if (e == 0)
  {
    //////USB.println(F("3.1. Set Radio Power OK"));
  }
  else 
  {
    ////USB.print(F("3.1. Set Radio Power error = "));
    //////USB.println(e, DEC);
    status = 1;
  }

  // Get power
  e = LoRaWAN.getRadioPower();

  // Check status
  if (e == 0) 
  {
    ////USB.print(F("3.2. Get Radio Power OK. ")); 
    ////USB.print(F("Power: "));
    //////USB.println(LoRaWAN._radioPower);
  }
  else 
  {
    ////USB.print(F("3.2. Get Radio Power error = ")); 
    //////USB.println(e, DEC);
    status = 1;
  }
  //////USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 4. Set/Get Radio Frequency
  //////////////////////////////////////////////

  // Set frequency
  e = LoRaWAN.setRadioFreq(frequency);

  // Check status
  if (e == 0)
  {
    //////USB.println(F("4.1. Set Radio Frequency OK"));
  }
  else 
  {
    ////USB.print(F("4.1. Set Radio Frequency error = "));
    //////USB.println(e, DEC);
    status = 1;
  }

  // Get frequency
  e = LoRaWAN.getRadioFreq();

  // Check status
  if (e == 0) 
  {
    ////USB.print(F("4.2. Get Radio Frequency OK. ")); 
    ////USB.print(F("Frequency: "));
    (LoRaWAN._radioFreq);
  }
  else 
  {
    ////USB.print(F("4.2. Get Radio Frequency error = ")); 
    ////USB.println(e, DEC);
    status = 1;
  }
  //USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 5. Set/Get Radio Spreading Factor (SF)
  //////////////////////////////////////////////

  // Set SF
  e = LoRaWAN.setRadioSF(spreading_factor);

  // Check status
  if (e == 0)
  {
    //USB.println(F("5.1. Set Radio SF OK"));
  }
  else 
  {
    //USB.print(F("5.1. Set Radio SF error = "));
    //USB.println(e, DEC);
    status = 1;
  }

  // Get SF
  e = LoRaWAN.getRadioSF();

  // Check status
  if (e == 0) 
  {
    //USB.print(F("5.2. Get Radio SF OK. ")); 
    //USB.print(F("Spreading Factor: "));
    //USB.println(LoRaWAN._radioSF);
  }
  else 
  {
    //USB.print(F("5.2. Get Radio SF error = ")); 
    //USB.println(e, DEC);
    status = 1;
  }
  //USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 6. Set/Get Radio Coding Rate (CR)
  //////////////////////////////////////////////

  // Set CR
  e = LoRaWAN.setRadioCR(coding_rate);

  // Check status
  if (e == 0)
  {
    //USB.println(F("6.1. Set Radio CR OK"));
  }
  else 
  {
    //USB.print(F("6.1. Set Radio CR error = "));
    //USB.println(e, DEC);
    status = 1;
  }

  // Get CR
  e = LoRaWAN.getRadioCR();

  // Check status
  if (e == 0) 
  {
    //USB.print(F("6.2. Get Radio CR OK. ")); 
    //USB.print(F("Coding Rate: "));
    //USB.println(LoRaWAN._radioCR);
  }
  else 
  {
    //USB.print(F("6.2. Get Radio CR error = ")); 
    //USB.println(e, DEC);
    status = 1;
  }
  //USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 7. Set/Get Radio Bandwidth (BW)
  //////////////////////////////////////////////

  // Set BW
  e = LoRaWAN.setRadioBW(bandwidth);

  // Check status
  if (e == 0)
  {
    //USB.println(F("7.1. Set Radio BW OK"));
  }
  else 
  {
    //USB.print(F("7.1. Set Radio BW error = "));
    //USB.println(e, DEC);
  }

  // Get BW
  e = LoRaWAN.getRadioBW();

  // Check status
  if (e == 0) 
  {
    //USB.print(F("7.2. Get Radio BW OK. ")); 
    //USB.print(F("Bandwidth: "));
    //USB.println(LoRaWAN._radioBW);
  }
  else 
  {
    //USB.print(F("7.2. Get Radio BW error = ")); 
    //USB.println(e, DEC);
    status = 1;
  }
  //USB.println(F("-------------------------------------------------------"));



  //////////////////////////////////////////////
  // 8. Set/Get Radio CRC mode
  //////////////////////////////////////////////

  // Set CRC
  e = LoRaWAN.setRadioCRC(crc_mode);

  // Check status
  if (e == 0)
  {
    //USB.println(F("8.1. Set Radio CRC mode OK"));
  }
  else 
  {
    //USB.print(F("8.1. Set Radio CRC mode error = "));
    //USB.println(e, DEC);
    status = 1;
  }

  // Get CRC
  e = LoRaWAN.getRadioCRC();

  // Check status
  if (e == 0) 
  {
    //USB.print(F("8.2. Get Radio CRC mode OK. ")); 
    //USB.print(F("CRC status: "));
    //USB.println(LoRaWAN._crcStatus);
  }
  else 
  {
    //USB.print(F("8.2. Get Radio CRC mode error = ")); 
    //USB.println(e, DEC);
    status = 1;
  }
  //USB.println(F("-------------------------------------------------------"));


  return status;
}
