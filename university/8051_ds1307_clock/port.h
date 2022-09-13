#ifndef _PORT_H_
#define _PORT_H_

//DS1307 I2C ports
sbit I2C_SDA = P1^1;
sbit I2C_SCL = P1^0;

//LCD ports
sbit LCD_RS = P1^3;
sbit LCD_EN = P1^2;
#define LCD_DATA P2

//Buttons
sbit SET  = P1^7;
sbit MODE = P1^6;
sbit UP   = P1^5;
sbit DOWN = P1^4;

extern unsigned char hour, minute, second, day, date, month, year;

#endif
