/*
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
#include <time.h>
void setup()
{
 // uint8_t msg [] = "MinaRady";
  //USB.println(in);
  // put your setup code here, to run once:
//    epoch = RTC.getEpochTime();  
  
  //USB.print(F("Epoch Time from RTC: "));
  //USB.println( RTC.getTimestamp() );
  //delay(1000); 
SD.ON();
/*SD.create("LOG0.TXT");
SD.del("EXPBAT.TXT");
SD.create("EXPBAT.TXT");*/
SD.ls();
SD.del("EXP09.TXT");
SD.create("EXP09.TXT");
SD.showFile("EXP09.TXT");
//USB.println(SD.getDiskSize());
//USB.println(SD.getFileSize("EXP04.TXT"));
 // srand (time(NULL));
USB.ON();


//USB.println()
}
char filename [] = "EXPBAT.TXT";
uint8_t i = 0;
void loop()
{
  // put your main code here, to run repeatedly:
//int r = (rand() % 100 + 1)*50;
//USB.printf("%i\n",r);
/*unsigned long s = RTC.getEpochTime();
USB.println(s);
char toz1 [20];
sprintf (toz1,"%lu",s);
USB.println(toz1);
delay(1000);
USB.flush();
delay(1000);
USB.println(PWR.getBatteryVolts());
float f = 2.123456789;
sprintf(toz1,"%sV",f);
USB.println(toz1);
//SD.append(filename, toz);
// SD.append(filename,  ",");
sprintf(toz2,"%dA",PWR.getBatteryCurrent());

USB.println(toz2);
//SD.append(filename, toz);
 SD.append(filename,  ",");
    sprintf(toz,"%i",PWR.getBatteryLevel());
    SD.appendln(filename, toz);
 
SD.showFile(filename);
*/
}
