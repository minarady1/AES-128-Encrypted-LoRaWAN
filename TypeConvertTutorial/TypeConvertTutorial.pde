#include <WaspGPRS_SIM928A.h>

/*
 *  ------ [Ut_04] Convert types --------
 *
 *  Explanation: This example shows how to convert variable types
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

#include <limits.h>
void setup()
{
  // Init USB
  USB.ON();

}

void loop()
{
  uint8_t c []= "AA";
  char s [2];

  Utils.hex2str(c,s,2);
  USB.println(s);
  //USB.println("");

//  USB.println(strlen(c));

  /*uint8_t b = c; 
  USB.printf("Hex : %X \n",c);
  USB.printf("Hex : %X \n",b);
  uint8_t c =0xFF;
  USB.printf("%x,%c,%d\n",c,c,c);
  uint8_t d = c>>5;
  USB.printf("%x,%c,%d\n",d,d,d);
  /////////////////////////////////////////////////
  // 1. Convert from long int to string
  /////////////////////////////////////////////////
  
  char number2[20];
  Utils.long2array(1356, number2); // Gets the number ‘1356’ into the string  
  USB.println(number2);


  /////////////////////////////////////////////////
  // 2. Convert from float to string  (3 decimals)
  /////////////////////////////////////////////////
  char number3[20];
  Utils.float2String (134.54342, number3, 3);
  USB.println(number3);
  
 
  /////////////////////////////////////////////////
  // 3. Convert from string to int
  /////////////////////////////////////////////////
  int number4 = atoi("2341");
  USB.println(number4);
  
 
  /////////////////////////////////////////////////
  // 4. Convert from string to long int
  /////////////////////////////////////////////////
  long int number5 = atol("143413");
  USB.println(number5);
  
  USB.println(F("------------------------------------"));

  /////////////////////////////////////////////////
  // 5. Hex to String or Int
  /////////////////////////////////////////////////
//  unsigned char input = "64";
//  uint8_t output [10]; // So this is the type for Hex : uint8_t
  unsigned char a []={0xFF,0xFF,0xF};
  uint8_t b []="B";
  uint16_t c[]={0xFFFF,0xFF};
  uint32_t d[]={0xFFFF,0xFF};
  //USB.println(CHAR_BIT);
  USB.println(sizeof(a));
  USB.println(sizeof(b));
  USB.println(sizeof(c));
  USB.println(sizeof(d));
  USB.printf("value of a: %X [%x]\n",a,a);
  USB.printf("value of b: %X [%x]\n",b,b);
  USB.printf("value of a: %X [%d]\n",a,a);
  USB.printf("value of b: %X [%d]\n",b,b);
  USB.printf("value of a: %X [%c]\n",a,a);
  USB.printf("value of b: %X [%c]\n",b,b);
  for (int i =0;i<sizeof(b);i++)
  {
    USB.printf("value of: %X [%x,%d,%c]\n",b[i],b[i],b[i],b[i]);
    bp(b[i]);
    USB.print(F("  "));
  }
  */
/*
    /////////////////////////////////////////////////
  // 5. Int or String to Hex
  /////////////////////////////////////////////////
//  unsigned char input = "64";
//  uint8_t output [10]; // So this is the type for Hex : uint8_t
  char aa []="ABCD";
  uint8_t bb []="ABC";
  size_t sa = sizeof(aa);
  size_t sb = sizeof(bb); 
  //USB.println(CHAR_BIT);
  USB.println(sizeof(aa));
  USB.println(sizeof(bb));
   USB.println(F("----AA------"));
  for (int i =0;i<sa;i++)
  {
    USB.printf("hex value: %X [%x]\n",aa[i],aa[i]);
    USB.printf("d value: %X [%d]\n",aa[i],aa[i]);
    USB.printf("c value: %X [%c]\n",aa[i],aa[i]);
     USB.print(F("bit value:"));
     bp(aa[i]);
     USB.print(F("  "));
  }

   USB.println(F("----BB------"));
   for (int i =0;i<sb;i++)
  {
    USB.printf("value of a: %X [%x]\n",bb[i],bb[i]);
    USB.printf("value of b: %X [%d]\n",bb[i],bb[i]);
    USB.printf("value of a: %X [%c]\n",bb[i],bb[i]);
         USB.print(F("bit value:"));
     bp(aa[i]);
     USB.print(F("  "));
  }*/
/*
  USB.printf("value of a: %X [%x]\n",aa,aa);
  USB.printf("value of b: %X [%x]\n",bb,bb);
  USB.printf("value of a: %X [%d]\n",aa,aa);
  USB.printf("value of b: %X [%d]\n",bb,bb);
  USB.printf("value of a: %X [%c]\n",aa,aa);
  USB.printf("value of b: %X [%c]\n",bb,bb);
  */
  delay(100000);
}
void bp(char val) {
  for (int i = 7; 0 <= i; i--) {
    USB.printf("%c", (val & (1 << i)) ? '1' : '0');
  }
}

