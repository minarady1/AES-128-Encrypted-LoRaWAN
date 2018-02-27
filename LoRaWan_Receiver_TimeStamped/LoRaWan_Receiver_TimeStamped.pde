/*  
 *  ------ P2P Code Example -------- 
 *  
 *  Explanation: This example shows how to configure the module
 *  for P2P mode and the corresponding parameters. After this, 
 *  the example shows how to receive packets from other radio modules
 *  which must be set with the same radio settings
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Version:           3.1
 *  Design:            David Gascon
 *  Implementation:    Luismi Marti
 */

#include <WaspLoRaWAN.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// define radio settings
//////////////////////////////////////////////
uint8_t power = 15;
uint32_t frequency;
char spreading_factor[] = "sf12";
char coding_rate[] = "4/5";
uint16_t bandwidth = 125;
char crc_mode[] = "on";
int store_counter = 0;
uint8_t sd_answer;
//////////////////////////////////////////////

unsigned long t ;
char _pre [10];
char _post [10];
// variable
uint8_t error;

char filename [] = "EXP09.TXT";
char logfile [] = "LOG0.TXT";
void setup() 
{
  
  USB.ON();
  SD.ON();
  Log("Start setup");
  //SD.del(filename);
  //SD.create(filename);
  // module setup
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
  Log("End setup");
}


void loop() 
{
  USB.print(RTC.getEpochTime());
  USB.println(" :beginning of  loop");
  USB.println(F("\nListening to packets..."));

   // rx
  error = LoRaWAN.receiveRadio(20000);
  t = RTC.getEpochTime();
  sprintf (_pre,"%lu",t);
  Log("Received frame");
  // Check status
  if (error == 0)
  {
    USB.print(RTC.getEpochTime());
    USB.println(" :Received Packet, Will blink");
    Utils.blinkLEDs(500);
    Utils.blinkLEDs(500);
    USB.print(RTC.getEpochTime());
    USB.println(" :End blink, will store");

    USB.println((char*) LoRaWAN._buffer);
    char data[LoRaWAN._length];
    sprintf( data,"%s", LoRaWAN._buffer);
    USB.println(data);
    uint16_t len = LoRaWAN._length;

    char toz [10] ;
    USB.printf("store counter:%d",store_counter);
    //if (store_counter%8 ==0)
    if (true)
    {
      store_counter =0;//reset it
      USB.println("will store");
    sprintf(toz,"%i",LoRaWAN._radioSNR);
    
    SD.append(filename, toz);
    SD.append(filename,  ",");

    sprintf(toz,"%i",PWR.getBatteryLevel());
    SD.append(filename, toz);
    SD.append(filename,  ",");

    t = RTC.getEpochTime();
    sprintf (_post,"%lu",t);
    
    SD.append(filename, _pre);
    SD.append(filename,  ",");
    SD.append(filename, _post);
    SD.append(filename,  ",");
    
    sd_answer = SD.appendln(filename, (uint8_t*)data,len);
    USB.printf("sd answer: %d",sd_answer);
    USB.print(RTC.getEpochTime());
    USB.println(" :End Storage");
    //SD.showFile(filename);
    }else
    {
       USB.println("will not store");
    }
      store_counter++;
    USB.print(F("length: "));
    USB.println(LoRaWAN._length);
    // get SNR 
    //PrintInfo();
    USB.print(F("SNR: "));
    LoRaWAN.getRadioSNR();
    USB.println(LoRaWAN._radioSNR);
   
    if( sd_answer == 1 )
    {
      USB.println(F("\nAppend OK\n"));
    }
    else
    {
      USB.println(F("\n1 - append error"));
      USB.println(sd_answer);
    }
  }
  else 
  {
     Log("frame error");
    // error code
    //  1: error
    //  2: no incoming packet
    USB.print(F("Error waiting for packets. error = "));  
    USB.println(error, DEC);   
  }
  //USB.printf("size of long: %i",sizeof(a));
    USB.print(RTC.getEpochTime());
   USB.println(" :end of  loop");

}

