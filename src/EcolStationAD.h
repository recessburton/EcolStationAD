#ifndef ECOL_STATION_AD_H
#define ECOL_STATION_AD_H

typedef nx_struct CTPMsg{
	nx_uint8_t datatype;			//数据类型0x01土壤湿度，0x02雨量筒中断. (后续可扩展)
	nx_uint32_t id;						//数据包id，自增
	nx_uint16_t nodeid;				//节点编号
	nx_uint16_t temperature;  //	温度（仅0x02类型数据有效，0x01类型数据用1填充）
	nx_uint16_t humidity;			//	湿度（仅0x02类型数据有效，0x01类型数据用1填充）
	nx_uint32_t eventtime;		//	包产生时间
	nx_uint16_t addata;					//	AD数值（仅0x01类型数据有效，0x02类型数据用1填充）
}CTPMsg;										//共136bit，34字节


#endif /* ECOL_STATION_AD_H */
