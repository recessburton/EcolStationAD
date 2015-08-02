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

module TelosbTimeSyncNodesP {

	provides interface TelosbTimeSyncNodes;

	uses interface Timer<TMilli> as Timer0;
	uses interface Packet as Packet1;
	uses interface AMPacket as AMPacket1;
	uses interface AMSend as AM1;
	uses interface SplitControl as AMControl;
	uses interface Receive;
	uses interface LocalTime<TMilli> as BaseTime;

}
implementation {

	volatile int32_t offset = 0;
	volatile bool busy = FALSE;

	message_t pkt;

	uint16_t Depth = 0;	//生成树深度
	uint16_t Parent = 0;	//父节点号
	uint32_t SyncTime = 0; //基站的时间,4字节 

	typedef nx_struct TimeSyncMsg {
		nx_uint16_t nodeid;
		nx_uint16_t index;
		nx_uint32_t realtime;
	} TimeSyncMsg;

	event void Timer0.fired() {
		if( (!busy) && (SyncTime != 0) ) {
			TimeSyncMsg * btrpkt = (TimeSyncMsg * )(call Packet1.getPayload(&pkt, NULL));
					btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->index = Depth;	//本节点深度号
			SyncTime = call BaseTime.get() + offset;	//计算正确的时间，当前时间+偏移量
			btrpkt->realtime = SyncTime;
			if(call AM1.send(AM_BROADCAST_ADDR, &pkt, sizeof(TimeSyncMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
	}

	event void AMControl.startDone(error_t err) {
		if(err == SUCCESS) {
			call Timer0.startPeriodic(1024 * 30);
		}
		else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

	event void AM1.sendDone(message_t * msg, error_t error) {
		if(&pkt == msg) {
			busy = FALSE;
			signal TelosbTimeSyncNodes.SyncDone(call BaseTime.get() + offset);			//在使用本接口的模块中需要实现的触发事件
		}
	}

	event message_t * Receive.receive(message_t * msg, void * playload,
			uint8_t len) {
		if(len == sizeof(TimeSyncMsg)) {
			TimeSyncMsg * btrpkg = (TimeSyncMsg * ) playload;

			uint32_t local_time;

			if(Depth == 0 || btrpkg->index < Depth) {
				Depth = btrpkg->index + 1;
				Parent = btrpkg->nodeid;
			}//节点树维护结束 

			if(btrpkg->nodeid == Parent)	
				//只接父节点的数据
			{
				local_time = call BaseTime.get();
				offset = btrpkg->realtime - call BaseTime.get();
				signal Timer0.fired();			//马上发布同步信息
			}
			else {
				;
			}
		}
		return msg;
	}

	command error_t TelosbTimeSyncNodes.Sync() {			//本接口提供的可调用的命令
		call AMControl.start();
		return TRUE;
	}
	
	command uint32_t TelosbTimeSyncNodes.getTime(){
		uint32_t time = call BaseTime.get();
		return  time + offset	;
	}

}