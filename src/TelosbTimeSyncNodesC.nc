/**
 Copyright (C),2014-2015, YTC, www.bjfulinux.cn
 Copyright (C),2014-2015, ENS Group, ens.bjfu.edu.cn
 Created on  2015-04-27 16:21
 
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

configuration TelosbTimeSyncNodesC {
	provides interface TelosbTimeSyncNodes;
}

implementation {
	components LedsC;
	components TelosbTimeSyncNodesP as App;
	components new TimerMilliC() as Timer0;
	components ActiveMessageC;
	components new AMSenderC(177) as AM1;
	components new AMReceiverC(177);

	components HilTimerMilliC as BaseTime;

	TelosbTimeSyncNodes = App.TelosbTimeSyncNodes;

	App.Leds->LedsC;
	App.Timer0->Timer0;
	App.Packet1->AM1;
	App.AMPacket1->AM1;
	App.AM1->AM1;
	App.AMControl->ActiveMessageC;
	App.Receive->AMReceiverC;

	App.BaseTime->BaseTime;

}