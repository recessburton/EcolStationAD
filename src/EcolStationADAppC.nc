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


configuration EcolStationADAppC{
}
implementation{
	components EcolStationADC as App, MainC, LedsC, ActiveMessageC;
	components CollectionC as Collector;
	components new CollectionSenderC(0xee);
	components ADSensorC;
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer2;
	components TelosbTimeSyncNodesC;
	components EcolStationNeighbourC;
	
	//LPL
	//components CC2420ActiveMessageC as LplRadio;
	
	components ResetC;
	
	App.Boot                                     -> MainC;
	App.RadioControl                    -> ActiveMessageC;
	App.RoutingControl                -> Collector;
	App.Leds                                     -> LedsC;
	App.Timer1                                   -> Timer1;
	App.Send                                    -> CollectionSenderC;
	App.Receive                               -> Collector.Receive[0xee];
	App.TelosbADSensor              -> ADSensorC;
	App.TelosbTimeSyncNodes -> TelosbTimeSyncNodesC;
	App.EcolStationNeighbour -> EcolStationNeighbourC;
	//LPL
	//App.LowPowerListening -> LplRadio;
	
	App.Timer2 -> Timer2;
	App.Reset -> ResetC;
	
}
