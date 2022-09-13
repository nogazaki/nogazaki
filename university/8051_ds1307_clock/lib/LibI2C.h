#ifndef __LIBI2C_H__
#define __LIBI2C_H__

void I2C_Init();
void I2C_Start();
void I2C_Stop();
bit I2C_Write(unsigned char dat);
unsigned char I2C_Read(bit ack);

#endif
