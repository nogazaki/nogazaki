#include "LibLCD.h"
#include "delay_ms.h"
#include "port.h"
#include <REGX52.H>

// Ports
//    LCD_RS
//    LCD_EN
//    LCD_DATA

// Khoi dong LCD
void initLCD() {
    outCmd(0x38);
    delay_ms(5);
    outCmd(0x0E);
    delay_ms(5);
    outCmd(0x06);
    delay_ms(5);
    clrscr();
}
// Cai dat LCD
void outCmd(unsigned char cmd) {
    LCD_RS = 0;
    LCD_DATA = cmd;
    LCD_EN = 1;
    delay_ms(5);
    LCD_EN = 0;
    delay_ms(5);
}
// Xuat ki tu
void outChar(unsigned char c) {
    LCD_RS = 1;
    LCD_DATA = c;
    LCD_EN = 1;
    delay_ms(5);
    LCD_EN = 0;
    delay_ms(5);
}
// Chuyen vi tri tro tren LCD
void gotoRowCol(unsigned int row, unsigned int col) {
    // row = 0 hoac 1
    // col = 0 -> 50 hex
    char cmd;
    if (row == 0)
        cmd = 0x80 + col;
    else
        cmd = 0xC0 + col;
    outCmd(cmd);
    delay_ms(5);
}
// Xuat chuoi
void outString(char *s) {
    while (*s) {
        outChar(*s);
        s++;
    }
}
// Tat con tro
void offCursor() { outCmd(0x0C); }
// Xoa man hinh
void clrscr() { outCmd(0x01); }
