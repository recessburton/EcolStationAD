Author:YTC 
Mail:recessburton@gmail.com
Created Time: 2015.5.9

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

Description：
	Telosb 土壤湿度传感器AD采集程序，使用了CTP，与雨量筒中断采集混合数据传输.
	注意，采用本程序的节点只做非根节点运行.
	经过实际测试，在基站115200波特率下，本节点每20ms产生一个数据包（即基站处850B/s）的速率
	为不丢包的极限速率。
	
Logs：
	V2.3 更新邻居发现组件为V0.5版本。
	V2.2 LPL设置成1s，（1024）
	V2.1 更新邻居发现组件为V0.4版本。
	V2.0 无线功率调只最大，payload增至35字节（通过makefile），加入LPL机制。
	V1.9 集成了EcolStationNeighour邻居建立接口，建立邻居关系，并CTP发送。
	V1.8 对应新版本BS做了调整。
	V1.7 调整了CTPMsg格式，更加普适化
	V1.6 调用了新的TelosbTimeSync接口，修正了时间获取方式。
	V1.5 调整CTPMsg结构，与雨量筒数据格式统一。
	V1.4 CTPMsg加入数据类型字段，int8类型，0x01土壤湿度，0x02雨量筒中断. (后续可扩展)
	V1.3 加入时钟同步,CTPMsg结构体加入采样时间的信息.

BS version:
	BSCTPTest V1.7

	
Known Bugs: 
		none.

