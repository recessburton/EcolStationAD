/*
 * Copyright (C)  ytc recessburton@gmail.com 2015-3-25
 *

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 * ========================================================================
 */


#include "Msp430Adc12.h"

module ADSensorP {
  provides {
  	interface TelosbADSensor;
    interface AdcConfigure<const msp430adc12_channel_config_t*> as HumidConfigure;
  }
  uses {
    interface Read<uint16_t> as HumidRead;
  }
}
implementation {

  const msp430adc12_channel_config_t config = {
  	/*详细配置可用的取值见Msp430Adc12.h头文件*/
      inch: INPUT_CHANNEL_A0,		
      sref: REFERENCE_VREFplus_AVss,
      ref2_5v: REFVOLT_LEVEL_2_5,
      adc12ssel: SHT_SOURCE_ACLK,
      adc12div: SHT_CLOCK_DIV_1,
      sht: SAMPLE_HOLD_4_CYCLES,
      sampcon_ssel: SAMPCON_SOURCE_SMCLK,
      sampcon_id: SAMPCON_CLOCK_DIV_1
  };

  event void HumidRead.readDone( error_t result, uint16_t val )
  {
			signal TelosbADSensor.readADDone(result, val);
  }
  
  command error_t TelosbADSensor.readAD() {
    	call HumidRead.read();
		return TRUE;  
	}

  async command const msp430adc12_channel_config_t* HumidConfigure.getConfiguration()
  {
    return &config; // must not be changed
  }
}

