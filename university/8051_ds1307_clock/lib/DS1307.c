#include "DS1307.h"
#include "LibI2C.h"
#include "port.h"
#include <REGX52.H>

//=======Ds1307 Init ========
// Khoi tao DS1307
// De DS1307 hoat dong thi bit thu 7 cua thanh ghi 00 trong DS1307 phai bang 0;
void DS1307_Init() {
    unsigned char temp;
    temp = DS1307_Read(0000); // Doc Thanh ghi 0000
    temp &= 01111111;         // Clear MSB cua thanh ghi 0000
    DS1307_Write(0000, temp); // Ghi temp vao thanh ghi 0000
    DS1307_Write(0x07, 0x10);
}
//======Ds1307 Read =====
// Doc tu thanh ghi add va tra ve data
unsigned char DS1307_Read(unsigned char add) {
    unsigned char temp;
    I2C_Start();
    I2C_Write(0xD0); // 0xD0 = 1101 0000, voi 1101 000 la dia chi cua DS1307, con bit cuoi la mode M->S
    I2C_Write(add);
    I2C_Start();
    I2C_Write(0xD1); // chuyen sang mode S->M
    temp = I2C_Read(0);
    I2C_Stop();
    return temp;
}
//=====Ds1307 Write ======
// Ghi dat vao thanh ghi add
void DS1307_Write(unsigned char add, unsigned char dat) {
    I2C_Start();
    I2C_Write(0xD0);
    I2C_Write(add);
    I2C_Write(dat);
    I2C_Stop();
}
//=======Ds1307 Read Time ======
// Doc gio, phut, giay
void DS1307_Read_Time(unsigned char *hour, unsigned char *minute, unsigned char *second) {
    bit x;
    unsigned char hour10;
    I2C_Start();
    I2C_Write(0xD0);
    I2C_Write(0x00);
    I2C_Start();
    I2C_Write(0xD1);
    *second = I2C_Read(1);
    *minute = I2C_Read(1);
    *hour = I2C_Read(0);
    I2C_Stop();

    *second = ((*second >> 4) * 10 + (*second & 15));
    *minute = ((*minute >> 4) * 10 + (*minute & 15));
    x = *hour & 64;
    *hour &= 63;
    hour10 = *hour >> 4;
    hour10 = (hour10 * (!x)) + (((hour10 & 1) + ((hour10 & 2) * 12)) * x);
    *hour = ((hour10) * 10 + (*hour & 15));
}
//======== DS1307_Write_Time =======
// Ghi gio, phut, giay
void DS1307_Write_Time(unsigned char hour, unsigned char minute, unsigned char second) {
    second = ((((second / 10) << 4) & 240) | ((second % 10) & 15));
    minute = ((((minute / 10) << 4) & 240) | ((minute % 10) & 15));
    hour = ((((hour / 10) << 4) & 48) | ((hour % 10) & 15));
    hour &= 63;

    I2C_Start();
    I2C_Write(0xD0); // 0xD0 la 1101 0000, chon DS1307 va chon mode M->S
    I2C_Write(0000); // ghi vao thanh ghi second
    I2C_Write(second);
    I2C_Write(minute);
    I2C_Write(hour);
    I2C_Stop();
}
//=======DS1307 Read Date ===========
void DS1307_Read_Date(unsigned char *day, unsigned char *date, unsigned char *month, unsigned char *year) {
    // day, date... luc nay dang la con tro
    I2C_Start();
    I2C_Write(0xD0);
    I2C_Write(0003); // bat dau tu thanh ghi chua Thu (Day)
    I2C_Start();
    I2C_Write(0xD1);
    *day = I2C_Read(1);
    *date = I2C_Read(1);
    *month = I2C_Read(1);
    *year = I2C_Read(0);
    I2C_Stop();

    *day &= 7;
    *date &= 63;
    *date = ((*date >> 4) * 10 + (*date & 15));
    *month &= 31;
    *month = ((*month >> 4) * 10 + (*month & 15));
    *year = ((*year >> 4) * 10 + (*year & 15));
}
//======DS1307 Write Date ================
void DS1307_Write_Date(unsigned char day, unsigned char date, unsigned char month, unsigned char year) {
    date = ((((date / 10) << 4) & 48) | ((date % 10) & 15));
    month = ((((month / 10) << 4) & 16) | ((month % 10) & 15));
    year = ((((year / 10) << 4) & 240) | ((year % 10) & 15));

    I2C_Start();
    I2C_Write(0xD0);
    I2C_Write(0003);
    I2C_Write(day);
    I2C_Write(date);
    I2C_Write(month);
    I2C_Write(year);
    I2C_Stop();
}
