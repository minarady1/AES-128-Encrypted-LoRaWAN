/*  
 *  ------ [SD_02] - Write data to a SD file -------- 
 *  
 *  Explanation: Turn on the SD card. Write data in SD file
 *  indicating the position to write.
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
 *  Version:           3.0
 *  Design:            David Gascón 
 *  Implementation:    Yuri Carmona
 */

// define file name: MUST be 8.3 SHORT FILE NAME
char filename[]="FILE2.TXT";

// define hexadecimal data
uint8_t data[10]={0x41,0x42,0x43};

// define variable
uint8_t sd_answer;


void setup()
{
  // open USB port
  USB.ON();
  USB.println(F("SD_2 example"));
  
  // Set SD ON
  SD.ON();
    
  // Delete file
  sd_answer = SD.del(filename);
  
  if( sd_answer == 1 )
  {
    USB.println(F("file deleted"));
  }
  else 
  {
    USB.println(F("file NOT deleted"));  
  }
    
  // Create file
  sd_answer = SD.create(filename);
  
  if( sd_answer == 1 )
  {
    USB.println(F("file created"));
  }
  else 
  {
    USB.println(F("file NOT created"));  
  } 
}


void loop()
{     
  
  // 1 - It writes “hello” in file at position 0    
  sd_answer = SD.writeSD(filename,"hello", 0);
  
  if( sd_answer == 1 ) 
  {
    USB.println(F("\n1 - Write \"hello\" in file at position 0 ")); 
  }
  else
  {
    USB.println(F("\n1 - Write failed"));  
  }
  
  // show file
  SD.showFile(filename);
  delay(1000);
  

  
  // 2 - It writes “goodbye” in file at position 5
  sd_answer = SD.writeSD(filename,"goodbye", 5);
  
  if( sd_answer == 1 ) 
  {
    USB.println(F("\n2 - Write \"goodbye\" in file at position 5"));
  }
  else
  { 
    USB.println(F("\n2 - Write failed")); 
  }
  
  // show file
  SD.showFile(filename);
  delay(1000);



  // 3 - It writes “hel” in file at position 10 indicating 3-byte length
  sd_answer = SD.writeSD(filename,"hello", 10, 3);
  
  if( sd_answer == 1 ) 
  {
    USB.println(F("\n3 - Write \"hel\" in file at position 10 indicating 3-byte length"));
  }
  else
  {
    USB.println(F("\n3 - Write failed"));   
  }
 
   // show file
  SD.showFile(filename);
  delay(1000);
   
   
   
  // 4 - It writes hexadecimal data indicating the length to write
  sd_answer = SD.writeSD(filename, data, 0, 3);
  
  if( sd_answer == 1 ) 
  {
    USB.println(F("\n4 - Write hexadecimal data indicating 3 bytes to be written (offset=0)"));
  }
  else
  {
    USB.println(F("\n4 - Write failed"));  
  }
  
  // show file
  SD.showFile(filename);
  delay(1000);
   
   
   
  // 5 - It writes hexadecimal data
  // End of data array is defined by 0xAAAA
  sd_answer = SD.writeSD(filename, data, 0);
  
  if( sd_answer == 1 )
  {
    USB.println("\n5 - Write array of bytes (offset=0). End of 'data' array is defined by 0xAAAA");
  }
  else
  {
    USB.println("\n5 - Write failed");
  }

  // show file
  SD.showFile(filename);   
  USB.println(F("\n***************************"));
  delay(10000);
}


