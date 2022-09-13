#ifndef __DS1307_H__
#define __DS1307_H__

void DS1307_Init();
unsigned char DS1307_Read(unsigned char add);
void DS1307_Write(unsigned char add, unsigned char dat);
void DS1307_Read_Time(unsigned char *hour, unsigned char *minute, unsigned char *second);
void DS1307_Write_Time(unsigned char hour, unsigned char minute, unsigned char second);
void DS1307_Read_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year);
void Ds1307_Write_Date(unsigned char day, unsigned char date, unsigned char month, unsigned char year);

#endif
