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
Gas CO2(SOCKET_B);

float concentration;	// Stores the concentration level in ppm
float temperature;	// Stores the temperature in ºC
float humidity;		// Stores the realitve humidity in %RH
float pressure;		// Stores the pressure in Pa

char node_ID[] = "CO2_example";

void setup()
{
    USB.println(F("CO2 example"));
    // Set the Waspmote ID
    frame.setID(node_ID);  
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


    ///////////////////////////////////////////
    // 5. Sleep
    /////////////////////////////////////////// 

    // Go to deepsleep. 	
    // After 4 minutes, Waspmote wakes up thanks to the RTC Alarm
    PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

}

