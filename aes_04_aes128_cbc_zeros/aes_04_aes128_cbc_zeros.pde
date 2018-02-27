/*
 *  ------Waspmote AES_04 Encryption 128 CBC ZEROS --------
 *
 *  This example shows how to encrypt plain text using:
 *    - AES algorithm
 *    - 128-bit key size
 *    - ZEROS Padding
 *    - CBC Cipher Mode  
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
 *  http://www.libelium.com
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
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
 *  Version:                3.0
 *  Design:                 David Gascón
 *  Implementation:         Alvaro Gonzalez, Yuri Carmona
 */
 
#include "WaspAES.h"

// Define a 16-Byte (AES-128) private key to encrypt message  
char password[] = "libeliumlibelium";

// Define Initial Vector
uint8_t IV[16] = { 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F};

// original message on which the algorithm will be applied 
char message[] = "This_is_a_message"; 
uint8_t orig [200];
// Variable for encrypted message's length
uint16_t encrypted_length;

// Declaration of variable encrypted message 
uint8_t encrypted_message[300]; 


void setup()
{
  // init USB port 
  USB.ON(); 
  USB.println(F("AES_04 example:"));
  USB.println(F("- 128-bit Key Size"));    
  USB.println(F("- CBC Cipher Mode"));   
  USB.println(F("- ZEROS padding"));
  USB.println();   
  
  USB.print(F("\nOriginal message:")); 
  USB.println(message);

  USB.print(F("Original length:")); 
  USB.println((int)strlen(message));
  USB.println();

} 

void loop()
{ 
  ////////////////////////////////////////////////////////////////
  // 1. Encrypt message
  ////////////////////////////////////////////////////////////////
 /* USB.println(F("1. Encrypt message"));
  
  // 1.1. Calculate length in Bytes of the encrypted message  
  encrypted_length = AES.sizeOfBlocks(message); 

  // 1.2. Calculate encrypted message with CBC cipher mode and ZEROS padding. 
  AES.encrypt(  AES_128
              , password
              , message
              , encrypted_message
              , CBC
              , ZEROS
              , IV); 


  // 1.3. Printing encrypted message    
  USB.print(F("AES Encrypted message:"));
  AES.printMessage( encrypted_message, encrypted_length);

  // 1.4. Printing encrypted message's length 
  USB.print(F("AES Encrypted length:")); 
  USB.println( (int)encrypted_length);
  USB.println();*/
  uint16_t s = sizeof(orig);
  sscanf("27DA0886201343E23076D994435514AF0A0B0C0D0E0F1000EE05BE0621090080001020FA21091304052C00210904068EEA0191289AD2E0135C37137DB7817139EA000100910028009A00D24848D02D660000000000000002","%c",encrypted_message);
//  uint16_t s = 17;
  AES.decrypt(
    AES_128,
    (char*)password,
    encrypted_message,
    AES.sizeOfBlocks((char*)encrypted_message),
    orig,
    (uint16_t*)s,
    CBC,
    ZEROS,
    IV);
 USB.print(F("AES Decrypted message:")); 
  AES.printMessage( orig, s);

  // 1.4. Printing encrypted message's length 
  USB.print(F("AES Decrypted length:")); 
  USB.println( (int)s);  
  delay(5000);
  USB.println(F("***********************"));

}