void Log (char s [])
{
  unsigned long t = RTC.getEpochTime();
  char tc [10] ;
  sprintf(tc,"%ul",t);
  SD.append(logfile, tc);
  SD.append(logfile, ",");
  SD.appendln(logfile, s);
  
}
void GetParameters()
{
  LoRaWAN.getEUI();
  LoRaWAN.getSupplyPower();
  LoRaWAN.getDeviceEUI();
  LoRaWAN.getDeviceAddr();
  LoRaWAN.getPower();
  LoRaWAN.getAppEUI();
  LoRaWAN.getDataRate();
  LoRaWAN.getADR();
  LoRaWAN.getDutyCyclePrescaler();
 // LoRaWAN.getChannelDRRange();
//  LoRaWAN.getChannelStatus();
  LoRaWAN.getRetries();
  LoRaWAN.getBand();
  LoRaWAN.getMargin();
  LoRaWAN.getGatewayNumber();
  LoRaWAN.getUpCounter();
  LoRaWAN.getDownCounter();
  LoRaWAN.getRadioSNR();
  LoRaWAN.getRadioSF();
  LoRaWAN.getRadioPower();
  LoRaWAN.getRadioMode();
  LoRaWAN.getRadioFreq();
  LoRaWAN.getRadioReceivingBW();
  LoRaWAN.getRadioBitRateFSK();
  LoRaWAN.getRadioFreqDeviation();
  LoRaWAN.getRadioCRC();
  LoRaWAN.getRadioPreamble();
  LoRaWAN.getRadioCR();
  LoRaWAN.getRadioWDT();
  LoRaWAN.getRadioBW();
  LoRaWAN.getMACStatus();
  LoRaWAN.getAR();
  LoRaWAN.getRX1Delay();
  LoRaWAN.getMaxPayload();
  LoRaWAN.getSyncWord();
 }
 
void PrintInfo(){
  GetParameters();
  USB.print(F("Frequency: "));
  USB.println(LoRaWAN._radioFreq);
  
  USB.print(F("EUI: "));
  USB.println(LoRaWAN._eui);

  USB.print(F("_devEUI: "));
  USB.println(LoRaWAN._devEUI);

  USB.print(F("_appEUI: "));
  USB.println(LoRaWAN._appEUI);

  USB.print(F("_devAddr: "));
  USB.println(LoRaWAN._devAddr);

  USB.print(F("_band: "));
  USB.println(LoRaWAN._band);

  USB.print(F("_retries: "));
  USB.println(LoRaWAN._retries);

  USB.print(F("_radioFreqDev: "));
  USB.println(LoRaWAN._radioFreqDev);

   USB.print(F("_margin: "));
  USB.println(LoRaWAN._margin);
  USB.print(F("_gwNumber: "));
  USB.println(LoRaWAN._gwNumber);
  USB.print(F("_preambleLength: "));
  USB.println(LoRaWAN._preambleLength);

  USB.print(F("_radioMode: "));
  USB.println(LoRaWAN._radioMode);

  USB.print(F("_powerIndex: "));
  USB.println(LoRaWAN._powerIndex);

  USB.print(F("_dataRate: "));
  USB.println(LoRaWAN._dataRate);

  USB.print(F("_radioPower: "));
  USB.println(LoRaWAN._radioPower);

  USB.print(F("_radioRxBW: "));
  USB.println(LoRaWAN._radioRxBW);

  USB.print(F("_radioBitRate: "));
  USB.println(LoRaWAN._radioBitRate);

  USB.print(F("_radioCR: "));
  USB.println(LoRaWAN._radioCR);

  USB.print(F("_radioWDT: "));
  USB.println(LoRaWAN._radioWDT);

  USB.print(F("_radioBW: "));
  USB.println(LoRaWAN._radioBW);
  
  USB.print(F("_radioSNR: "));
  USB.println(LoRaWAN._radioSNR);
  
  USB.print(F("_radioSF: "));
  USB.println(LoRaWAN._radioSF);


  USB.print(F("_supplyPower: "));
  USB.println(LoRaWAN._supplyPower);

  USB.print(F("_upCounter: "));
  USB.println(LoRaWAN._upCounter);

  USB.print(F("_downCounter: "));
  USB.println(LoRaWAN._downCounter);

  USB.print(F("_port: "));
  USB.println(LoRaWAN._port);

  USB.print(F("_port: "));
  USB.println(LoRaWAN._port);

  USB.print(F("_rx1Delay: "));
  USB.println(LoRaWAN._rx1Delay);

  USB.print(F("_version: "));
  USB.println(LoRaWAN._version);

  USB.print(F("_macStatus: "));
  USB.println(LoRaWAN._macStatus);

  USB.print(F("_maxPayload: "));
  USB.println(LoRaWAN._maxPayload);

  USB.print(F("_syncWord: "));
  USB.println(LoRaWAN._syncWord);

  
  
  }

void bp(char val) {
  for (int i = 7; 0 <= i; i--) {
    USB.printf("%c", (val & (1 << i)) ? '1' : '0');
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
