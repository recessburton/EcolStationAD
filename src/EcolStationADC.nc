/**
 Copyright (C),2014-2015, YTC, www.bjfulinux.cn
 Copyright (C),2014-2015, ENS Group, ens.bjfu.edu.cn
 Created on  2015-05-08 17:26
 
 @author: ytc recessburton@gmail.com
 @version: 1.0
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>
 **/

#include <Timer.h>
#include "EcolStationAD.h"
module EcolStationADC{
	uses{
		interface Boot;
		interface SplitControl as RadioControl;
		interface StdControl as RoutingControl;
		interface Send;
		interface Leds;
		interface Receive;
		interface Timer<TMilli>;
		interface TelosbADSensor;
		interface TelosbTimeSyncNodes;
	}
}
implementation{
	
	message_t packet;
	uint32_t id = 0;
	
	volatile bool sendBusy = FALSE;
	
	event void Boot.booted(){
		call TelosbTimeSyncNodes.Sync();
		call RadioControl.start();	
	}
	
	event void RadioControl.startDone(error_t err){
		if(err != SUCCESS){
			call RadioControl.start();
		}else{
			call RoutingControl.start();
			call Timer.startPeriodic(2000);
		}
	}
	
	event void Timer.fired(){
		call TelosbADSensor.readAD();
	}
	
	event void RadioControl.stopDone(error_t err){	
	}
	
	event void TelosbADSensor.readADDone(error_t err, uint16_t data){
		CTPMsg* msg = (CTPMsg*)call Send.getPayload(&packet, sizeof(CTPMsg));
	
		msg -> datatype         = 0x01;	
		msg -> id                       = ++ id;
		msg -> nodeid             = TOS_NODE_ID;
		msg -> data1                = 0xFFFF;
		msg -> data2                = data;
		msg -> eventtime       = call TelosbTimeSyncNodes.getTime();
		
		call Leds.led2On();
		if(call Send.send(&packet, sizeof(CTPMsg)) != SUCCESS)
			call Leds.led0On();
		else
			sendBusy = TRUE;	
	}
	
	event void Send.sendDone(message_t* m, error_t err){
		if(err != SUCCESS)
			call Leds.led0On();
		sendBusy = FALSE;	
		call Leds.led2Off();
	}
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
		return msg;	
	}
	

	event void TelosbTimeSyncNodes.SyncDone(uint32_t RealTime){
		call Leds.led1Toggle();
	}
}